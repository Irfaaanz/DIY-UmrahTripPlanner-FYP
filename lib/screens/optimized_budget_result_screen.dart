import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'personalisation_confirmation_screen.dart';

class OptimizedBudgetResultScreen extends StatelessWidget {
  final String tripName;
  final int age;
  final double budget;
  final int duration;
  final String hotelPreference;
  final String hotelDistance;
  final String roomType;
  final String flightPreference;
  final String dailyExpensesPreference;

  const OptimizedBudgetResultScreen({
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
  Widget build(BuildContext context) {
    // Dummy optimized budget data (will be replaced with actual PSO results later)
    final double optimizedBudget = budget * 0.85; // Example: 15% optimization
    final double savings = budget - optimizedBudget;

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
              _buildProgressBar(7, 8),
              const SizedBox(height: 32),
              // Main heading
              Text(
                "Overall optimised budget based on your current preferences.",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              // Optimized budget display
              Center(
                child: Column(
                  children: [
                    Text(
                      'Optimized Budget',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'RM ${optimizedBudget.toStringAsFixed(2)}',
                      style: GoogleFonts.montserrat(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Savings: RM ${savings.toStringAsFixed(2)}',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Save button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PersonalisationConfirmationScreen(
                            tripName: tripName,
                            age: age,
                            budget: optimizedBudget, // Use optimized budget
                            duration: duration,
                            hotelPreference: hotelPreference,
                            hotelDistance: hotelDistance,
                            roomType: roomType,
                            flightPreference: flightPreference,
                            dailyExpensesPreference: dailyExpensesPreference,
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
