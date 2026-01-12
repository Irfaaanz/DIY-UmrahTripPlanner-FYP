import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flight_preferences_screen.dart';

class HotelPreferencesScreen extends StatefulWidget {
  final String tripName;
  final int age;
  final double budget;
  final int duration;

  const HotelPreferencesScreen({
    super.key,
    required this.tripName,
    required this.age,
    required this.budget,
    required this.duration,
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
    final bool canProceed = _hotelPreference != null && _hotelDistance != null && _roomType != null;

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
              _buildProgressBar(4, 8),
              const SizedBox(height: 32),
              // Main heading
              Text(
                "Let's start your Umrah\njourney with us",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
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
                          "Choose your",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "hotel",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "preferences",
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
                    'assets/icons/hotel.png',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Hotel preferences dropdown
              _buildDropdownField(
                label: 'Hotel preferences',
                hintText: 'Pick your hotel preferences',
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
                label: 'Hotel distance to Masjidil Haram',
                hintText: 'Pick your hotel distance',
                value: _hotelDistance,
                items: _hotelDistances,
                onChanged: (value) {
                  setState(() {
                    _hotelDistance = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Room type dropdown
              _buildDropdownField(
                label: 'Room type',
                hintText: 'Pick your room type',
                value: _roomType,
                items: _roomTypes,
                onChanged: (value) {
                  setState(() {
                    _roomType = value;
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
                                builder: (context) => FlightPreferencesScreen(
                                  tripName: widget.tripName,
                                  age: widget.age,
                                  budget: widget.budget,
                                  duration: widget.duration,
                                  hotelPreference: _hotelPreference!,
                                  hotelDistance: _hotelDistance!,
                                  roomType: _roomType!,
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




