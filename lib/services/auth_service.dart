import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Register a new user
  static Future<String?> registerUser({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(displayName);
        await userCredential.user!.reload(); // Reload to update local user data
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      print('Registration Error: $e');
      return 'unknown-error';
    }
  }

  // Sign in user
  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      print('Sign In Error: $e');
      return 'unknown-error';
    }
  }

  // Get current user
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    return {
      'displayName': user.displayName ?? '',
      'email': user.email ?? '',
      'createdAt': user.metadata.creationTime?.toIso8601String() ?? '',
      'uid': user.uid,
    };
  }

  // Get display name
  static Future<String?> getDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }
  // Update password
  static Future<bool> updatePassword(String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        return true;
      }
      return false;
    } catch (e) {
      print('Update Password Error: $e');
      return false;
    }
  }

  // Update display name
  static Future<void> updateDisplayName(String displayName) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload();
      }
    } catch (e) {
      print('Update Display Name Error: $e');
    }
  }
}



