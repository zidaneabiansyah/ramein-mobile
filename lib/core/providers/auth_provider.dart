import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

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
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
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
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        state = state.copyWith(
          user: currentUser,
          isInitialized: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isInitialized: true,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isInitialized: true,
        isLoading: false,
      );
    }
  }

  /// Register new user
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
    required String education,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        education: education,
        password: password,
      );

      if (result.success) {
        state = state.copyWith(
          user: result.user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message,
        );
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return AuthResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Login user
  Future<AuthResult> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      if (result.success) {
        state = state.copyWith(
          user: result.user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message,
        );
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return AuthResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Verify email with OTP
  Future<AuthResult> verifyEmail({
    required String email,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.verifyEmail(
        email: email,
        token: token,
      );

      if (result.success && result.user != null) {
        state = state.copyWith(
          user: result.user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message,
        );
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return AuthResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Resend verification email
  Future<AuthResult> resendVerificationEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.resendVerificationEmail(email);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return AuthResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Request password reset
  Future<AuthResult> requestPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.requestPasswordReset(email);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return AuthResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Reset password
  Future<AuthResult> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.resetPassword(
        email: email,
        token: token,
        newPassword: newPassword,
      );

      if (result.success && result.user != null) {
        state = state.copyWith(
          user: result.user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message,
        );
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return AuthResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      state = state.copyWith(
        user: null,
        isLoading: false,
        error: null,
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
    state = state.copyWith(error: null);
  }

  /// Update user profile
  Future<void> updateProfile(UserModel updatedUser) async {
    state = state.copyWith(user: updatedUser);
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
