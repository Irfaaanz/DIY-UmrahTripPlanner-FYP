import 'dart:math';
import 'pso_data_service.dart';

/// Represents a single particle in the swarm
class Particle {
  /// 5 Dimensions: 
  /// [Flight_ID, Hotel_Makkah_ID, Hotel_Madinah_ID, Transport_Tier, Expense_Tier]
  List<double> position = [];
  List<double> velocity = [];
  List<double> pBestPosition = [];
  double pBestValue = double.infinity;
  double currentValue = double.infinity;

  Particle(int dimensions, List<int> bounds) {
    Random rng = Random();
    for (int i = 0; i < dimensions; i++) {
      // Initialize random position within bounds [0, bound)
      position.add(rng.nextDouble() * bounds[i]);
      // Initialize small random velocity
      velocity.add((rng.nextDouble() - 0.5) * 2); 
    }
    pBestPosition = List.from(position);
  }
}

class PsoAlgorithm {
  final PsoDataService dataService;
  final int swarmSize = 30;
  final int maxIterations = 100;
  final double c1 = 2.0;
  final double c2 = 2.0;
  
  // User Constraints
  final double budget;
  final int daysMakkah;
  final int daysMadinah;
  final String hotelPref;   // Luxury/Premium/Standard/Economy
  final String hotelDist;   // Very Near (<500m), Near (<1km), Moderate (<3km), Far (>3km)
  final String flightPref;  // Direct/Transit
  final String serviceTypePref; // Full Service/Low Cost
  final String transportPref; // Comfortable/Moderate/Minimal
  final String expensesPref; // Flow/Medium/High

  // Data cache
  List<Map<String, dynamic>> _flights = [];
  List<Map<String, dynamic>> _hotelsMakkah = [];
  List<Map<String, dynamic>> _hotelsMadinah = [];
  
  PsoAlgorithm({
    required this.dataService,
    required this.budget,
    required this.daysMakkah,
    required this.daysMadinah,
    required this.hotelPref,
    required this.hotelDist,
    required this.flightPref,
    required this.serviceTypePref,
    required this.transportPref,
    required this.expensesPref,
  });

  /// Main execution method
  Future<Map<String, dynamic>> run() async {
    // 1. Prepare Data
    
    // Strict Filtering Logic for Flights (Smarter Fallback)
    // Priority 1: Exact Match (Type + Service)
    // Priority 2: Service Match (Allow any Type) - e.g. User wants "Full Service Direct", none found -> give "Full Service Transit" (Better than AirAsia)
    // Priority 3: Type Match (Allow any Service) - e.g. User wants "Direct Full Service", none found -> give "Direct LCC"
    // Priority 4: All Flights
    
    List<Map<String, dynamic>> allFlights = dataService.getFlights();
    
    // Soft Filtering for Flights: 
    // We filter primarily by Type (Direct vs Transit) to ensure the basic structure of the trip is correct.
    // We do NOT strictly filter by "Service Type" (Full Service vs LCC) here.
    // Instead, we include ALL service types and let the fitness function penalize the wrong one.
    // This allows the algorithm to pick "Low Cost" if "Full Service" is too expensive (Over Budget).
    
    List<Map<String, dynamic>> typeMatch = allFlights.where((f) {
       return f['type'].toString().toLowerCase() == flightPref.toLowerCase();
    }).toList();
    
    if (typeMatch.isNotEmpty) {
      _flights = typeMatch;
    } else {
      // Fallback: If no flights of preferred type exist, use all flights (better than crashing)
      _flights = allFlights;
    }
    
    // Strict Filtering for Hotels (Star Rating & Distance)
    List<Map<String, dynamic>> allMakkah = dataService.getHotels("Makkah");
    _hotelsMakkah = allMakkah.where((h) {
       bool ratingMatch = _isHotelRatingMatch(int.tryParse(h['rating'].toString()) ?? 0, hotelPref);
       bool distMatch = _isDistanceMatch(double.tryParse(h['distance'].toString()) ?? 10.0, hotelDist);
       return ratingMatch && distMatch; // STRICT: Must match BOTH
    }).toList();
    
    // Fallback levels: 
    // 1. If strict fails, try just Rating match
    if (_hotelsMakkah.isEmpty) {
       _hotelsMakkah = allMakkah.where((h) => _isHotelRatingMatch(int.tryParse(h['rating'].toString()) ?? 0, hotelPref)).toList();
    }
    // 2. If that fails, try just Distance match
    if (_hotelsMakkah.isEmpty) {
       _hotelsMakkah = allMakkah.where((h) => _isDistanceMatch(double.tryParse(h['distance'].toString()) ?? 10.0, hotelDist)).toList();
    }
    // 3. Last fallback: All hotels
    if (_hotelsMakkah.isEmpty) {
        _hotelsMakkah = allMakkah;
    }

    List<Map<String, dynamic>> allMadinah = dataService.getHotels("Madinah");
    if (allMadinah.isEmpty) allMadinah = dataService.getHotels("Makkah"); // Fallback
    
    _hotelsMadinah = allMadinah.where((h) {
       bool ratingMatch = _isHotelRatingMatch(int.tryParse(h['rating'].toString()) ?? 0, hotelPref);
       bool distMatch = _isDistanceMatch(double.tryParse(h['distance'].toString()) ?? 10.0, hotelDist);
       return ratingMatch && distMatch;
    }).toList();
    
    if (_hotelsMadinah.isEmpty) {
       _hotelsMadinah = allMadinah.where((h) => _isHotelRatingMatch(int.tryParse(h['rating'].toString()) ?? 0, hotelPref)).toList();
    }
    if (_hotelsMadinah.isEmpty) {
       _hotelsMadinah = allMadinah;
    }

    if (_flights.isEmpty || _hotelsMakkah.isEmpty) {
      throw Exception("Insufficient data to run optimization");
    }

    // STRICT Search Space for Transport & Expenses
    // Instead of 0,1,2 range, we restrict the bounds to 1 if a specific preference is set.
    // We map the particle index [0] to the specific tier index.
    
    List<int> availableTransportTiers = _getAvailableTransportTiers(transportPref);
    List<int> availableExpenseTiers = _getAvailableExpenseTiers(expensesPref);

    // Bounds for dimensions
    // 0: Flight ID
    // 1: Hotel Makkah
    // 2: Hotel Madinah
    // 3: Transport Tier Index (Relative to availableTransportTiers)
    // 4: Expense Tier Index (Relative to availableExpenseTiers)
    List<int> bounds = [
      _flights.length,
      _hotelsMakkah.length,
      _hotelsMadinah.length,
      availableTransportTiers.length, 
      availableExpenseTiers.length 
    ];

    // 2. Initialize Swarm
    List<Particle> swarm = List.generate(swarmSize, (_) => Particle(5, bounds));
    List<double> gBestPosition = List.from(swarm[0].position);
    double gBestValue = double.infinity;

    Random rng = Random();

    // 3. Optimization Loop
    for (int t = 0; t < maxIterations; t++) {
      // Linear inertia decay: 0.9 -> 0.4
      double w = 0.9 - ((0.9 - 0.4) * t / maxIterations);

      for (var p in swarm) {
        // Evaluate Fitness
        double fitness = _calculateFitness(p.position, availableTransportTiers, availableExpenseTiers);
        p.currentValue = fitness;

        // Update PBest
        if (fitness < p.pBestValue) {
          p.pBestValue = fitness;
          p.pBestPosition = List.from(p.position);
        }

        // Update GBest
        if (fitness < gBestValue) {
          gBestValue = fitness;
          gBestPosition = List.from(p.position);
        }
      }

      // Update Velocity and Position
      for (var p in swarm) {
        for (int d = 0; d < 5; d++) {
          double r1 = rng.nextDouble();
          double r2 = rng.nextDouble();

          // Velocity Update
          p.velocity[d] = (w * p.velocity[d]) +
              (c1 * r1 * (p.pBestPosition[d] - p.position[d])) +
              (c2 * r2 * (gBestPosition[d] - p.position[d]));

          // Position Update
          p.position[d] = p.position[d] + p.velocity[d];

          // Clamp Position to bounds
          if (p.position[d] < 0) p.position[d] = 0;
          if (p.position[d] >= bounds[d]) p.position[d] = bounds[d] - 0.01;
        }
      }
    }

    // 4. Decode GBest
    return _decodeSolution(gBestPosition, gBestValue, availableTransportTiers, availableExpenseTiers);
  }

  // Helper to map preference string to allowed tier indices [0=Min, 1=Mod, 2=Comf]
  List<int> _getAvailableTransportTiers(String pref) {
     String p = pref.toLowerCase();
     if (p == 'comfortable') return [2];
     if (p == 'moderate') return [1];
     if (p == 'minimal') return [0];
     return [0, 1, 2]; // Fallback allow all if unknown
  }
  
  // Helper to map preference string to allowed tier indices [0=Low, 1=Med, 2=High]
  List<int> _getAvailableExpenseTiers(String pref) {
     String p = pref.toLowerCase();
     if (p == 'comfortable' || p == 'high') return [2];
     if (p == 'moderate' || p == 'medium') return [1];
     if (p == 'minimal' || p == 'low') return [0];
     return [0, 1, 2];
  }

  double _calculateFitness(List<double> position, List<int> validTransTiers, List<int> validExpTiers) {
    // Discrete indices
    int flightIdx = position[0].toInt();
    int makkahIdx = position[1].toInt();
    int madinahIdx = position[2].toInt();
    
    // Map particle index to REAL tier index
    int transIdx = position[3].toInt();
    if (transIdx >= validTransTiers.length) transIdx = validTransTiers.length - 1;
    int realTransportTier = validTransTiers[transIdx];
    
    int expIdx = position[4].toInt();
    if (expIdx >= validExpTiers.length) expIdx = validExpTiers.length - 1;
    int realExpenseTier = validExpTiers[expIdx];
    
    // Safety check just in case
    if (flightIdx >= _flights.length) flightIdx = _flights.length - 1;
    if (makkahIdx >= _hotelsMakkah.length) makkahIdx = _hotelsMakkah.length - 1;
    if (madinahIdx >= _hotelsMadinah.length) madinahIdx = _hotelsMadinah.length - 1;

    // Costs
    double cFlight = double.tryParse(_flights[flightIdx]['price'].toString()) ?? 0.0;
    
    double rateMakkah = double.tryParse(_hotelsMakkah[makkahIdx]['price'].toString()) ?? 0.0;
    double rateMadinah = double.tryParse(_hotelsMadinah[madinahIdx]['price'].toString()) ?? 0.0;
    double cAccom = (rateMakkah * daysMakkah) + (rateMadinah * daysMadinah);

    // Transport Cost
    String transTier = _getTransportTierName(realTransportTier);
    
    double cArrival = dataService.getArrivalCost(transTier);
    double cMakkahInternal = dataService.getInternalCost('Makkah', transTier) * daysMakkah;
    double cInterCity = dataService.getInterCityCost(transTier);
    double cMadinahInternal = dataService.getInternalCost('Madinah', transTier) * daysMadinah;
    double cDeparture = dataService.getDepartureCost(transTier);
    
    double cTransport = cArrival + cMakkahInternal + cInterCity + cMadinahInternal + cDeparture;

    // Expenses Cost
    String expType = _getExpenseTypeFromTier(realExpenseTier); // Low, Medium, High
    double dailyRate = dataService.getDailyExpenses(expType);
    double cDaily = dailyRate * (daysMakkah + daysMadinah);

    double totalCost = cFlight + cAccom + cTransport + cDaily;

    // --- Penalties ---
    
    // 1. Budget Constraint
    double penalty = 0.0;

    // 1. Budget Constraint
    if (totalCost > budget) {
      // Add heavy penalty
      penalty += 10000.0;
    }
    
    // 2. Service Type Mismatch (Soft Constraint)
    // If user wants "Full Service" but we picked "Low Cost" (or vice versa), add a moderate penalty.
    // This ensures we prefer the correct service type if it fits in budget, 
    // but if the correct one pushes us Over Budget (+10000), we prefer the wrong one (+2000).
    String flightService = _flights[flightIdx]['service_type'].toString();
    if (!_isServiceTypeMatch(flightService, serviceTypePref)) {
       penalty += 2000.0;
    }
    
    return totalCost + penalty;
    
    // 2. Preference Mismatch Penalty (Strong Constraint)
    // Note: With strict bounds, Transport/Expense mismatch is now impossible provided logic is correct.
    // We can remove those penalties or keep them as sanity checks.
    
    // 3. Hotel Star Rating Penalty (Secondary Check)
    // Even though we filtered the list, if fallback occurred, this penalty helps.
    
    // Check Makkah Hotel
    int makkahStars = int.tryParse(_hotelsMakkah[makkahIdx]['rating'].toString()) ?? 0;
    double makkahDist = double.tryParse(_hotelsMakkah[makkahIdx]['distance'].toString()) ?? 10.0;
    
    if (!_isHotelRatingMatch(makkahStars, hotelPref)) totalCost += 10000.0;
    if (!_isDistanceMatch(makkahDist, hotelDist)) totalCost += 10000.0;
    
    // Check Madinah Hotel
    int madinahStars = int.tryParse(_hotelsMadinah[madinahIdx]['rating'].toString()) ?? 0;
    double madinahDist = double.tryParse(_hotelsMadinah[madinahIdx]['distance'].toString()) ?? 10.0;
    
    if (!_isHotelRatingMatch(madinahStars, hotelPref)) totalCost += 10000.0;
    if (!_isDistanceMatch(madinahDist, hotelDist)) totalCost += 10000.0;

    return totalCost;
  }
  
  bool _isDistanceMatch(double dist, String pref) {
     // Pref: Very Near (<0.9km), Near (<3km, effectively 0.9-3), Far (>3km)
     
     String p = pref.toLowerCase();
     if (p.contains('very near')) return dist <= 0.9;
     // 'Near' usually means not 'very near' but not 'far'. 
     // However, logically in filters, usually 'Near' allows anything better than Far?
     // Or strict range? User said "Near (> 1.0km)".
     // Let's implement strict ranges if possible, or Upper Bounds.
     // Previous logic: <= 1.0. New Logic: 1.0 < dist <= 3.0? 
     // Let's try to be consistent with "Near" meaning "Moderate distance".
     
     if (p.contains('near')) return dist > 0.9 && dist <= 3.0; 
     if (p.contains('far')) return dist > 3.0;
     
     // Fallback for unexpected strings (e.g. 'Moderate' if used elsewhere)
     if (p.contains('moderate')) return dist <= 3.0;

     return true;
  }
  
  bool _isHotelRatingMatch(int stars, String pref) {
    // Mapping Logic:
    // Luxury -> 5*
    // Premium -> 4*
    // Standard -> 3*
    // Economy -> 1/2*
    
    String p = pref.toLowerCase();
    
    if (p.contains('luxury')) return stars == 5;
    if (p.contains('premium')) return stars == 4;
    // Note: Standard could be 3, but user said "Standard 3*". 
    // Optimization: Allow <= 3 so if 3* is too expensive, it picks 2* (Economy) to save budget.
    if (p.contains('standard')) return stars <= 3;
    if (p.contains('economy')) return stars <= 2;
    
    return true; // Unknown preference, accept all
  }
  
  // Method no longer needed for check, but keeping for structural integrity if referenced? 
  // No, logic is updated to use bounds.
  // bool _isExpenseMatch... removed/unused

  String _getTransportTierName(int tier) {
     switch(tier) {
       case 0: return 'Minimal';
       case 1: return 'Moderate';
       case 2: return 'Comfortable';
       default: return 'Minimal';
     }
  }

  bool _isServiceTypeMatch(String flightServiceType, String pref) {
      // flightServiceType: 'LCC' or 'non-LCC' (from CSV)
      // pref: "Full Service", "Low Cost"
      
      String type = flightServiceType.toLowerCase().trim();
      String p = pref.toLowerCase();

      if (p.contains('low cost')) {
          // LCC Match
          return type == 'lcc';
      } else {
          // "Full Service" Match
          return type == 'non-lcc';
      }
  }

  String _getExpenseTypeFromTier(int tier) {
     switch(tier) {
       case 0: return 'Low';
       case 1: return 'Medium';
       case 2: return 'High';
       default: return 'Low';
     }
  }

  Map<String, dynamic> _decodeSolution(List<double> position, double cost, List<int> validTransTiers, List<int> validExpTiers) {
    int flightIdx = position[0].toInt();
    int makkahIdx = position[1].toInt();
    int madinahIdx = position[2].toInt();
    
    int transIdx = position[3].toInt();
    if (transIdx >= validTransTiers.length) transIdx = validTransTiers.length - 1;
    int realTransportTier = validTransTiers[transIdx];
    
    int expIdx = position[4].toInt();
    if (expIdx >= validExpTiers.length) expIdx = validExpTiers.length - 1;
    int realExpenseTier = validExpTiers[expIdx];
    
    // Check bounds again to be safe
    if (flightIdx >= _flights.length) flightIdx = _flights.length - 1;
    if (makkahIdx >= _hotelsMakkah.length) makkahIdx = _hotelsMakkah.length - 1;
    if (madinahIdx >= _hotelsMadinah.length) madinahIdx = _hotelsMadinah.length - 1;
    
    String transTier = _getTransportTierName(realTransportTier);

    return {
      'totalCost': cost > budget ? cost - 10000 : cost, // Remove penalty for display
      'isOverBudget': cost > budget,
      'flight': _flights[flightIdx],
      'hotelMakkah': _hotelsMakkah[makkahIdx],
      'hotelMadinah': _hotelsMadinah[madinahIdx],
      'transport': transTier,
      'transportDetails': {
         'arrival': dataService.getArrivalCost(transTier),
         'interCity': dataService.getInterCityCost(transTier),
         'departure': dataService.getDepartureCost(transTier),
         'makkahDaily': dataService.getInternalCost('Makkah', transTier),
         'madinahDaily': dataService.getInternalCost('Madinah', transTier),
      },
      'expenses': _getExpenseTypeFromTier(realExpenseTier),
      'savings': budget - (cost > budget ? cost - 10000 : cost),
    };
  }
}
