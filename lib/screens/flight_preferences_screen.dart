import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daily_expenses_screen.dart';

class FlightPreferencesScreen extends StatefulWidget {
  final int age;
  final double budget;
  final int duration;
  final String hotelPreference;
  final String hotelDistance;
  final String roomType;

  const FlightPreferencesScreen({
    super.key,
    required this.age,
    required this.budget,
    required this.duration,
    required this.hotelPreference,
    required this.hotelDistance,
    required this.roomType,
  });

  @override
  State<FlightPreferencesScreen> createState() => _FlightPreferencesScreenState();
}

class _FlightPreferencesScreenState extends State<FlightPreferencesScreen> {
  String? _flightPreference;

  final List<String> _flightPreferences = ['Direct', 'Transit', 'No Preference'];

  @override
  Widget build(BuildContext context) {
    final bool canProceed = _flightPreference != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          'Personalise My Trips',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
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
              _buildProgressBar(5, 7),
              const SizedBox(height: 32),
              // Main heading
              Text(
                "Let's start your Umrah journey with us",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
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
                          "Choose your",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "flight preferences",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
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
                label: 'Flight preference',
                hintText: 'Pick your flight preferences',
                value: _flightPreference,
                items: _flightPreferences,
                onChanged: (value) {
                  setState(() {
                    _flightPreference = value;
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
                                builder: (context) => DailyExpensesScreen(
                                  age: widget.age,
                                  budget: widget.budget,
                                  duration: widget.duration,
                                  hotelPreference: widget.hotelPreference,
                                  hotelDistance: widget.hotelDistance,
                                  roomType: widget.roomType,
                                  flightPreference: _flightPreference!,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canProceed
                          ? const Color(0xFFB3E5FC)
                          : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Proceed',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: canProceed ? Colors.black87 : Colors.grey[600],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hintText,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[400],
                ),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black87,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
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




