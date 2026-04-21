import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class ProfileService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static const String _collectionName = 'users';

  // Get current user's UID
  static Future<String?> _getCurrentUserId() async {
    final user = await AuthService.getCurrentUser();
    return user?['uid'] as String?;
  }

  // Get profile data for current user
  static Future<Map<String, dynamic>?> getProfileData() async {
    try {
      final uid = await _getCurrentUserId();
      if (uid == null) return null;

      final docSnapshot = await _firestore.collection(_collectionName).doc(uid).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error getting profile data: $e');
      return null;
    }
  }

  // Upload profile image to Firebase Storage and return URL
  static Future<String?> uploadProfileImage(dynamic imageFile) async {
    try {
      final uid = await _getCurrentUserId();
      if (uid == null) return null;

      final String fileName = 'profile_$uid.jpg';
      final Reference ref = _storage.ref().child('profile_images').child(fileName);
      
      TaskSnapshot snapshot;
      if (kIsWeb) {
         // On web, imageFile is expected to be a XFile path (which is a blob url) or bytes? 
         // Actually, cross-platform ImagePicker returns XFile. 
         // For web upload, we ideally need bytes or the blob.
         // However, standard File(path) doesn't work on web.
         // We should change the argument to accept XFile directly for better cross-platform support.
         // Or strictly bytes.
         // Let's assume the caller passes XFile for now, or we handle it in UI. 
         // Wait, the previous UI code passed a path string.
         // Let's make this method accept XFile to be robust.
         return null; // Should be handled via dedicated method accepting XFile or Uint8List
      } else {
        // Mobile
        final file = File(imageFile as String);
        snapshot = await ref.putFile(file);
      }
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
  
  // New method needed: Upload XFile (works for web and mobile)
  static Future<String?> uploadProfileImageXFile(dynamic xFile) async {
     try {
      final uid = await _getCurrentUserId();
      if (uid == null) return null;

      // Import cross_file or image_picker dependency if needed, but 'dynamic' for now 
      // strictly to avoid import errors if not checking type, but better to use bytes.
      // Let's use readAsBytes which is cross platform on XFile.
      
      // We need to know if it's XFile.
      // Assuming caller passes XFile.
      
      final String fileName = 'profile_$uid.jpg';
      final Reference ref = _storage.ref().child('profile_images').child(fileName);
      
      // XFile has readAsBytes()
      final bytes = await xFile.readAsBytes();
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      
      final snapshot = await ref.putData(bytes, metadata);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image XFile: $e');
      return null;
    }
  }

  // Save profile data for current user
  static Future<bool> saveProfileData({
    String? displayName,
    String? fullName,
    String? gender,
    String? phoneNo,
    String? profileImagePath, // This should now be a URL if updated via upload
  }) async {
    try {
      final uid = await _getCurrentUserId();
      if (uid == null) return false;

      final docRef = _firestore.collection(_collectionName).doc(uid);
      
      final Map<String, dynamic> dataToUpdate = {
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (fullName != null) dataToUpdate['fullName'] = fullName;
      if (gender != null) dataToUpdate['gender'] = gender;
      if (phoneNo != null) dataToUpdate['phoneNo'] = phoneNo;
      if (profileImagePath != null) dataToUpdate['profileImagePath'] = profileImagePath;
      
      // Use set with merge: true to create if not exists or update fields
      await docRef.set(dataToUpdate, SetOptions(merge: true));
      
      // Update display name in Firebase Auth
      if (displayName != null) {
        // We can't update auth directly here comfortably without Auth instance, 
        // effectively we expect AuthService to handle auth updates, 
        // but for compatibility with existing code:
        await AuthService.updateDisplayName(displayName);
        
        // Also save to firestore
        await docRef.update({'displayName': displayName});
      }
      
      return true;
    } catch (e) {
      debugPrint('Error saving profile data: $e');
      return false;
    }
  }

  // Update password (wrapper for AuthService)
  static Future<bool> updatePassword(String newPassword) async {
    return await AuthService.updatePassword(newPassword);
  }

  // Get full profile (including auth data)
  static Future<Map<String, dynamic>?> getFullProfile() async {
    try {
      final user = await AuthService.getCurrentUser();
      if (user == null) return null;

      final profileData = await getProfileData();
      
      return {
        'displayName': user['displayName'] as String? ?? '',
        'email': user['email'] as String? ?? '',
        'fullName': profileData?['fullName'] as String? ?? '',
        'gender': profileData?['gender'] as String? ?? '',
        'phoneNo': profileData?['phoneNo'] as String? ?? '',
        'profileImagePath': profileData?['profileImagePath'] as String?,
        'password': '**********', // Masked password
      };
    } catch (e) {
      return null;
    }
  }
}

