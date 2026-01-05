import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'age_input_screen.dart';

class MyTripsScreen extends StatelessWidget {
  final VoidCallback? onNavigateToHome;
  
  const MyTripsScreen({super.key, this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    // Get user name - you can make this dynamic later
    const String userName = "'Irfan";

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
              // Navigate back to homepage
              if (onNavigateToHome != null) {
                onNavigateToHome!();
              } else {
                Navigator.of(context).pop();
              }
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
              const SizedBox(height: 20),
              // Welcome message
              Text(
                "Welcome Onboards, $userName!",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              // Main heading
              Text(
                "Let's start your Umrah journey with us",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              // Travelling by Own card
              _buildTripOptionCard(
                context: context,
                title: "Are you travelling by own?",
                description: "Personalised all your budgets and planning by yourself.",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AgeInputScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Travelling by Group card
              _buildTripOptionCard(
                context: context,
                title: "Are you travelling by group?",
                description: "Personalised all the budgets and planning by a group of people.",
                onTap: () {
                  // Handle navigation to group trip planning
                  // You can add navigation logic here
                },
              ),
              const Spacer(),
              // Skip button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // Navigate back to homepage
                      if (onNavigateToHome != null) {
                        onNavigateToHome!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Skip for now',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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

  Widget _buildTripOptionCard({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black87,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

