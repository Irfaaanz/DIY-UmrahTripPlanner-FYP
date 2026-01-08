import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main_navigation.dart';

class PersonalisationConfirmationScreen extends StatefulWidget {
  final int age;
  final double budget;
  final int duration;

  const PersonalisationConfirmationScreen({
    super.key,
    required this.age,
    required this.budget,
    required this.duration,
  });

  @override
  State<PersonalisationConfirmationScreen> createState() => _PersonalisationConfirmationScreenState();
}

class _PersonalisationConfirmationScreenState extends State<PersonalisationConfirmationScreen> {
  bool _isSaved = false;
  String? _tripCreatedAt;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    // Check if this trip is already saved by comparing trip data without timestamp
    final prefs = await SharedPreferences.getInstance();
    final savedTrips = prefs.getStringList('saved_trips') ?? [];
    
    // Compare trips by age, budget, and duration (excluding timestamp)
    bool found = false;
    String? existingCreatedAt;
    
    for (final tripJson in savedTrips) {
      try {
        final trip = jsonDecode(tripJson) as Map<String, dynamic>;
        if (trip['age'] == widget.age &&
            trip['budget'] == widget.budget &&
            trip['duration'] == widget.duration) {
          found = true;
          existingCreatedAt = trip['createdAt'] as String;
          break;
        }
      } catch (e) {
        continue;
      }
    }
    
    setState(() {
      _isSaved = found;
      _tripCreatedAt = existingCreatedAt;
    });
  }

  Map<String, dynamic> _getTripData() {
    // Use existing timestamp if trip was already saved, otherwise create new one
    return {
      'age': widget.age,
      'budget': widget.budget,
      'duration': widget.duration,
      'createdAt': _tripCreatedAt ?? DateTime.now().toIso8601String(),
    };
  }

  Future<void> _saveTrip() async {
    try {
      // Check if trip already exists by comparing age, budget, and duration
      final prefs = await SharedPreferences.getInstance();
      final savedTrips = prefs.getStringList('saved_trips') ?? [];
      
      // Check if a trip with the same age, budget, and duration already exists
      bool tripExists = false;
      String? existingCreatedAt;
      
      for (final tripJson in savedTrips) {
        try {
          final trip = jsonDecode(tripJson) as Map<String, dynamic>;
          if (trip['age'] == widget.age &&
              trip['budget'] == widget.budget &&
              trip['duration'] == widget.duration) {
            tripExists = true;
            existingCreatedAt = trip['createdAt'] as String;
            break;
          }
        } catch (e) {
          continue;
        }
      }
      
      if (!tripExists) {
        // Create new trip with new timestamp
        final tripData = _getTripData();
        // If we don't have an existing timestamp, generate a new one
        if (_tripCreatedAt == null) {
          tripData['createdAt'] = DateTime.now().toIso8601String();
        }
        final tripJson = jsonEncode(tripData);
        savedTrips.add(tripJson);
        await prefs.setStringList('saved_trips', savedTrips);
        
        setState(() {
          _isSaved = true;
          _tripCreatedAt = tripData['createdAt'] as String;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Trip saved successfully!',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Trip already exists, update the state to reflect this
        setState(() {
          _isSaved = true;
          _tripCreatedAt = existingCreatedAt;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Trip already saved!',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error saving trip: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _shareTrip() async {
    try {
      // Save trip data first
      await _saveTrip();
      
      // Format trip data for sharing
      final budgetFormatted = widget.budget.toStringAsFixed(2);
      final shareText = '''
Umrah Trip Plan

Age: ${widget.age} years old
Budget: RM $budgetFormatted
Duration: ${widget.duration} ${widget.duration == 1 ? 'day' : 'days'}

Created with Umrah Trip Planner
''';

      // Share using native share sheet (iOS/Android)
      await Share.share(
        shareText,
        subject: 'My Umrah Trip Plan',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error sharing trip: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _navigateToSavedTrips() {
    // Navigate to MainNavigation and switch to Saved tab (index 2)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainNavigation(initialIndex: 2),
      ),
      (route) => false,
    );
  }

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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.black,
              size: 22,
            ),
            onPressed: _shareTrip,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large checkmark icon in circle
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 32),
              // Congratulatory message
              Text(
                'Congrats! You have\npersonalised Umrah trips\nonboards!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              // Description text
              Text(
                'Now you can have a wonderful Umrah\njourney insights.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Action buttons at the bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    // Go to saved trips button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _navigateToSavedTrips,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Go to saved trips',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Done button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate back to home screen
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const MainNavigation(),
                            ),
                            (route) => false,
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
                          'Done',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
