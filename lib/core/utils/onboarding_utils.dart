import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

/// Utility class untuk mengelola onboarding
class OnboardingUtils {
  static const String _onboardingKey = 'onboarding_completed';

  /// Cek apakah onboarding sudah selesai
  static Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Mark onboarding sebagai completed
  static Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Reset onboarding (untuk testing)
  static Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingKey);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Debug: Print onboarding status
  static Future<void> debugOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool(_onboardingKey) ?? false;
      developer.log(
        'Onboarding Status: ${isCompleted ? "Completed" : "Not Completed"}',
      );
    } catch (e) {
      developer.log('Error checking onboarding status: $e');
    }
  }
}
