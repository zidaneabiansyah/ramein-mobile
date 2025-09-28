import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_api_service.dart';

/// App State Model
class AppState {
  final bool isInitialized;
  final bool isLoading;
  final String? error;

  const AppState({
    this.isInitialized = false,
    this.isLoading = false,
    this.error,
  });

  /// Copy method for state updates
  AppState copyWith({
    bool? isInitialized,
    bool? isLoading,
    String? error,
  }) {
    return AppState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// App Notifier untuk mengelola state aplikasi
class AppNotifier extends StateNotifier<AppState> {
  final MockApiService _apiService = MockApiService();

  AppNotifier() : super(const AppState()) {
    _initialize();
  }

  /// Initialize app
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Initialize mock API service
      await _apiService.initialize();
      
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialized: false,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Retry initialization
  Future<void> retry() async {
    await _initialize();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// App Provider
final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier();
});

/// App State Selectors
final isAppInitializedProvider = Provider<bool>((ref) {
  return ref.watch(appProvider).isInitialized;
});

final appLoadingProvider = Provider<bool>((ref) {
  return ref.watch(appProvider).isLoading;
});

final appErrorProvider = Provider<String?>((ref) {
  return ref.watch(appProvider).error;
});
