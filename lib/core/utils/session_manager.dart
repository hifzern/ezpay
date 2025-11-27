// lib/core/utils/session_manager.dart

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyRole = 'user_role';
  static const String _keyMerchantName = 'merchant_name';

  // Save user role
  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
  }

  // Get user role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  // Save merchant name (optional)
  static Future<void> saveMerchantName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMerchantName, name);
  }

  // Get merchant name
  static Future<String?> getMerchantName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMerchantName);
  }

  // Clear session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check if user has selected role
  static Future<bool> hasRole() async {
    final role = await getRole();
    return role != null;
  }
}
