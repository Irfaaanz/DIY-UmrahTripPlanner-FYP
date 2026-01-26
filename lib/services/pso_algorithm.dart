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
    // Filter by Type (Direct/Transit) first
    List<Map<String, dynamic>> typeFiltered = dataService.getFlights().where((f) => f['type'].toString().toLowerCase() == flightPref.toLowerCase()).toList();
    
    // Then Filter by Service Type (Full Service/Low Cost) using new CSV column
    _flights = typeFiltered.where((f) => _isServiceTypeMatch(f['service_type'].toString(), serviceTypePref)).toList();
    
    if (_flights.isEmpty) {
       // Fallback 1: Try ignoring service type, just keep flight type
       _flights = typeFiltered;
    }
    if (_flights.isEmpty) {
       // Fallback 2: All flights
       _flights = dataService.getFlights();
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

    // Bounds for dimensions
    // 0: Flight ID
    // 1: Hotel Makkah
    // 2: Hotel Madinah
    // 3: Transport Tier (0=Low, 1=Medium, 2=High)
    // 4: Expense Tier (0=Low, 1=Medium, 2=High)
    List<int> bounds = [
      _flights.length,
      _hotelsMakkah.length,
      _hotelsMadinah.length,
      3, // 0,1,2
      3  // 0,1,2
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
        double fitness = _calculateFitness(p.position);
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
    return _decodeSolution(gBestPosition, gBestValue);
  }

  double _calculateFitness(List<double> position) {
    // Discrete indices
    int flightIdx = position[0].toInt();
    int makkahIdx = position[1].toInt();
    int madinahIdx = position[2].toInt();
    int transportTier = position[3].toInt(); // 0,1,2
    int expenseTier = position[4].toInt();   // 0,1,2
    
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
    // Mapping Tier 0->Minimal, 1->Moderate, 2->Comfortable
    String transTier = _getTransportTierName(transportTier);
    
    double cArrival = dataService.getArrivalCost(transTier);
    double cMakkahInternal = dataService.getInternalCost('Makkah', transTier) * daysMakkah;
    double cInterCity = dataService.getInterCityCost(transTier);
    double cMadinahInternal = dataService.getInternalCost('Madinah', transTier) * daysMadinah;
    double cDeparture = dataService.getDepartureCost(transTier);
    
    double cTransport = cArrival + cMakkahInternal + cInterCity + cMadinahInternal + cDeparture;

    // Expenses Cost
    String expType = _getExpenseTypeFromTier(expenseTier); // Low, Medium, High
    double dailyRate = dataService.getDailyExpenses(expType);
    double cDaily = dailyRate * (daysMakkah + daysMadinah);

    double totalCost = cFlight + cAccom + cTransport + cDaily;

    // --- Penalties ---
    
    // --- Penalties ---
    
    // 1. Budget Constraint
    if (totalCost > budget) {
      // Add heavy penalty
      return totalCost + 10000.0;
    }
    
    // 2. Preference Mismatch Penalty (Strong Constraint)
    // We increased this from 500 to 10000 to ensure strict adherence unless absolutely impossible
    
    // Transport Check
    if (transTier.toLowerCase() != transportPref.toLowerCase()) {
       totalCost += 10000.0;
    }
    
    // Expense Check
    if (!_isExpenseMatch(expType, expensesPref)) {
       totalCost += 10000.0;
    }
    
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
    if (p.contains('standard')) return stars == 3;
    if (p.contains('economy')) return stars <= 2;
    
    return true; // Unknown preference, accept all
  }
  
  bool _isExpenseMatch(String particleType, String userPref) {
      // particleType: Low, Medium, High
      // userPref: Low, Medium, High (from previous screen mapping)
      // or "Minimal, Moderate, Comfortable"
      
      // Normalize
      String p = particleType.toLowerCase();
      String u = userPref.toLowerCase();
      
      if (p == 'low' && (u == 'low' || u == 'minimal')) return true;
      if (p == 'medium' && (u == 'medium' || u == 'moderate')) return true;
      if (p == 'high' && (u == 'high' || u == 'comfortable')) return true;
      
      return false;
  }

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
      
      if (pref.toLowerCase().contains('low cost')) {
          return flightServiceType == 'LCC';
      } else {
          // "Full Service"
          return flightServiceType == 'non-LCC';
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

  Map<String, dynamic> _decodeSolution(List<double> position, double cost) {
    int flightIdx = position[0].toInt();
    int makkahIdx = position[1].toInt();
    int madinahIdx = position[2].toInt();
    int transportTier = position[3].toInt();
    int expenseTier = position[4].toInt();
    
    // Check bounds again to be safe
    if (flightIdx >= _flights.length) flightIdx = _flights.length - 1;
    if (makkahIdx >= _hotelsMakkah.length) makkahIdx = _hotelsMakkah.length - 1;
    if (madinahIdx >= _hotelsMadinah.length) madinahIdx = _hotelsMadinah.length - 1;
    
    String transTier = _getTransportTierName(transportTier);

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
      'expenses': _getExpenseTypeFromTier(expenseTier),
      'savings': budget - (cost > budget ? cost - 10000 : cost),
    };
  }
}
