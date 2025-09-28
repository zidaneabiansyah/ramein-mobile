import 'dart:math';
import '../models/user_model.dart';
import 'mock_api_service.dart';

/// Authentication Service untuk aplikasi Ramein
/// Handle login, register, email verification, dan password reset
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final MockApiService _apiService = MockApiService();
  final Random _random = Random();

  /// Register user baru
  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
    required String education,
    required String password,
  }) async {
    try {
      await _simulateNetworkDelay();

      // Check if email already exists
      _apiService.users.firstWhere(
        (user) => user.email == email,
        orElse: () => throw Exception('Email not found'),
      );
      
      // If we reach here, email already exists
      return AuthResult(
        success: false,
        message: 'Email sudah terdaftar',
      );

    } catch (e) {
      // Email doesn't exist, proceed with registration
      
      // Validate password strength
      if (!_isPasswordValid(password)) {
        return AuthResult(
          success: false,
          message: 'Password harus minimal 8 karakter dengan kombinasi huruf besar, kecil, angka, dan simbol',
        );
      }

      // Create new user
      final now = DateTime.now();
      final newUser = UserModel(
        id: _generateId(),
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        education: education,
        isEmailVerified: false,
        createdAt: now,
        updatedAt: now,
      );

      // Add user to mock database
      _apiService.users.add(newUser);

      // Generate email verification token
      final verificationToken = _generateVerificationToken();
      
      // Simulate sending verification email
      await _sendVerificationEmail(email, verificationToken);

      return AuthResult(
        success: true,
        message: 'Registrasi berhasil! Silakan cek email untuk verifikasi.',
        user: newUser,
        verificationToken: verificationToken,
      );
    }
  }

  /// Login user
  Future<AuthResult> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      await _simulateNetworkDelay();

      // Find user by email
      final user = _apiService.users.firstWhere(
        (u) => u.email == email,
      );

      // Check if email is verified
      if (!user.isEmailVerified) {
        return AuthResult(
          success: false,
          message: 'Email belum diverifikasi. Silakan cek email Anda.',
        );
      }

      // In real app, we would verify password hash
      // For mock, we'll accept any password
      if (password.isEmpty) {
        return AuthResult(
          success: false,
          message: 'Password tidak boleh kosong',
        );
      }

      // Set current user
      _apiService.setCurrentUser(user);

      return AuthResult(
        success: true,
        message: 'Login berhasil!',
        user: user,
      );

    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Email atau password salah',
      );
    }
  }

  /// Verify email dengan token
  Future<AuthResult> verifyEmail({
    required String email,
    required String token,
  }) async {
    try {
      await _simulateNetworkDelay();

      // Find user by email
      final userIndex = _apiService.users.indexWhere(
        (u) => u.email == email,
      );

      if (userIndex == -1) {
        return AuthResult(
          success: false,
          message: 'User tidak ditemukan',
        );
      }

      // In real app, we would verify token from database
      // For mock, we'll accept any 6-digit token
      if (token.length != 6) {
        return AuthResult(
          success: false,
          message: 'Token tidak valid',
        );
      }

      // Update user email verification status
      final updatedUser = _apiService.users[userIndex].copyWith(
        isEmailVerified: true,
        updatedAt: DateTime.now(),
      );

      _apiService.users[userIndex] = updatedUser;

      return AuthResult(
        success: true,
        message: 'Email berhasil diverifikasi!',
        user: updatedUser,
      );

    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Verifikasi gagal. Silakan coba lagi.',
      );
    }
  }

  /// Resend verification email
  Future<AuthResult> resendVerificationEmail(String email) async {
    try {
      await _simulateNetworkDelay();

      // Find user by email
      final user = _apiService.users.firstWhere(
        (u) => u.email == email,
      );

      if (user.isEmailVerified) {
        return AuthResult(
          success: false,
          message: 'Email sudah diverifikasi',
        );
      }

      // Generate new verification token
      final verificationToken = _generateVerificationToken();
      
      // Simulate sending verification email
      await _sendVerificationEmail(email, verificationToken);

      return AuthResult(
        success: true,
        message: 'Email verifikasi telah dikirim ulang',
      );

    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Gagal mengirim email verifikasi',
      );
    }
  }

  /// Request password reset
  Future<AuthResult> requestPasswordReset(String email) async {
    try {
      await _simulateNetworkDelay();

      // Find user by email
      _apiService.users.firstWhere(
        (u) => u.email == email,
      );

      // Generate reset token
      final resetToken = _generateResetToken();
      
      // Simulate sending reset email
      await _sendPasswordResetEmail(email, resetToken);

      return AuthResult(
        success: true,
        message: 'Link reset password telah dikirim ke email Anda',
      );

    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Email tidak ditemukan',
      );
    }
  }

  /// Reset password dengan token
  Future<AuthResult> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      await _simulateNetworkDelay();

      // Find user by email
      final userIndex = _apiService.users.indexWhere(
        (u) => u.email == email,
      );

      if (userIndex == -1) {
        return AuthResult(
          success: false,
          message: 'User tidak ditemukan',
        );
      }

      // Validate new password
      if (!_isPasswordValid(newPassword)) {
        return AuthResult(
          success: false,
          message: 'Password harus minimal 8 karakter dengan kombinasi huruf besar, kecil, angka, dan simbol',
        );
      }

      // In real app, we would verify reset token
      // For mock, we'll accept any token

      // Update user
      final updatedUser = _apiService.users[userIndex].copyWith(
        updatedAt: DateTime.now(),
      );

      _apiService.users[userIndex] = updatedUser;

      return AuthResult(
        success: true,
        message: 'Password berhasil direset!',
        user: updatedUser,
      );

    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Reset password gagal',
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _simulateNetworkDelay();
    _apiService.logout();
  }

  /// Check if user is logged in
  bool get isLoggedIn => _apiService.isLoggedIn;

  /// Get current user
  UserModel? get currentUser => _apiService.currentUser;

  /// Validate password strength
  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }

  /// Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Generate verification token (6 digits)
  String _generateVerificationToken() {
    return (_random.nextInt(900000) + 100000).toString(); // 100000-999999
  }

  /// Generate reset token
  String _generateResetToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(32, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  /// Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Reduced for better performance
  }

  /// Simulate sending verification email
  Future<void> _sendVerificationEmail(String email, String token) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Reduced for better performance
    // In real app, this would send actual email
    // TODO: Implement actual email sending
  }

  /// Simulate sending password reset email
  Future<void> _sendPasswordResetEmail(String email, String token) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Reduced for better performance
    // In real app, this would send actual email
    // TODO: Implement actual email sending
  }
}

/// Auth Result Model
class AuthResult {
  final bool success;
  final String message;
  final UserModel? user;
  final String? verificationToken;

  const AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.verificationToken,
  });
}
