import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flight_preferences_screen.dart';
import '../l10n/generated/app_localizations.dart';

class HotelPreferencesScreen extends StatefulWidget {
  final String tripName;
  final int age;
  final double budget;
  final int duration;

  final int daysMakkah;
  final int daysMadinah;

  const HotelPreferencesScreen({
    super.key,
    required this.tripName,
    required this.age,
    required this.budget,
    required this.duration,
    required this.daysMakkah,
    required this.daysMadinah,
  });

  @override
  State<HotelPreferencesScreen> createState() => _HotelPreferencesScreenState();
}

class _HotelPreferencesScreenState extends State<HotelPreferencesScreen> {
  String? _hotelPreference;
  String? _hotelDistance;
  String? _roomType;

  final List<String> _hotelPreferences = ['Luxury', 'Premium', 'Standard', 'Economy'];
  final List<String> _hotelDistances = ['Very Near', 'Near', 'Far'];
  final List<String> _roomTypes = ['Quad', 'Triple', 'Double', 'Single'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Valid if hotel pref and distance are selected. Room type is removed from UI.
    final bool canProceed = _hotelPreference != null && _hotelDistance != null;

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
              _buildProgressBar(4, 8),
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
              // Hotel preferences heading with icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.chooseHotelPref,
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
                    'assets/icons/hotel.png',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Hotel preferences dropdown
              _buildDropdownField(
                label: l10n.hotelPref,
                hintText: l10n.pickHotelPref,
                value: _hotelPreference,
                items: _hotelPreferences,
                onChanged: (value) {
                  setState(() {
                    _hotelPreference = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Hotel distance dropdown
              _buildDropdownField(
                label: l10n.hotelDist,
                hintText: l10n.pickHotelDist,
                value: _hotelDistance,
                items: _hotelDistances,
                onChanged: (value) {
                  setState(() {
                    _hotelDistance = value;
                  });
                },
              ),
              // Room type dropdown removed as per new design

              const Spacer(),
              // Proceed button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canProceed
                        ? () {
                            // Navigate to Flight Preferences Screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FlightPreferencesScreen(
                                  tripName: widget.tripName,
                                  age: widget.age,
                                  budget: widget.budget,
                                  duration: widget.duration,
                                  daysMakkah: widget.daysMakkah,
                                  daysMadinah: widget.daysMadinah,
                                  hotelPreference: _hotelPreference!,
                                  hotelDistance: _hotelDistance!,
                                  roomType: 'Quad', // Default room type
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
                    item,
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




