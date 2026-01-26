import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class PsoDataService {
  // Singleton pattern
  static final PsoDataService _instance = PsoDataService._internal();
  factory PsoDataService() => _instance;
  PsoDataService._internal();

  List<List<dynamic>> _expensesData = [];
  List<List<dynamic>> _transportData = [];
  List<List<dynamic>> _flightsData = [];
  List<List<dynamic>> _hotelData = [];
  
  bool _isLoaded = false;

  /// Loads all CSV data from assets
  Future<void> loadData() async {
    if (_isLoaded) return;

    try {
      await Future.wait([
        _loadCsv('assets/data/daily_expenses_data_myr.csv', (data) => _expensesData = data),
        _loadCsv('assets/data/transport_data_myr.csv', (data) => _transportData = data),
        _loadCsv('assets/data/umrah_flights_data.csv', (data) => _flightsData = data),
        _loadCsv('assets/data/umrah_hotel_data.csv', (data) => _hotelData = data),
      ]);
      
      _isLoaded = true;
      print('All CSV Data loaded successfully');
    } catch (e) {
      print('Error loading CSV data: $e');
    }
  }

  Future<void> _loadCsv(String path, Function(List<List<dynamic>>) onSuccess) async {
    try {
      final String rawData = await rootBundle.loadString(path);
      final List<List<dynamic>> data = const CsvToListConverter().convert(rawData, eol: '\n');
      onSuccess(data);
      print('Loaded $path: ${data.length} rows');
    } catch (e) {
      print('Failed to load $path: $e');
    }
  }

  // --- Getters for Raw Data (skipping headers usually) ---

  List<List<dynamic>> get expensesData => _expensesData.isNotEmpty ? _expensesData.sublist(1) : [];
  List<List<dynamic>> get transportData => _transportData.isNotEmpty ? _transportData.sublist(1) : [];
  List<List<dynamic>> get flightsData => _flightsData.isNotEmpty ? _flightsData.sublist(1) : [];
  List<List<dynamic>> get hotelData => _hotelData.isNotEmpty ? _hotelData.sublist(1) : [];

  // --- Helper Methods to Filter Data ---

  /// Get daily expenses based on budget type
  double getDailyExpenses(String budgetType) {
    if (_expensesData.isEmpty) return 0.0;
    // Header: Expense_Category, Budget_Type, Estimated_Daily_Cost_MYR
    // We sum up all categories for the given budget type
    
    double totalDailyCost = 0.0;
    for (var row in _expensesData.skip(1)) {
      if (row[1].toString().toLowerCase() == budgetType.toLowerCase()) {
        totalDailyCost += double.tryParse(row[2].toString()) ?? 0.0;
      }
    }
    return totalDailyCost;
  }

  /// Get transport cost for specific leg and tier
  double getTransportCost(String route, String tier) {
    if (_transportData.isEmpty) return 0.0;
    // Header: Route, Transport_Type, Budget_Type, Estimated_Cost_MYR
    // Tier in UI: 'Comfortable', 'Moderate', 'Minimal'
    // CSV Budget_Type: 'High', 'Medium', 'Low'
    // Mapping: Comfortable -> High, Moderate -> Medium, Minimal -> Low
    
    String csvBudgetParams;
    switch (tier.toLowerCase()) {
      case 'comfortable': csvBudgetParams = 'High'; break;
      case 'moderate': csvBudgetParams = 'Medium'; break;
      case 'minimal': csvBudgetParams = 'Low'; break;
      default: csvBudgetParams = 'Low';
    }

    for (var row in _transportData.skip(1)) {
       // Row[0] = Route, Row[2] = Budget_Type
       if (row[0].toString().toLowerCase().contains(route.toLowerCase()) && 
           row[2].toString().toLowerCase() == csvBudgetParams.toLowerCase()) {
         return double.tryParse(row[3].toString()) ?? 0.0;
       }
    }
    return 0.0;
  }
  
  // Specific helpers for the Algorithm
  double getArrivalCost(String tier) => getTransportCost('JED Airport-Makkah', tier);
  
  double getInterCityCost(String tier) => getTransportCost('Makkah-Madinah', tier);
  
  double getInternalCost(String city, String tier) {
    // CSV has "Makkah Internal" and "Madinah Internal"
    return getTransportCost('$city Internal', tier);
  }
  
  double getDepartureCost(String tier) {
     // Assuming departure from Madinah to MED Airport or similar
     // If variable, we might need logic. For now, let's assume Madinah-MED Airport as they end in Madinah
     // Or Makkah-JED.
     // Let's try finding 'Madinah-MED Airport' first.
     double cost = getTransportCost('Madinah-MED Airport', tier);
     if (cost == 0) return getTransportCost('Makkah-JED Airport', tier); // Fallback
     return cost;
  }

  
  /// Get all flights (optionally filtered)
  List<Map<String, dynamic>> getFlights() {
    if (_flightsData.isEmpty) return [];
    // Header: origin, destination, departure_date, return_date, airline, price_myr...
    // Indexes: 0, 1, 2, 3, 4, 5...
    
    return _flightsData.skip(1).map((row) {
      return {
        'airline': row[4],
        'price': double.tryParse(row[5].toString()) ?? 0.0,
        'type': row[8].toString() == '0' ? 'Direct' : 'Transit', // Assuming stops=0 is direct
        'Airline Name': row.length > 10 ? row[10] : 'Unknown',
        'service_type': row.length > 11 ? row[11] : 'non-LCC', // Default if missing
      };
    }).toList();
  }

  /// Get simplified hotel list based on city preference
  List<Map<String, dynamic>> getHotels(String city) {
    if (_hotelData.isEmpty) return [];
    
    // Header: id, Property Name, City, Star Rating, Total Price, Main Distance (km)
    // Indexes: 0, 1, 2, 3, 4, 5
    
    return _hotelData.skip(1).where((row) {
      final String cityInData = row[2].toString().toLowerCase();
      final String hotelName = row[1].toString().toLowerCase();
      final String requestCity = city.toLowerCase();

      // Heuristic for Madinah hotels mislabeled as Makkah
      bool isLikelyMadinah = hotelName.contains('madinah') || 
                             hotelName.contains('madina') ||
                             hotelName.contains('taiba') ||
                             hotelName.contains('anwar') ||
                             hotelName.contains('prophet') ||
                             hotelName.contains('rawda') ||
                             cityInData == 'madinah';

      if (requestCity == 'madinah') {
        return isLikelyMadinah;
      } else if (requestCity == 'makkah') {
        // Exclude likely Madinah hotels from Makkah list, unless explicitly reliable? 
        // For safety, mainly focus on fetching Madinah correctly. 
        // If row says Makkah but name says Madinah, treat as Madinah.
        return cityInData == 'makkah' && !isLikelyMadinah;
      }
      
      return cityInData == requestCity;
    }).map((row) {
      // Clean price string "MYR 991.89" -> 991.89
      double price = 0.0;
      try {
        String priceStr = row[4].toString().replaceAll('MYR', '').replaceAll(',', '').trim();
        price = double.parse(priceStr);
      } catch (e) {
        price = 0.0;
      }

      return {
        'name': row[1],
        'city': row[2],
        'rating': row[3],
        'price': price,
        'distance': double.tryParse(row[5].toString()) ?? 0.0,
      };
    }).toList();
  }
}

