import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'auth_service.dart';

class ProfileService {
  static const String _profileDataKey = 'user_profile_data';

  // Get current user's email
  static Future<String?> _getCurrentUserEmail() async {
    final user = await AuthService.getCurrentUser();
    return user?['email'] as String?;
  }

  // Get profile data for current user
  static Future<Map<String, dynamic>?> getProfileData() async {
    try {
      final email = await _getCurrentUserEmail();
      if (email == null) return null;

      final prefs = await SharedPreferences.getInstance();
      final profileDataJson = prefs.getString(_profileDataKey);
      
      if (profileDataJson == null) return null;

      final allProfiles = jsonDecode(profileDataJson) as Map<String, dynamic>;
      return allProfiles[email] as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  // Save profile data for current user
  static Future<bool> saveProfileData({
    String? displayName,
    String? fullName,
    String? gender,
    String? phoneNo,
  }) async {
    try {
      final email = await _getCurrentUserEmail();
      if (email == null) return false;

      final prefs = await SharedPreferences.getInstance();
      final profileDataJson = prefs.getString(_profileDataKey);
      
      Map<String, dynamic> allProfiles = {};
      if (profileDataJson != null) {
        allProfiles = jsonDecode(profileDataJson) as Map<String, dynamic>;
      }

      // Get existing profile or create new one
      Map<String, dynamic> userProfile = allProfiles[email] as Map<String, dynamic>? ?? {};
      
      // Update only provided fields
      if (fullName != null) userProfile['fullName'] = fullName;
      if (gender != null) userProfile['gender'] = gender;
      if (phoneNo != null) userProfile['phoneNo'] = phoneNo;
      
      userProfile['updatedAt'] = DateTime.now().toIso8601String();
      
      allProfiles[email] = userProfile;
      await prefs.setString(_profileDataKey, jsonEncode(allProfiles));
      
      // Update display name in auth service if provided
      if (displayName != null) {
        final usersJson = prefs.getStringList('registered_users') ?? [];
        for (int i = 0; i < usersJson.length; i++) {
          final user = jsonDecode(usersJson[i]) as Map<String, dynamic>;
          if (user['email'] == email) {
            user['displayName'] = displayName;
            usersJson[i] = jsonEncode(user);
            await prefs.setStringList('registered_users', usersJson);
            
            // Update current user session
            final currentUserJson = prefs.getString('current_user');
            if (currentUserJson != null) {
              final currentUser = jsonDecode(currentUserJson) as Map<String, dynamic>;
              if (currentUser['email'] == email) {
                currentUser['displayName'] = displayName;
                await prefs.setString('current_user', jsonEncode(currentUser));
              }
            }
            break;
          }
        }
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update password
  static Future<bool> updatePassword(String newPassword) async {
    try {
      final email = await _getCurrentUserEmail();
      if (email == null) return false;

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList('registered_users') ?? [];
      
      // Find and update user password
      for (int i = 0; i < usersJson.length; i++) {
        final user = jsonDecode(usersJson[i]) as Map<String, dynamic>;
        if (user['email'] == email) {
          user['password'] = newPassword; // In production, hash this password
          usersJson[i] = jsonEncode(user);
          await prefs.setStringList('registered_users', usersJson);
          
          // Update current user session
          final currentUserJson = prefs.getString('current_user');
          if (currentUserJson != null) {
            final currentUser = jsonDecode(currentUserJson) as Map<String, dynamic>;
            if (currentUser['email'] == email) {
              currentUser['password'] = newPassword;
              await prefs.setString('current_user', jsonEncode(currentUser));
            }
          }
          
          return true;
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
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
        'password': '**********', // Masked password
      };
    } catch (e) {
      return null;
    }
  }
}

