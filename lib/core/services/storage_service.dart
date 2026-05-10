import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage Service
/// Handles secure storage for sensitive data and preferences for non-sensitive data
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  
  final _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;
  
  StorageService._internal();
  
  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // ==================== Secure Storage (for sensitive data) ====================
  
  /// Save auth token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }
  
  /// Get auth token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
  
  /// Delete auth token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
  
  /// Save user data (as JSON string)
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _secureStorage.write(
      key: 'user_data',
      value: jsonEncode(userData),
    );
  }
  
  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    final data = await _secureStorage.read(key: 'user_data');
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }
  
  /// Delete user data
  Future<void> deleteUserData() async {
    await _secureStorage.delete(key: 'user_data');
  }
  
  /// Clear all secure storage
  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }
  
  // ==================== Shared Preferences (for non-sensitive data) ====================
  
  /// Save string
  Future<bool> saveString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }
  
  /// Get string
  String? getString(String key) {
    return _prefs?.getString(key);
  }
  
  /// Save int
  Future<bool> saveInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }
  
  /// Get int
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }
  
  /// Save bool
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }
  
  /// Get bool
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }
  
  /// Save double
  Future<bool> saveDouble(String key, double value) async {
    return await _prefs?.setDouble(key, value) ?? false;
  }
  
  /// Get double
  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }
  
  /// Save list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value) ?? false;
  }
  
  /// Get list of strings
  List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }
  
  /// Remove key
  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }
  
  /// Clear all preferences
  Future<bool> clearPreferences() async {
    return await _prefs?.clear() ?? false;
  }
  
  /// Check if key exists
  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }
  
  // ==================== App-specific storage ====================
  
  /// Save onboarding status
  Future<bool> setOnboardingComplete(bool value) async {
    return await saveBool('onboarding_complete', value);
  }
  
  /// Get onboarding status
  bool isOnboardingComplete() {
    return getBool('onboarding_complete') ?? false;
  }
  
  /// Save theme mode
  Future<bool> setThemeMode(String mode) async {
    return await saveString('theme_mode', mode);
  }
  
  /// Get theme mode
  String getThemeMode() {
    return getString('theme_mode') ?? 'system';
  }
  
  /// Save language
  Future<bool> setLanguage(String languageCode) async {
    return await saveString('language', languageCode);
  }
  
  /// Get language
  String getLanguage() {
    return getString('language') ?? 'id';
  }
  
  /// Save last sync time
  Future<bool> setLastSyncTime(DateTime time) async {
    return await saveString('last_sync', time.toIso8601String());
  }
  
  /// Get last sync time
  DateTime? getLastSyncTime() {
    final timeStr = getString('last_sync');
    if (timeStr != null) {
      return DateTime.tryParse(timeStr);
    }
    return null;
  }
  
  /// Logout - Clear all user data
  Future<void> logout() async {
    await deleteToken();
    await deleteUserData();
    // Keep app preferences like theme, language, onboarding status
  }
}
