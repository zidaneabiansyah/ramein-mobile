import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/certificate_model.dart';
import '../services/certificate_service.dart';

/// Certificate State Model
class CertificateState {
  final List<CertificateModel> certificates;
  final bool isLoading;
  final String? error;
  final CertificateStats? stats;

  const CertificateState({
    this.certificates = const [],
    this.isLoading = false,
    this.error,
    this.stats,
  });

  /// Copy method for state updates
  CertificateState copyWith({
    List<CertificateModel>? certificates,
    bool? isLoading,
    String? error,
    CertificateStats? stats,
  }) {
    return CertificateState(
      certificates: certificates ?? this.certificates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
    );
  }
}

/// Certificate Notifier untuk mengelola state certificates
class CertificateNotifier extends StateNotifier<CertificateState> {
  final CertificateService _certificateService = CertificateService();

  CertificateNotifier() : super(const CertificateState());

  /// Load user certificates
  Future<void> loadUserCertificates(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final certificates = await _certificateService.getUserCertificates(userId);
      final stats = await _certificateService.getCertificateStats(userId);
      
      state = state.copyWith(
        certificates: certificates,
        stats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get certificate by ID
  Future<CertificateModel?> getCertificateById(String certificateId) async {
    try {
      return await _certificateService.getCertificateById(certificateId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Download certificate
  Future<CertificateDownloadResult> downloadCertificate(String certificateId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _certificateService.downloadCertificate(certificateId);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return CertificateDownloadResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Verify certificate
  Future<CertificateVerificationResult> verifyCertificate(String verificationCode) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _certificateService.verifyCertificate(verificationCode);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return CertificateVerificationResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Certificate Provider
final certificateProvider = StateNotifierProvider<CertificateNotifier, CertificateState>((ref) {
  return CertificateNotifier();
});

/// Certificate Selectors
final certificatesProvider = Provider<List<CertificateModel>>((ref) {
  return ref.watch(certificateProvider).certificates;
});

final certificateStatsProvider = Provider<CertificateStats?>((ref) {
  return ref.watch(certificateProvider).stats;
});

final certificateLoadingProvider = Provider<bool>((ref) {
  return ref.watch(certificateProvider).isLoading;
});

final certificateErrorProvider = Provider<String?>((ref) {
  return ref.watch(certificateProvider).error;
});
