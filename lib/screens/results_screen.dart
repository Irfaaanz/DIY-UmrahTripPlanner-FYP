import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'personalisation_confirmation_screen.dart';

class ResultsScreen extends StatelessWidget {
  final int age;
  final double budget;
  final int duration;
  final String hotelPreference;
  final String hotelDistance;
  final String roomType;
  final String flightPreference;
  final String dailyExpensesPreference;

  const ResultsScreen({
    super.key,
    required this.age,
    required this.budget,
    required this.duration,
    required this.hotelPreference,
    required this.hotelDistance,
    required this.roomType,
    required this.flightPreference,
    required this.dailyExpensesPreference,
  });

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Progress bar
              _buildProgressBar(7, 7),
              const SizedBox(height: 32),
              // Main heading
              Text(
                "Your Trip Preferences",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              // Basic Information Section
              _buildSection(
                title: 'Basic Information',
                children: [
                  _buildInfoRow('Age', '${age} years old'),
                  _buildInfoRow('Budget', 'RM ${budget.toStringAsFixed(2)}'),
                  _buildInfoRow('Duration', '$duration ${duration == 1 ? 'day' : 'days'}'),
                ],
              ),
              const SizedBox(height: 24),
              // Hotel Preferences Section
              _buildSection(
                title: 'Hotel Preferences',
                children: [
                  _buildInfoRow('Hotel Preference', hotelPreference),
                  _buildInfoRow('Distance to Masjidil Haram', hotelDistance),
                  _buildInfoRow('Room Type', roomType),
                ],
              ),
              const SizedBox(height: 24),
              // Flight Preferences Section
              _buildSection(
                title: 'Flight Preferences',
                children: [
                  _buildInfoRow('Flight Preference', flightPreference),
                ],
              ),
              const SizedBox(height: 24),
              // Daily Expenses Section
              _buildSection(
                title: 'Daily Expenses',
                children: [
                  _buildInfoRow('Daily Expenses Preference', dailyExpensesPreference),
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
                          builder: (context) => PersonalisationConfirmationScreen(
                            age: age,
                            budget: budget,
                            duration: duration,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB3E5FC),
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

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
                color: Colors.grey[700],
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
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
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




