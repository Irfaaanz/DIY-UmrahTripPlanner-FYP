import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'personalisation_confirmation_screen.dart';
import '../services/pso_algorithm.dart';
import '../services/pso_data_service.dart';
import '../l10n/generated/app_localizations.dart';

class OptimizedBudgetResultScreen extends StatefulWidget {
  final String tripName;
  final int age;
  final double budget;
  final int duration;
  final int daysMakkah;
  final int daysMadinah;
  final String hotelPreference;
  final String hotelDistance;
  final String roomType;

  final String flightPreference;
  final String serviceTypePreference;
  final String transportPreference;
  final String dailyExpensesPreference;
  final Map<String, dynamic>? savedResult;

  const OptimizedBudgetResultScreen({
    super.key,
    required this.tripName,
    required this.age,
    required this.budget,
    required this.duration,
    required this.daysMakkah,
    required this.daysMadinah,
    required this.hotelPreference,
    required this.hotelDistance,
    required this.roomType,
    required this.flightPreference,
    required this.serviceTypePreference,

    required this.transportPreference,
    required this.dailyExpensesPreference,
    this.savedResult,
  });

  @override
  State<OptimizedBudgetResultScreen> createState() => _OptimizedBudgetResultScreenState();
}

class _OptimizedBudgetResultScreenState extends State<OptimizedBudgetResultScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _psoResult;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.savedResult != null) {
       _psoResult = widget.savedResult;
       _isLoading = false;
    } else {
       _runPsoOptimization();
    }
  }

  Future<void> _runPsoOptimization() async {
    try {
      final pso = PsoAlgorithm(
        dataService: PsoDataService(),
        budget: widget.budget,
        daysMakkah: widget.daysMakkah,
        daysMadinah: widget.daysMadinah,
        hotelPref: widget.hotelPreference,
        hotelDist: widget.hotelDistance,

        flightPref: widget.flightPreference,
        serviceTypePref: widget.serviceTypePreference,
        transportPref: widget.transportPreference,
        expensesPref: widget.dailyExpensesPreference,
      );

      // Load data if not already (it should be synchronous if cached, or async if first time)
      await PsoDataService().loadData(); 

      final result = await pso.run();

      if (mounted) {
        setState(() {
          _psoResult = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _getStarRating(BuildContext context, int rating) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.stars(rating);
  }

  String _getFlightType(BuildContext context, String? type) {
    final l10n = AppLocalizations.of(context)!;
    if (type == null) return '';
    // Normalize string to handle case differences
    final lowerType = type.toLowerCase();
    if (lowerType.contains('return')) return l10n.returnFlight;
    if (lowerType.contains('one way') || lowerType.contains('oneway')) return l10n.oneWayFlight;
    if (lowerType.contains('transit')) return l10n.transitFlight;
    if (lowerType.contains('direct')) return l10n.directFlight;
    return type;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                l10n.optimizingBudget,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("Error"),
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.textTheme.titleLarge?.color,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "An error occurred: $_errorMessage",
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
          ),
        ),
      );
    }

    final totalCost = _psoResult!['totalCost'] as double;
    final savings = _psoResult!['savings'] as double;
    final isOverBudget = _psoResult!['isOverBudget'] as bool;

    final flight = _psoResult!['flight']; // airline, price, type
    final hotelMakkah = _psoResult!['hotelMakkah']; // name, rating, price, distance
    final hotelMadinah = _psoResult!['hotelMadinah'];
    final transportType = _psoResult!['transport'];
    final expenseType = _psoResult!['expenses'];

    // Calculating individual costs for display based on PSO result
    final flightCost = double.tryParse(flight['price'].toString()) ?? 0.0;
    
    final makkahRate = double.tryParse(hotelMakkah['price'].toString()) ?? 0.0;
    final makkahCost = makkahRate * widget.daysMakkah;
    
    final madinahRate = double.tryParse(hotelMadinah['price'].toString()) ?? 0.0;
    final madinahCost = madinahRate * widget.daysMadinah;

    // Transport
    // Use the details returned from PSO solution
    final transDetails = _psoResult!['transportDetails'] as Map<String, dynamic>;
    final arrivalCost = transDetails['arrival'];
    final interCityCost = transDetails['interCity'];
    final departureCost = transDetails['departure'];
    final makkahDaily = transDetails['makkahDaily'];
    final madinahDaily = transDetails['madinahDaily'];
    
    final totalFixedTransport = arrivalCost + interCityCost + departureCost;
    final totalDailyTransport = (makkahDaily * widget.daysMakkah) + (madinahDaily * widget.daysMadinah);
    final transportCost = totalFixedTransport + totalDailyTransport;
    
    // Expenses
    final dailyRate = PsoDataService().getDailyExpenses(expenseType);
    final expenseCost = dailyRate * widget.duration;


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.iconTheme.color,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          l10n.personaliseMyTrips,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Main Heading
              Text(
                l10n.optimizedBudgetTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),
              // Big Price
              Text(
                "RM ${totalCost.toStringAsFixed(2)}",
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color, // Adapt to theme
                ),
              ),
              const SizedBox(height: 16),
              // Savings Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF96D88E), // Greenish color from image, maybe too bright for dark mode?
                  // For dark mode, maybe darken it? Or keep it as an accent. 
                  // It's a badge, so keeping it bright might be fine if text is black.
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  savings > 0 
                      ? "${l10n.savings}: RM ${savings.toStringAsFixed(2)}"
                      : (isOverBudget ? l10n.overBudget : l10n.bestPossiblePrice),
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87, // Keep black on green
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 1. Hotel Allocation
              _buildBreakdownCard(
                title: l10n.hotelAllocation,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(l10n.hotelNameMakkah, "${hotelMakkah['name']} (${widget.daysMakkah} ${l10n.days})"),
                    _buildDetailRow(l10n.hotelNameMadinah, "${hotelMadinah['name']} (${widget.daysMadinah} ${l10n.days})"),
                    _buildDetailRow(l10n.hotelNameMadinah, "${hotelMadinah['name']} (${widget.daysMadinah} ${l10n.days})"),
                    _buildDetailRow(l10n.hotelRatings, _getStarRating(context, int.tryParse(hotelMakkah['rating'].toString()) ?? 0)), 
                    _buildDetailRow(l10n.hotelDistanceLabel, hotelMakkah['distance'].toString()), 
                    _buildDetailRow(l10n.hotelDistanceLabel, hotelMakkah['distance'].toString()), 
                    _buildDetailRow(l10n.totalDaysStay, "${widget.duration} ${l10n.days}"),
                    _buildDetailRow(l10n.cost, "RM ${(makkahCost + madinahCost).toStringAsFixed(2)}"),
                  ],
                ),
              ),

              // 2. Flight Allocation
              _buildBreakdownCard(
                title: l10n.flightAllocation,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(l10n.airline, "${flight['airline']} - ${flight['Airline Name'] ?? 'Unknown'} (${l10n.returnFlight})"),
                    _buildDetailRow(l10n.type, _getFlightType(context, flight['type'])),
                    _buildDetailRow(l10n.cost, "RM ${flightCost.toStringAsFixed(2)}"),
                  ],
                ),
              ),

              // 3. Transport Allocation
              _buildBreakdownCard(
                title: l10n.transportAllocation,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(l10n.transportType, transportType),
                    _buildDetailRow(l10n.fixedTransportCost, "RM $totalFixedTransport"),
                    _buildDetailRow(l10n.dailyCommute, "RM $totalDailyTransport"),
                    _buildDetailRow(l10n.totalCost, "RM ${transportCost.toStringAsFixed(0)}"),
                  ],
                ),
              ),

              // 4. Expenses Allocation
              _buildBreakdownCard(
                title: l10n.expensesAllocation,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(l10n.tier, expenseType),
                    _buildDetailRow(l10n.dailyCost, "RM $dailyRate/day"),
                    _buildDetailRow(l10n.totalDaysLabel, "${widget.duration} ${l10n.days}"),
                    _buildDetailRow(l10n.total, "RM ${expenseCost.toStringAsFixed(0)}"),
                  ],
                ),
              ),

              // 5. Total Cost Breakdown
              _buildBreakdownCard(
                title: l10n.totalCostBreakdown,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(l10n.flightPref, "RM ${flightCost.toStringAsFixed(2)}"), // Using flightPref as label "Flight Preference" -> "Flight" approx
                    _buildDetailRow(l10n.makkahHotel, "RM ${makkahCost.toStringAsFixed(2)}"),
                    _buildDetailRow(l10n.madinahHotel, "RM ${madinahCost.toStringAsFixed(2)}"),
                    _buildDetailRow(l10n.transportation, "RM ${transportCost.toStringAsFixed(0)}"),
                    _buildDetailRow(l10n.dailyExpenses, "RM ${expenseCost.toStringAsFixed(0)}"),
                    const SizedBox(height: 8),
                    Text(
                      "${l10n.total}: RM ${totalCost.toStringAsFixed(2)}",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Save Button (Hide if already saved/viewing saved result)
              if (widget.savedResult == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PersonalisationConfirmationScreen(
                            tripName: widget.tripName,
                            age: widget.age,
                            budget: totalCost, // Pass the NEW optimized budget
                            duration: widget.duration,
                            hotelPreference: widget.hotelPreference,
                            hotelDistance: widget.hotelDistance,
                            roomType: widget.roomType,
                            flightPreference: widget.flightPreference,
                            serviceTypePreference: widget.serviceTypePreference,
                            transportPreference: widget.transportPreference,
                            dailyExpensesPreference: widget.dailyExpensesPreference,
                            optimizationResult: _psoResult!,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64D2FF), // Cyan
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.saveButton,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBreakdownCard({required String title, required Widget content}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
            border: Border.all(color: theme.dividerColor),
          ),
          child: content,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.montserrat(
            fontSize: 12, // Small text as per visual
            color: theme.textTheme.bodyLarge?.color,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: "$label : ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
