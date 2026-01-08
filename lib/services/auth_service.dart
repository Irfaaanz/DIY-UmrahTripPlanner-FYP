import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // Register a new user
  static Future<bool> registerUser({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersKey) ?? [];
      
      // Check if email already exists
      for (final userJson in usersJson) {
        final user = jsonDecode(userJson) as Map<String, dynamic>;
        if (user['email'] == email) {
          return false; // Email already exists
        }
      }

      // Create new user
      final newUser = {
        'displayName': displayName,
        'email': email,
        'password': password, // In production, hash this password
        'createdAt': DateTime.now().toIso8601String(),
      };

      usersJson.add(jsonEncode(newUser));
      await prefs.setStringList(_usersKey, usersJson);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Sign in user
  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersKey) ?? [];

      // Find user with matching email and password
      for (final userJson in usersJson) {
        final user = jsonDecode(userJson) as Map<String, dynamic>;
        if (user['email'] == email && user['password'] == password) {
          // Save current user and login status
          await prefs.setString(_currentUserKey, userJson);
          await prefs.setBool(_isLoggedInKey, true);
          return true;
        }
      }

      return false; // Invalid credentials
    } catch (e) {
      return false;
    }
  }

  // Get current user
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (!isLoggedIn) {
        return null;
      }

      final userJson = prefs.getString(_currentUserKey);
      if (userJson != null) {
        return jsonDecode(userJson) as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get display name
  static Future<String?> getDisplayName() async {
    final user = await getCurrentUser();
    return user?['displayName'] as String?;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      // Handle error
    }
  }
}



