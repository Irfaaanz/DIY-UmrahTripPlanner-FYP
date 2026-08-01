import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daily_expenses_screen.dart';
import '../l10n/generated/app_localizations.dart';

class TransportPreferencesScreen extends StatefulWidget {
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

  const TransportPreferencesScreen({
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
  });

  @override
  State<TransportPreferencesScreen> createState() => _TransportPreferencesScreenState();
}

class _TransportPreferencesScreenState extends State<TransportPreferencesScreen> {
  String? _transportPreference;
  final List<String> _transportPreferences = ['Comfortable', 'Moderate', 'Minimal'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final Map<String, String> transportPrefDisplay = {
      'Comfortable': l10n.comfortable,
      'Moderate': l10n.moderate,
      'Minimal': l10n.minimal,
    };

    final bool canProceed = _transportPreference != null;

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
              _buildProgressBar(5, 8),
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
              // Transport heading with icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.chooseTransportPref,
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
                  Icon(
                    Icons.directions_car_outlined,
                    size: 80,
                    color: theme.iconTheme.color,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Transport preference dropdown
              Text(
                l10n.transportPref,
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
                    bottom: BorderSide(color: theme.dividerColor, width: 1),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _transportPreference,
                    dropdownColor: theme.canvasColor,
                    hint: Text(
                      l10n.pickTransportPref,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.hintColor,
                      ),
                    ),
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, color: theme.iconTheme.color),
                    items: _transportPreferences.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          transportPrefDisplay[item] ?? item,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _transportPreference = value;
                      });
                    },
                  ),
                ),
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
                                builder: (context) => DailyExpensesScreen(
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
                                  transportPreference: _transportPreference!,
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
                  color: isActive ? Colors.grey[600] : Colors.grey[300],
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
