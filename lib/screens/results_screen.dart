import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'optimized_budget_result_screen.dart';
import '../l10n/generated/app_localizations.dart';

class ResultsScreen extends StatefulWidget {
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

  const ResultsScreen({
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
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Mappings for display
    final Map<String, String> hotelPrefDisplay = {
      'Luxury': l10n.luxury,
      'Premium': l10n.premium,
      'Standard': l10n.standard,
      'Economy': l10n.economy,
    };

    final Map<String, String> hotelDistDisplay = {
      'Very Near': l10n.veryNear,
      'Near': l10n.near,
      'Far': l10n.far,
    };

    final Map<String, String> flightPrefDisplay = {
      'Direct': l10n.direct,
      'Transit': l10n.transit,
    };

    final Map<String, String> serviceTypeDisplay = {
      'Full Service': l10n.fullService,
      'Low Cost': l10n.lowCost,
    };

    final Map<String, String> transportPrefDisplay = {
      'Comfortable': l10n.comfortable,
      'Moderate': l10n.moderate,
      'Minimal': l10n.minimal,
    };

    final Map<String, String> dailyExpensesDisplay = {
      'Comfortable': l10n.comfortable,
      'Moderate': l10n.moderate,
      'Minimal': l10n.minimal,
    };
    
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Progress bar
              _buildProgressBar(7, 8),
              const SizedBox(height: 32),
              // Main heading
              Text(
                l10n.yourTripPreferences,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 32),
              // Basic Information Section
              _buildSection(
                title: l10n.basicInformation,
                children: [
                  _buildInfoRow(l10n.tripName, widget.tripName),
                  _buildInfoRow(l10n.age, '${widget.age} ${l10n.years}'),
                  _buildInfoRow(l10n.budget, 'RM ${widget.budget.toStringAsFixed(2)}'),
                  _buildInfoRow(l10n.duration, '${widget.duration} ${widget.duration == 1 ? l10n.day : l10n.days}'),
                ],
              ),
              const SizedBox(height: 24),
              // Hotel Preferences Section
              _buildSection(
                title: l10n.hotelPref,
                children: [
                  _buildInfoRow(l10n.hotelPref, hotelPrefDisplay[widget.hotelPreference] ?? widget.hotelPreference),
                  _buildInfoRow(l10n.hotelDistanceLabel, hotelDistDisplay[widget.hotelDistance] ?? widget.hotelDistance),
                ],
              ),
              const SizedBox(height: 24),
              // Transport & Flight Preferences Section
              _buildSection(
                title: l10n.transportPref, // Or create new string if slightly different, but re-using is fine or "Transport & Flight"
                children: [
                  _buildInfoRow(l10n.transportPref, transportPrefDisplay[widget.transportPreference] ?? widget.transportPreference),
                  _buildInfoRow(l10n.flightPref, flightPrefDisplay[widget.flightPreference] ?? widget.flightPreference),
                  _buildInfoRow(l10n.airlineServiceType, serviceTypeDisplay[widget.serviceTypePreference] ?? widget.serviceTypePreference),
                ],
              ),
              const SizedBox(height: 24),
              // Daily Expenses Section
              _buildSection(
                title: l10n.dailyExpenses,
                children: [
                  _buildInfoRow(l10n.dailyExpensesPrefLabel, dailyExpensesDisplay[widget.dailyExpensesPreference] ?? widget.dailyExpensesPreference),
                ],
              ),
              const SizedBox(height: 32),
              // Proceed button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OptimizedBudgetResultScreen(
                            tripName: widget.tripName,
                            age: widget.age,
                            budget: widget.budget,
                            duration: widget.duration,
                            daysMakkah: widget.daysMakkah,
                            daysMadinah: widget.daysMadinah,
                            hotelPreference: widget.hotelPreference,
                            hotelDistance: widget.hotelDistance,
                            roomType: widget.roomType,
                            flightPreference: widget.flightPreference,
                            serviceTypePreference: widget.serviceTypePreference,
                            transportPreference: widget.transportPreference,
                            dailyExpensesPreference: widget.dailyExpensesPreference,
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
                      l10n.proceed,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87, // Keep button text black for contrast with Cyan
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

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int currentStep, int totalSteps) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? 4 : 0,
                ),
                decoration: BoxDecoration(
                  // Use theme colors for progress bar if possible, or adapted greys
                  color: isActive 
                      ? (isDark ? Colors.grey[400] : Colors.grey[600]) 
                      : (isDark ? Colors.grey[800] : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}




