import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class TripService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference? get _usersCollection => 
      _auth.currentUser != null ? _firestore.collection('users') : null;

  String? get _userId => _auth.currentUser?.uid;

  // Save a new trip or update existing one
  Future<void> saveTrip(Map<String, dynamic> tripData) async {
    if (_userId == null) throw Exception("User must be logged in to save trips");

    try {
      final String createdAt = tripData['createdAt'] ?? DateTime.now().toIso8601String();
      tripData['createdAt'] = createdAt; // Ensure createdAt is set
      tripData['updatedAt'] = DateTime.now().toIso8601String();

      // Use createdAt as the document ID for simplicity and uniqueness per user's list context
      // Alternatively, we could let Firestore generate an ID, but keeping createdAt as ID helps with de-duplication logic if needed.
      // However, Firestore auto-ID is safer. Let's use auto-ID but query by content to avoid duplicates?
      // For migration from local logic (where we checked content), let's stick to adding new docs, 
      // but maybe check if similar exists?
      // The local logic used manual content comparison.
      // Let's rely on the UI to check for existence or just add it. 
      // The implementation plan implies simple CRUD.
      
      // Let's use a subcollection 'saved_trips' under the user document
      await _usersCollection!
          .doc(_userId)
          .collection('saved_trips')
          .add(tripData);

    } catch (e) {
      if (kDebugMode) {
        print("Error saving trip to Firestore: $e");
      }
      // Re-throw to let UI handle it
      throw Exception("Failed to save trip: $e");
    }
  }

  // Check if a trip strictly exists (for auto-save prevention of duplicates)
  Future<String?> findDuplicateTrip(Map<String, dynamic> tripData) async {
    if (_userId == null) return null;

    try {
       // Note: Querying by MANY fields requires a composite index which is painful to set up dynamically.
       // Instead, we might just load all (usually small list) and check in memory, or hash the critical fields?
       // For now, let's just fetch all (assuming < 100 trips usually) and compare.
       
       final snapshot = await _usersCollection!
          .doc(_userId)
          .collection('saved_trips')
          .get();
          
       for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          
          if (data['age'] == tripData['age'] &&
              data['budget'] == tripData['budget'] &&
              data['duration'] == tripData['duration'] &&
              data['hotelPreference'] == tripData['hotelPreference'] &&
              data['roomType'] == tripData['roomType'] &&
              data['transportPreference'] == tripData['transportPreference'] &&
              data['flightPreference'] == tripData['flightPreference'] &&
              data['totalCost'] == tripData['totalCost']) { // Added totalCost check for extra uniqueness if available
             return doc.id;
          }
       }
       return null;
    } catch (e) {
      return null;
    }
  }

  // Fetch all saved trips for current user
  Stream<List<Map<String, dynamic>>> getSavedTripsStream() {
    if (_userId == null) return Stream.value([]);

    return _usersCollection!
        .doc(_userId)
        .collection('saved_trips')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Attach Document ID
        return data;
      }).toList();
    });
  }
  
  // Method to fetch once (Future) if stream is not desired
  Future<List<Map<String, dynamic>>> getSavedTrips() async {
     if (_userId == null) return [];
     
     try {
       final snapshot = await _usersCollection!
          .doc(_userId)
          .collection('saved_trips')
          .orderBy('createdAt', descending: true)
          .get();
          
       return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
     } catch (e) {
       print("Error fetching trips: $e");
       return [];
     }
  }

  // Delete a trip
  Future<void> deleteTrip(String tripId) async {
    if (_userId == null) throw Exception("User must be logged in");

    await _usersCollection!
        .doc(_userId)
        .collection('saved_trips')
        .doc(tripId)
        .delete();
  }

  // Update Trip Name
  Future<void> updateTripName(String tripId, String newName) async {
    if (_userId == null) throw Exception("User must be logged in");

    await _usersCollection!
        .doc(_userId)
        .collection('saved_trips')
        .doc(tripId)
        .update({'tripName': newName});
  }
}
