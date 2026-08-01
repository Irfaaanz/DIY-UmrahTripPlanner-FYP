import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'results_screen.dart';
import '../l10n/generated/app_localizations.dart';

class DailyExpensesScreen extends StatefulWidget {
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

  const DailyExpensesScreen({
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
  });

  @override
  State<DailyExpensesScreen> createState() => _DailyExpensesScreenState();
}

class _DailyExpensesScreenState extends State<DailyExpensesScreen> {
  String? _dailyExpensesPreference;

  final List<String> _dailyExpensesOptions = ['Comfortable', 'Moderate', 'Minimal'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final Map<String, String> dailyExpensesDisplay = {
      'Comfortable': l10n.comfortable,
      'Moderate': l10n.moderate,
      'Minimal': l10n.minimal,
    };

    final bool canProceed = _dailyExpensesPreference != null;

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
        child: Padding(
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
                l10n.letsStartJourney,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 16),
              // Daily expenses heading with icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dailyExpensesPrefTitle,
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/icons/expenses.png',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Daily expenses preference dropdown
              _buildDropdownField(
                label: l10n.dailyExpensesPrefLabel,
                hintText: l10n.pickDailyExpensesPref,
                value: _dailyExpensesPreference,
                items: _dailyExpensesOptions,
                displayMap: dailyExpensesDisplay,
                onChanged: (value) {
                  setState(() {
                    _dailyExpensesPreference = value;
                  });
                },
              ),
              const Spacer(),
              // Proceed button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canProceed
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ResultsScreen(
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
                                  dailyExpensesPreference: _dailyExpensesPreference!,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canProceed
                          ? const Color(0xFF64D2FF)
                          : theme.disabledColor,
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
                        color: canProceed ? Colors.black87 : theme.disabledColor.withOpacity(0.5),
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

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required Map<String, String> displayMap,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: theme.canvasColor,
              hint: Text(
                hintText,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: theme.hintColor,
                ),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: theme.iconTheme.color,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    displayMap[item] ?? item,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(int currentStep, int totalSteps) {
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
                  color: isActive ? Colors.grey[600] : Colors.green[300],
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




