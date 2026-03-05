import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'transport_preferences_screen.dart';
import '../l10n/generated/app_localizations.dart';

class FlightPreferencesScreen extends StatefulWidget {
  final String tripName;
  final int age;
  final double budget;
  final int duration;
  final int daysMakkah;
  final int daysMadinah;
  final String hotelPreference;
  final String hotelDistance;
  final String roomType;

  const FlightPreferencesScreen({
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
  });

  @override
  State<FlightPreferencesScreen> createState() => _FlightPreferencesScreenState();
}

class _FlightPreferencesScreenState extends State<FlightPreferencesScreen> {
  String? _flightPreference;
  String? _serviceTypePreference;

  final List<String> _flightPreferences = ['Direct', 'Transit'];
  final List<String> _serviceTypePreferences = ['Full Service', 'Low Cost'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final Map<String, String> flightPrefDisplay = {
      'Direct': l10n.direct,
      'Transit': l10n.transit,
    };

    final Map<String, String> serviceTypeDisplay = {
      'Full Service': l10n.fullService,
      'Low Cost': l10n.lowCost,
    };

    final bool canProceed = _flightPreference != null && _serviceTypePreference != null;

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
              _buildProgressBar(6, 8),
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
              // Flight preferences heading with icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.chooseFlightPref,
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
                    'assets/icons/airplane.png',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Flight preference dropdown
              _buildDropdownField(
                label: l10n.flightPref,
                hintText: l10n.pickFlightPref,
                value: _flightPreference,
                items: _flightPreferences,
                displayMap: flightPrefDisplay,
                onChanged: (value) {
                  setState(() {
                    _flightPreference = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Airline Service Type dropdown
              _buildDropdownField(
                label: l10n.airlineServiceType,
                hintText: l10n.pickServiceType,
                value: _serviceTypePreference,
                items: _serviceTypePreferences,
                displayMap: serviceTypeDisplay,
                onChanged: (value) {
                  setState(() {
                    _serviceTypePreference = value;
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
                                builder: (context) => TransportPreferencesScreen(
                                  tripName: widget.tripName,
                                  age: widget.age,
                                  budget: widget.budget,
                                  duration: widget.duration,
                                  daysMakkah: widget.daysMakkah,
                                  daysMadinah: widget.daysMadinah,
                                  hotelPreference: widget.hotelPreference,
                                  hotelDistance: widget.hotelDistance,
                                  roomType: widget.roomType,
                                  flightPreference: _flightPreference!,
                                  serviceTypePreference: _serviceTypePreference!,
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




