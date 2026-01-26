import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main_navigation.dart';
import '../l10n/generated/app_localizations.dart';

class PersonalisationConfirmationScreen extends StatefulWidget {
  final String tripName;
  final int age;
  final double budget;
  final int duration;
  final String hotelPreference;
  final String hotelDistance;
  final String roomType;
  final String transportPreference;
  final String flightPreference;
  final String serviceTypePreference;
  final String dailyExpensesPreference;
  final Map<String, dynamic> optimizationResult;

  const PersonalisationConfirmationScreen({
    super.key,
    required this.tripName,
    required this.age,
    required this.budget,
    required this.duration,
    required this.hotelPreference,
    required this.hotelDistance,
    required this.roomType,
    required this.transportPreference,
    required this.flightPreference,
    required this.serviceTypePreference,
    required this.dailyExpensesPreference,
    required this.optimizationResult,
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
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _checkIfSaved();
    // Auto-save trip when confirmation screen appears (silently)
    await _autoSaveTrip();
  }

  Future<void> _autoSaveTrip() async {
    try {
      // Check if trip already exists
      final prefs = await SharedPreferences.getInstance();
      final savedTrips = prefs.getStringList('saved_trips') ?? [];
      
      // Check if a trip with the same data already exists
      bool tripExists = false;
      String? existingCreatedAt;
      
      for (final tripJson in savedTrips) {
        try {
          final trip = jsonDecode(tripJson) as Map<String, dynamic>;
          if (trip['age'] == widget.age &&
              trip['budget'] == widget.budget &&
              trip['duration'] == widget.duration &&
              trip['hotelPreference'] == widget.hotelPreference &&
              trip['hotelDistance'] == widget.hotelDistance &&
              trip['roomType'] == widget.roomType &&
              trip['transportPreference'] == widget.transportPreference &&
              trip['flightPreference'] == widget.flightPreference &&
              trip['serviceTypePreference'] == widget.serviceTypePreference &&
              trip['dailyExpensesPreference'] == widget.dailyExpensesPreference) {
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
      } else {
        // Trip already exists, update state
        setState(() {
          _isSaved = true;
          _tripCreatedAt = existingCreatedAt;
        });
      }
    } catch (e) {
      // Silent fail for auto-save
    }
  }

  Future<void> _checkIfSaved() async {
    // Check if this trip is already saved by comparing trip data
    final prefs = await SharedPreferences.getInstance();
    final savedTrips = prefs.getStringList('saved_trips') ?? [];
    
    // Compare trips by all fields (excluding timestamp)
    bool found = false;
    String? existingCreatedAt;
    
    for (final tripJson in savedTrips) {
      try {
        final trip = jsonDecode(tripJson) as Map<String, dynamic>;
        if (trip['age'] == widget.age &&
            trip['budget'] == widget.budget &&
            trip['duration'] == widget.duration &&
            trip['hotelPreference'] == widget.hotelPreference &&
            trip['hotelDistance'] == widget.hotelDistance &&
            trip['roomType'] == widget.roomType &&
            trip['transportPreference'] == widget.transportPreference &&
            trip['flightPreference'] == widget.flightPreference &&
            trip['serviceTypePreference'] == widget.serviceTypePreference &&
            trip['dailyExpensesPreference'] == widget.dailyExpensesPreference) {
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
      'tripName': widget.tripName,
      'age': widget.age,
      'budget': widget.budget,
      'duration': widget.duration,
      'hotelPreference': widget.hotelPreference,
      'hotelDistance': widget.hotelDistance,
      'roomType': widget.roomType,
      'transportPreference': widget.transportPreference,
      'flightPreference': widget.flightPreference,
      'serviceTypePreference': widget.serviceTypePreference,
      'dailyExpensesPreference': widget.dailyExpensesPreference,
      'optimizationResult': widget.optimizationResult,
      'createdAt': _tripCreatedAt ?? DateTime.now().toIso8601String(),
    };
  }

  Future<void> _saveTrip() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Check if trip already exists by comparing age, budget, and duration
      final prefs = await SharedPreferences.getInstance();
      final savedTrips = prefs.getStringList('saved_trips') ?? [];
      
      // Check if a trip with the same data already exists
      bool tripExists = false;
      String? existingCreatedAt;
      
      for (final tripJson in savedTrips) {
        try {
          final trip = jsonDecode(tripJson) as Map<String, dynamic>;
          if (trip['age'] == widget.age &&
              trip['budget'] == widget.budget &&
              trip['duration'] == widget.duration &&
              trip['hotelPreference'] == widget.hotelPreference &&
              trip['hotelDistance'] == widget.hotelDistance &&
              trip['roomType'] == widget.roomType &&
              trip['transportPreference'] == widget.transportPreference &&
              trip['flightPreference'] == widget.flightPreference &&
              trip['serviceTypePreference'] == widget.serviceTypePreference &&
              trip['dailyExpensesPreference'] == widget.dailyExpensesPreference) {
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
                l10n.tripSavedSuccess,
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
                l10n.tripAlreadySaved,
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
              l10n.errorSavingTrip(e.toString()),
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
    final l10n = AppLocalizations.of(context)!;
    try {
      // Save trip data first
      await _saveTrip();
      
      // Format trip data for sharing
      final budgetFormatted = widget.budget.toStringAsFixed(2);
      final shareText = '''
${widget.tripName}

Age: ${widget.age} years old
Budget: RM $budgetFormatted
Duration: ${widget.duration} ${widget.duration == 1 ? 'day' : 'days'}

Hotel: ${widget.hotelPreference} - ${widget.hotelDistance}
Transport: ${widget.transportPreference}
Flight: ${widget.flightPreference} (${widget.serviceTypePreference})
Daily Expenses: ${widget.dailyExpensesPreference}

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
              l10n.errorSharingTrip(e.toString()),
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

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
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: theme.iconTheme.color,
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
                decoration: BoxDecoration(
                  color: isDark ? theme.colorScheme.primary : Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: isDark ? Colors.black : Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 32),
              // Congratulatory message
              Text(
                l10n.congratsTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              // Description text
              Text(
                l10n.congratsSubtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: theme.textTheme.bodyLarge?.color,
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
                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.goToSavedTrips,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
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
                          backgroundColor: const Color(0xFF64D2FF), // Cyan
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.done,
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
