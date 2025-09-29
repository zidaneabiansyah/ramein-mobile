import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider untuk mengelola state onboarding
class OnboardingState {
  final bool isCompleted;
  final bool isLoading;

  const OnboardingState({
    this.isCompleted = false,
    this.isLoading = false,
  });

  OnboardingState copyWith({
    bool? isCompleted,
    bool? isLoading,
  }) {
    return OnboardingState(
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider untuk onboarding state
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

/// Notifier untuk mengelola onboarding
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState()) {
    _checkOnboardingStatus();
  }

  /// Cek status onboarding dari SharedPreferences
  Future<void> _checkOnboardingStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool('onboarding_completed') ?? false;
      
      state = state.copyWith(
        isCompleted: isCompleted,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Mark onboarding sebagai completed
  Future<void> completeOnboarding() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      
      state = state.copyWith(
        isCompleted: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Reset onboarding (untuk testing)
  Future<void> resetOnboarding() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('onboarding_completed');
      
      state = state.copyWith(
        isCompleted: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}
