import 'package:google_sign_in/google_sign_in.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import 'api_client.dart';
import 'storage_service.dart';

/// Real Authentication Service
/// Handles all authentication operations with backend API
class AuthService {
  final _apiClient = ApiClient();
  final _storage = StorageService();
  final _googleSignIn = GoogleSignIn(
    clientId: ApiConfig.googleClientId,
    scopes: ['email', 'profile', 'openid'],
  );

  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Save token
        final token = data['token'];
        await _storage.saveToken(token);
        
        // Save user data
        final user = UserModel.fromJson(data['user']);
        await _storage.saveUserData(user.toJson());
        
        return {
          'success': true,
          'token': token,
          'user': user,
          'message': 'Login berhasil',
        };
      }
      
      throw Exception('Login gagal');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
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
    try {
      final response = await _apiClient.post(
        ApiConfig.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
          'education': education,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil. Silakan cek email untuk verifikasi.',
          'user': data['user'] != null ? UserModel.fromJson(data['user']) : null,
        };
      }
      
      throw Exception('Registrasi gagal');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Login with Google
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // Sign in with Google
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Login Google dibatalkan');
      }

      // Get Google authentication
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      
      if (accessToken == null) {
        throw Exception('Gagal mendapatkan token Google');
      }

      // Send to backend
      final response = await _apiClient.post(
        ApiConfig.googleAuth,
        data: {
          'accessToken': accessToken,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Save token
        final token = data['token'];
        await _storage.saveToken(token);
        
        // Save user data
        final user = UserModel.fromJson(data['user']);
        await _storage.saveUserData(user.toJson());
        
        return {
          'success': true,
          'token': token,
          'user': user,
          'message': 'Login dengan Google berhasil',
        };
      }
      
      throw Exception('Login dengan Google gagal');
    } catch (e) {
      // Sign out from Google on error
      await _googleSignIn.signOut();
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Request email verification
  Future<Map<String, dynamic>> requestVerification(String email) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.requestVerification,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Link verifikasi telah dikirim ke email Anda',
        };
      }
      
      throw Exception('Gagal mengirim link verifikasi');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Verify email with token
  Future<Map<String, dynamic>> verifyEmail(String token) async {
    try {
      final response = await _apiClient.get('${ApiConfig.verifyEmail}/$token');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Email berhasil diverifikasi',
        };
      }
      
      throw Exception('Verifikasi email gagal');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Forgot password - Request reset link
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Link reset password telah dikirim ke email Anda',
        };
      }
      
      throw Exception('Gagal mengirim link reset password');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Reset password with token
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.resetPassword}/$token',
        data: {'password': newPassword},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Password berhasil direset',
        };
      }
      
      throw Exception('Reset password gagal');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get current user profile
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.get(ApiConfig.profile);

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        
        // Update stored user data
        await _storage.saveUserData(user.toJson());
        
        return user;
      }
      
      throw Exception('Gagal memuat profil');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? education,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiConfig.updateProfile,
        data: {
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
          if (education != null) 'education': education,
        },
      );

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        
        // Update stored user data
        await _storage.saveUserData(user.toJson());
        
        return user;
      }
      
      throw Exception('Gagal update profil');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Get current user from storage
  Future<UserModel?> getCurrentUser() async {
    final userData = await _storage.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Sign out from Google if signed in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      
      // Clear storage
      await _storage.logout();
    } catch (e) {
      // Still clear storage even if Google sign out fails
      await _storage.logout();
    }
  }
}
