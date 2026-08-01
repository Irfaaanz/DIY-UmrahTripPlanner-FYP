import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main_navigation.dart';
import '../services/trip_service.dart';
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

  final TripService _tripService = TripService();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Attempt auto-save
    await _autoSaveTrip();
  }

  Future<void> _autoSaveTrip() async {
    try {
      final tripData = _getTripData();
      
      // Check duplicate using TripService
      // Note: This is an optimization. We could just save new every time, 
      // but to prevent spamming copies on re-entry:
      // (For now, let's keep it simple: Add NEW trip every time user lands here? 
      // No, that's bad UX if they back/forth. 
      // Ideally, pass a tripId if editing, or check similar.
      // Since our new service doesn't easily check identical content without complexity,
      // We will rely on the fact the user just came from 'Optimize' flow.
      // Let's TRY to find duplicate locally in the loaded list? 
      // Actually, TripService.findDuplicateTrip is implemented.)
      
      final String? existingTripId = await _tripService.findDuplicateTrip(tripData);

      if (existingTripId == null) {
         // Create new
         if (_tripCreatedAt == null) {
            tripData['createdAt'] = DateTime.now().toIso8601String();
         }
         await _tripService.saveTrip(tripData);
         
         if (mounted) {
            setState(() {
              _isSaved = true;
              _tripCreatedAt = tripData['createdAt'] as String;
            });
         }
      } else {
         // Exists
         if (mounted) {
            setState(() {
              _isSaved = true;
              // We don't easily get the created date of the existing one without fetching details
              // but that's okay, UI just needs to show "Saved".
            });
         }
      }
    } catch (e) {
      // Log error but don't show snackbar for auto-save to ensure smooth UX
      // unless it's critical.
      debugPrint("Auto-save failed: $e");
    }
  }

  // Not strictly needed if _autoSaveTrip covers it, but kept for manual check scenarios if any
  Future<void> _checkIfSaved() async {
     // For Firestore, this is expensive to check on every load if we assume specific logic.
     // _autoSaveTrip already handles the "Check & Save" logic.
  }

  Map<String, dynamic> _getTripData() {
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
    // Manual save invoked by Share mostly
    final l10n = AppLocalizations.of(context)!;
    
    try {
      if (_isSaved) {
         if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.tripAlreadySaved),
                backgroundColor: Colors.orange,
              ),
            );
         }
         return;
      }
      
      await _autoSaveTrip(); // Re-use logic
      
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.tripSavedSuccess),
              backgroundColor: Colors.green,
            ),
          );
      }
    } catch (e) {
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorSavingTrip(e.toString())),
              backgroundColor: Colors.red,
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
