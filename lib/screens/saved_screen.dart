import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Map<String, dynamic>> _savedTrips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedTrips();
  }

  Future<void> _loadSavedTrips() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTripsJson = prefs.getStringList('saved_trips') ?? [];
      
      final trips = savedTripsJson.map((json) {
        return jsonDecode(json) as Map<String, dynamic>;
      }).toList();
      
      // Sort by creation date (newest first)
      trips.sort((a, b) {
        final dateA = DateTime.parse(a['createdAt'] as String);
        final dateB = DateTime.parse(b['createdAt'] as String);
        return dateB.compareTo(dateA);
      });

      setState(() {
        _savedTrips = trips;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTrip(int index) async {
    try {
      // Get the trip to delete from the sorted list using the index
      if (index < 0 || index >= _savedTrips.length) {
        return;
      }
      
      final tripToDelete = _savedTrips[index];
      final tripToDeleteCreatedAt = tripToDelete['createdAt'] as String;
      
      // Find and remove the trip from the unsorted list in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedTrips = prefs.getStringList('saved_trips') ?? [];
      
      // Find the trip by matching createdAt timestamp
      savedTrips.removeWhere((tripJson) {
        try {
          final trip = jsonDecode(tripJson) as Map<String, dynamic>;
          return trip['createdAt'] == tripToDeleteCreatedAt;
        } catch (e) {
          return false;
        }
      });
      
      await prefs.setStringList('saved_trips', savedTrips);
      await _loadSavedTrips();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Trip deleted',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error deleting trip: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final formatter = DateFormat('MMM dd, yyyy');
      return formatter.format(date);
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Saved',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _savedTrips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No saved items',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Items you save will appear here',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSavedTrips,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _savedTrips.length,
                    itemBuilder: (context, index) {
                      final trip = _savedTrips[index];
                      final age = trip['age'] as int;
                      final budget = trip['budget'] as double;
                      final duration = trip['duration'] as int;
                      final createdAt = trip['createdAt'] as String;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Umrah Trip Plan',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatDate(createdAt),
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Delete Trip',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          content: Text(
                                            'Are you sure you want to delete this trip?',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text(
                                                'Cancel',
                                                style: GoogleFonts.poppins(),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteTrip(index);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      'Age',
                                      '$age years',
                                      Icons.person_outline,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem(
                                      'Budget',
                                      'RM ${budget.toStringAsFixed(2)}',
                                      Icons.account_balance_wallet_outlined,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem(
                                      'Duration',
                                      '$duration ${duration == 1 ? 'day' : 'days'}',
                                      Icons.calendar_today_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
