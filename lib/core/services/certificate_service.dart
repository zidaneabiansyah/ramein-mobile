import 'dart:math';
import '../models/certificate_model.dart';
import '../models/event_model.dart';
import '../models/attendance_model.dart';
import '../models/user_model.dart';
import 'mock_api_service.dart';

/// Certificate Service untuk aplikasi Ramein
/// Handle certificate generation dan management
class CertificateService {
  static final CertificateService _instance = CertificateService._internal();
  factory CertificateService() => _instance;
  CertificateService._internal();

  final MockApiService _apiService = MockApiService();

  /// Get user certificates
  Future<List<CertificateModel>> getUserCertificates(String userId) async {
    await _simulateNetworkDelay();

    return _apiService.certificates
        .where((cert) => cert.userId == userId)
        .toList();
  }

  /// Get certificate by ID
  Future<CertificateModel?> getCertificateById(String certificateId) async {
    await _simulateNetworkDelay();

    try {
      return _apiService.certificates.firstWhere((cert) => cert.id == certificateId);
    } catch (e) {
      return null;
    }
  }

  /// Generate certificate for attended event
  Future<CertificateResult> generateCertificate({
    required String userId,
    required String eventId,
    required AttendanceModel attendance,
  }) async {
    try {
      await _simulateNetworkDelay();

      // Check if certificate already exists
      final existingCertificate = _apiService.certificates.firstWhere(
        (cert) => cert.userId == userId && cert.eventId == eventId,
        orElse: () => throw Exception('Not found'),
      );

      return CertificateResult(
        success: false,
        message: 'Sertifikat sudah ada untuk event ini',
        certificate: existingCertificate,
      );

    } catch (e) {
      // Certificate doesn't exist, generate new one
      
      // Get event info
      final event = _apiService.events.firstWhere((e) => e.id == eventId);
      
      // Check if user attended the event
      if (attendance.status == AttendanceStatus.absent) {
        return CertificateResult(
          success: false,
          message: 'Tidak dapat membuat sertifikat karena tidak hadir',
        );
      }

      // Generate certificate
      final certificate = CertificateModel(
        id: _generateId(),
        userId: userId,
        eventId: eventId,
        eventTitle: event.title,
        certificateUrl: _generateCertificateUrl(eventId),
        issuedAt: DateTime.now(),
        verificationCode: _generateVerificationCode(),
        status: CertificateStatus.issued,
        notes: 'Certificate generated for ${event.title}',
      );

      // Add to certificates
      _apiService.certificates.add(certificate);

      // Simulate certificate generation process
      await _simulateCertificateGeneration(certificate);

      return CertificateResult(
        success: true,
        message: 'Sertifikat berhasil dibuat!',
        certificate: certificate,
      );
    }
  }

  /// Verify certificate
  Future<CertificateVerificationResult> verifyCertificate(String verificationCode) async {
    try {
      await _simulateNetworkDelay();

      final certificate = _apiService.certificates.firstWhere(
        (cert) => cert.verificationCode == verificationCode,
      );

      // Get user info
      final user = _apiService.users.firstWhere((u) => u.id == certificate.userId);
      
      // Get event info
      final event = _apiService.events.firstWhere((e) => e.id == certificate.eventId);

      return CertificateVerificationResult(
        success: true,
        message: 'Sertifikat valid',
        certificate: certificate,
        user: user,
        event: event,
      );

    } catch (e) {
      return CertificateVerificationResult(
        success: false,
        message: 'Kode verifikasi tidak valid',
      );
    }
  }

  /// Download certificate
  Future<CertificateDownloadResult> downloadCertificate(String certificateId) async {
    try {
      await _simulateNetworkDelay();

      final certificate = _apiService.certificates.firstWhere(
        (cert) => cert.id == certificateId,
      );

      if (certificate.status != CertificateStatus.issued) {
        return CertificateDownloadResult(
          success: false,
          message: 'Sertifikat tidak dapat didownload',
        );
      }

      // Simulate download process
      await _simulateCertificateDownload(certificate);

      return CertificateDownloadResult(
        success: true,
        message: 'Download berhasil!',
        downloadUrl: certificate.certificateUrl,
      );

    } catch (e) {
      return CertificateDownloadResult(
        success: false,
        message: 'Sertifikat tidak ditemukan',
      );
    }
  }

  /// Auto generate certificates for completed events
  Future<void> autoGenerateCertificates() async {
    await _simulateNetworkDelay();

    final now = DateTime.now();
    
    // Find events that ended more than 1 day ago
    final completedEvents = _apiService.events.where((event) {
      final eventEndTime = event.eventDate.add(const Duration(hours: 8));
      return now.difference(eventEndTime).inDays >= 1;
    }).toList();

    for (final event in completedEvents) {
      // Find all attendances for this event
      final attendances = _apiService.attendances.where(
        (att) => att.eventId == event.id && att.status != AttendanceStatus.absent,
      ).toList();

      for (final attendance in attendances) {
        // Check if certificate already exists
        try {
          _apiService.certificates.firstWhere(
            (cert) => cert.userId == attendance.userId && cert.eventId == event.id,
          );
          // Certificate exists, skip
        } catch (e) {
          // Certificate doesn't exist, generate it
          await generateCertificate(
            userId: attendance.userId,
            eventId: event.id,
            attendance: attendance,
          );
        }
      }
    }
  }

  /// Get certificate statistics
  Future<CertificateStats> getCertificateStats(String userId) async {
    await _simulateNetworkDelay();

    final certificates = await getUserCertificates(userId);
    
    final totalCertificates = certificates.length;
    final issuedCertificates = certificates.where(
      (cert) => cert.status == CertificateStatus.issued,
    ).length;
    final pendingCertificates = certificates.where(
      (cert) => cert.status == CertificateStatus.pending,
    ).length;

    return CertificateStats(
      total: totalCertificates,
      issued: issuedCertificates,
      pending: pendingCertificates,
    );
  }

  /// Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Generate certificate URL
  String _generateCertificateUrl(String eventId) {
    return 'https://certificates.ramein.com/cert_${eventId}_${_generateId()}.pdf';
  }

  /// Generate verification code
  String _generateVerificationCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(8, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  /// Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Reduced for better performance
  }

  /// Simulate certificate generation
  Future<void> _simulateCertificateGeneration(CertificateModel certificate) async {
    await Future.delayed(const Duration(seconds: 2));
    // In real app, this would generate actual PDF certificate
    // TODO: Implement actual PDF certificate generation
  }

  /// Simulate certificate download
  Future<void> _simulateCertificateDownload(CertificateModel certificate) async {
    await Future.delayed(const Duration(seconds: 1));
    // In real app, this would trigger actual file download
    // TODO: Implement actual file download
  }
}

/// Certificate Result Model
class CertificateResult {
  final bool success;
  final String message;
  final CertificateModel? certificate;

  const CertificateResult({
    required this.success,
    required this.message,
    this.certificate,
  });
}

/// Certificate Verification Result Model
class CertificateVerificationResult {
  final bool success;
  final String message;
  final CertificateModel? certificate;
  final UserModel? user;
  final EventModel? event;

  const CertificateVerificationResult({
    required this.success,
    required this.message,
    this.certificate,
    this.user,
    this.event,
  });
}

/// Certificate Download Result Model
class CertificateDownloadResult {
  final bool success;
  final String message;
  final String? downloadUrl;

  const CertificateDownloadResult({
    required this.success,
    required this.message,
    this.downloadUrl,
  });
}

/// Certificate Statistics Model
class CertificateStats {
  final int total;
  final int issued;
  final int pending;

  const CertificateStats({
    required this.total,
    required this.issued,
    required this.pending,
  });
}
