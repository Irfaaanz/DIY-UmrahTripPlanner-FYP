import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'optimized_budget_result_screen.dart';
import '../services/trip_service.dart';
import '../l10n/generated/app_localizations.dart';

enum SortOption { date, nameAsc, nameDesc }

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final TripService _tripService = TripService();
  List<Map<String, dynamic>> _savedTrips = [];
  bool _isLoading = true;
  SortOption _currentSort = SortOption.date;
  
  // Selection Mode State
  bool _isSelectionMode = false;
  final Set<String> _selectedTripIds = {}; // Using Document ID as ID

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
      final trips = await _tripService.getSavedTrips();
      
      // Sort based on current option
      _sortTripsList(trips);

      if (mounted) {
        setState(() {
          _savedTrips = trips;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _sortTripsList(List<Map<String, dynamic>> trips) {
    switch (_currentSort) {
      case SortOption.date:
        trips.sort((a, b) {
          DateTime dateA;
          DateTime dateB;
          try {
             dateA = DateTime.parse(a['createdAt'].toString());
          } catch (_) {
             dateA = DateTime(2000); // Fallback old date
          }
          try {
             dateB = DateTime.parse(b['createdAt'].toString());
          } catch (_) {
             dateB = DateTime(2000);
          }
          return dateB.compareTo(dateA); // Newest first
        });
        break;
      case SortOption.nameAsc:
        trips.sort((a, b) {
          final nameA = (a['tripName'] as String? ?? '').toLowerCase();
          final nameB = (b['tripName'] as String? ?? '').toLowerCase();
          return nameA.compareTo(nameB);
        });
        break;
      case SortOption.nameDesc:
        trips.sort((a, b) {
          final nameA = (a['tripName'] as String? ?? '').toLowerCase();
          final nameB = (b['tripName'] as String? ?? '').toLowerCase();
          return nameB.compareTo(nameA);
        });
        break;
    }
  }

  Future<void> _deleteTrip(int index) async {
    try {
      if (index < 0 || index >= _savedTrips.length) return;
      
      final tripToDelete = _savedTrips[index];
      final tripId = tripToDelete['id'] as String?;
      
      if (tripId == null) return;
      
      await _tripService.deleteTrip(tripId);
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

  Future<void> _deleteSelectedTrips() async {
    try {
      if (_selectedTripIds.isEmpty) return;

      for (var id in _selectedTripIds) {
          await _tripService.deleteTrip(id);
      }
      
      setState(() {
         _selectedTripIds.clear();
         _isSelectionMode = false;
      });
      
      await _loadSavedTrips();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Selected trips deleted',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Error handling
    }
  }

  void _navigateToTripDetails(Map<String, dynamic> trip) {
    if (trip['optimizationResult'] != null) {
      // New format with saved results
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OptimizedBudgetResultScreen(
            tripName: trip['tripName']?.toString() ?? 'Trip',
            age: int.tryParse(trip['age'].toString()) ?? 25,
            budget: double.tryParse(trip['budget'].toString()) ?? 5000.0,
            duration: int.tryParse(trip['duration'].toString()) ?? 10,
            daysMakkah: 0, // Not needed as loaded from result
            daysMadinah: 0, // Not needed as loaded from result
            hotelPreference: trip['hotelPreference']?.toString() ?? 'Standard',
            hotelDistance: trip['hotelDistance']?.toString() ?? 'Moderate',
            roomType: trip['roomType']?.toString() ?? 'Quad',
            flightPreference: trip['flightPreference']?.toString() ?? 'Direct',
            serviceTypePreference: trip['serviceTypePreference']?.toString() ?? 'Full Service',
            transportPreference: trip['transportPreference']?.toString() ?? 'Moderate',
            dailyExpensesPreference: trip['dailyExpensesPreference']?.toString() ?? 'Medium',
            savedResult: Map<String, dynamic>.from(trip['optimizationResult']),
          ),
        ),
      );
    } else {
      // Old format (without saved result) - Show alert
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This trip was saved before the update and cannot be retrieved exactly. Please create a new trip.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: _isSelectionMode
            ? IconButton(
                icon: Icon(Icons.close, color: theme.iconTheme.color),
                onPressed: () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedTripIds.clear();
                  });
                },
              )
            : null,
        title: Text(
          _isSelectionMode ? l10n.selected(_selectedTripIds.length) : l10n.saved,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _selectedTripIds.isEmpty ? null : _deleteSelectedTrips,
            )
          else ...[
             // Sort Menu
            PopupMenuButton<SortOption>(
              icon: Icon(Icons.sort, color: theme.iconTheme.color),
              color: theme.cardColor,
              onSelected: (SortOption result) {
                setState(() {
                  _currentSort = result;
                  _sortTripsList(_savedTrips);
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
                PopupMenuItem<SortOption>(
                  value: SortOption.date,
                  child: Text(
                    l10n.dateNewestFirst,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  ),
                ),
                PopupMenuItem<SortOption>(
                  value: SortOption.nameAsc,
                  child: Text(
                    l10n.nameAZ,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
                  onRefresh: _loadSavedTrips,
                  child: _savedTrips.isEmpty 
                    ? ListView( // Wrap in ListView to allow RefreshIndicator to work
                        children: [
                           SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                           Center(
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
                                  l10n.noSavedItems,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  l10n.itemsWillAppearHere,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                           )
                        ],
                      )
                    : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _savedTrips.length,
                    itemBuilder: (context, index) {
                      final trip = _savedTrips[index];
                      final tripId = trip['id'] as String; // Firestore ID
                      final tripName = trip['tripName'] as String? ?? 'Umrah Trip Plan';
                      final age = trip['age'] as int? ?? 0;
                      final budget = double.tryParse(trip['budget'].toString()) ?? 0.0;
                      final duration = trip['duration'] as int? ?? 0;
                      final createdAt = trip['createdAt'] as String? ?? '';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        color: theme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onLongPress: () {
                            setState(() {
                              _isSelectionMode = true;
                              _selectedTripIds.add(tripId);
                            });
                          },
                          onTap: () {
                            if (_isSelectionMode) {
                              setState(() {
                                if (_selectedTripIds.contains(tripId)) {
                                  _selectedTripIds.remove(tripId);
                                  if (_selectedTripIds.isEmpty) {
                                    _isSelectionMode = false;
                                  }
                                } else {
                                  _selectedTripIds.add(tripId);
                                }
                              });
                            } else {
                              _navigateToTripDetails(trip);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _isSelectionMode && _selectedTripIds.contains(tripId)
                                  ? theme.primaryColor.withOpacity(0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                                            tripName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: theme.textTheme.titleLarge?.color,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(createdAt),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_isSelectionMode)
                                      Checkbox(
                                        value: _selectedTripIds.contains(tripId),
                                        activeColor: theme.primaryColor,
                                        onChanged: (val) {
                                          setState(() {
                                            if (val == true) {
                                              _selectedTripIds.add(tripId);
                                            } else {
                                              _selectedTripIds.remove(tripId);
                                              if (_selectedTripIds.isEmpty) {
                                                _isSelectionMode = false;
                                              }
                                            }
                                          });
                                        },
                                      )
                                    else
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit_outlined,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              _showEditTripNameDialog(context, index, tripName);
                                            },
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
                                                  backgroundColor: theme.canvasColor,
                                                  title: Text(
                                                    l10n.deleteTrip,
                                                    style: GoogleFonts.poppins(color: theme.textTheme.titleLarge?.color),
                                                  ),
                                                  content: Text(
                                                    l10n.areYouSureDelete,
                                                    style: GoogleFonts.poppins(color: theme.textTheme.bodyLarge?.color),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text(
                                                        l10n.cancel,
                                                        style: GoogleFonts.poppins(
                                                          color: Colors.grey[700],
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _deleteTrip(index);
                                                      },
                                                      child: Text(
                                                        l10n.delete,
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
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Divider(color: Colors.grey[300]),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(
                                        l10n.age,
                                        '$age ${l10n.years}',
                                        Icons.person_outline,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoItem(
                                        l10n.budget,
                                        'RM ${budget.toStringAsFixed(2)}',
                                        Icons.account_balance_wallet_outlined,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildInfoItem(
                                        l10n.duration,
                                        '$duration ${duration == 1 ? l10n.day : l10n.days}',
                                        Icons.calendar_today_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ],
    );
  }

  Future<void> _showEditTripNameDialog(BuildContext context, int index, String currentName) async {
    final TextEditingController nameController = TextEditingController(text: currentName);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.canvasColor,
        title: Text(
          l10n.editTripName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: GoogleFonts.poppins(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: l10n.enterTripName,
            hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onSubmitted: (value) {
            final newName = value.trim();
            if (newName.isNotEmpty) {
              Navigator.pop(context, newName);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                Navigator.pop(context, newName);
              }
            },
            child: Text(
              l10n.save,
              style: GoogleFonts.poppins(
                color: const Color(0xFF036B52),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    
    nameController.dispose();
    
    if (result != null && result.isNotEmpty) {
      await _updateTripName(index, result);
    }
  }

  Future<void> _updateTripName(int index, String newName) async {
    try {
      if (index < 0 || index >= _savedTrips.length) return;
      
      final trip = _savedTrips[index];
      final tripId = trip['id'] as String?;
      
      if (tripId != null) {
          await _tripService.updateTripName(tripId, newName);
          await _loadSavedTrips();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Trip name updated',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.green,
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
              'Error updating trip name: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
