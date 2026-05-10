import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service_real.dart';

/// Auth State Model
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isInitialized;
 
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isInitialized = false,
  });

  /// Check if user is authenticated
  bool get isAuthenticated => user != null;

  /// Check if email is verified
  bool get isEmailVerified => user?.isEmailVerified ?? false;

  /// Copy method for state updates
  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isInitialized,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

/// Auth Notifier untuk mengelola state authentication
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService = AuthService();

  AuthNotifier() : super(const AuthState()) {
    _initialize();
  }

  /// Initialize auth state
  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Check if user is already logged in
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final currentUser = await _authService.getCurrentUser();
        if (currentUser != null) {
          state = state.copyWith(
            user: currentUser,
            isInitialized: true,
            isLoading: false,
          );
          return;
        }
      }
      
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isInitialized: true,
        isLoading: false,
      );
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String education,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        education: education,
      );

      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        state = state.copyWith(
          user: result['user'] as UserModel,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Login with Google
  Future<Map<String, dynamic>> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _authService.loginWithGoogle();

      if (result['success'] == true) {
        state = state.copyWith(
          user: result['user'] as UserModel,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Request verification email
  Future<Map<String, dynamic>> requestVerification(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _authService.requestVerification(email);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Verify email with token
  Future<Map<String, dynamic>> verifyEmail(String token) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _authService.verifyEmail(token);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Forgot password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _authService.forgotPassword(email);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Get user profile
  Future<void> refreshProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _authService.getProfile();
      state = state.copyWith(
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? education,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _authService.updateProfile(
        name: name,
        phone: phone,
        address: address,
        education: education,
      );
      state = state.copyWith(
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      state = state.copyWith(
        clearUser: true,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Auth State Selectors
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final isEmailVerifiedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isEmailVerified;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});

final authInitializedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isInitialized;
});
