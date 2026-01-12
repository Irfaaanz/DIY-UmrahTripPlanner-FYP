import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'optimized_budget_result_screen.dart';

class ResultsScreen extends StatefulWidget {
  final String tripName;
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
    required this.tripName,
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
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {

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
              _buildProgressBar(7, 8),
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
                  _buildInfoRow('Trip Name', widget.tripName),
                  _buildInfoRow('Age', '${widget.age} years old'),
                  _buildInfoRow('Budget', 'RM ${widget.budget.toStringAsFixed(2)}'),
                  _buildInfoRow('Duration', '${widget.duration} ${widget.duration == 1 ? 'day' : 'days'}'),
                ],
              ),
              const SizedBox(height: 24),
              // Hotel Preferences Section
              _buildSection(
                title: 'Hotel Preferences',
                children: [
                  _buildInfoRow('Hotel Preference', widget.hotelPreference),
                  _buildInfoRow('Distance to Masjidil Haram', widget.hotelDistance),
                  _buildInfoRow('Room Type', widget.roomType),
                ],
              ),
              const SizedBox(height: 24),
              // Flight Preferences Section
              _buildSection(
                title: 'Flight Preferences',
                children: [
                  _buildInfoRow('Flight Preference', widget.flightPreference),
                ],
              ),
              const SizedBox(height: 24),
              // Daily Expenses Section
              _buildSection(
                title: 'Daily Expenses',
                children: [
                  _buildInfoRow('Daily Expenses Preference', widget.dailyExpensesPreference),
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
                            hotelPreference: widget.hotelPreference,
                            hotelDistance: widget.hotelDistance,
                            roomType: widget.roomType,
                            flightPreference: widget.flightPreference,
                            dailyExpensesPreference: widget.dailyExpensesPreference,
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




