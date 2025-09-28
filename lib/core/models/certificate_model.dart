/// Certificate Model untuk aplikasi Ramein
/// Berisi data sertifikat yang diterima user
class CertificateModel {
  final String id;
  final String userId;
  final String eventId;
  final String eventTitle;
  final String certificateUrl;
  final DateTime issuedAt;
  final String? verificationCode;
  final CertificateStatus status;
  final String? notes;

  const CertificateModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventTitle,
    required this.certificateUrl,
    required this.issuedAt,
    this.verificationCode,
    required this.status,
    this.notes,
  });

  /// Factory constructor untuk membuat CertificateModel dari JSON
  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      eventId: json['event_id'] ?? '',
      eventTitle: json['event_title'] ?? '',
      certificateUrl: json['certificate_url'] ?? '',
      issuedAt: DateTime.parse(json['issued_at'] ?? DateTime.now().toIso8601String()),
      verificationCode: json['verification_code'],
      status: CertificateStatus.fromString(json['status'] ?? 'issued'),
      notes: json['notes'],
    );
  }

  /// Method untuk mengkonversi CertificateModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_id': eventId,
      'event_title': eventTitle,
      'certificate_url': certificateUrl,
      'issued_at': issuedAt.toIso8601String(),
      'verification_code': verificationCode,
      'status': status.toString().split('.').last,
      'notes': notes,
    };
  }

  /// Copy method dengan parameter opsional untuk update
  CertificateModel copyWith({
    String? id,
    String? userId,
    String? eventId,
    String? eventTitle,
    String? certificateUrl,
    DateTime? issuedAt,
    String? verificationCode,
    CertificateStatus? status,
    String? notes,
  }) {
    return CertificateModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      issuedAt: issuedAt ?? this.issuedAt,
      verificationCode: verificationCode ?? this.verificationCode,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  /// Check apakah sertifikat bisa didownload
  bool get canDownload {
    return status == CertificateStatus.issued && certificateUrl.isNotEmpty;
  }

  /// Check apakah sertifikat bisa diverifikasi
  bool get canVerify {
    return verificationCode != null && verificationCode!.isNotEmpty;
  }

  @override
  String toString() {
    return 'CertificateModel(id: $id, userId: $userId, eventTitle: $eventTitle, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CertificateModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Certificate Status Enum
enum CertificateStatus {
  issued,
  pending,
  revoked;

  /// Factory method untuk membuat status dari string
  static CertificateStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'issued':
        return CertificateStatus.issued;
      case 'pending':
        return CertificateStatus.pending;
      case 'revoked':
        return CertificateStatus.revoked;
      default:
        return CertificateStatus.pending;
    }
  }

  /// Get display text untuk status
  String get displayText {
    switch (this) {
      case CertificateStatus.issued:
        return 'Diterbitkan';
      case CertificateStatus.pending:
        return 'Menunggu';
      case CertificateStatus.revoked:
        return 'Dicabut';
    }
  }

  /// Get color untuk status (untuk UI)
  String get colorHex {
    switch (this) {
      case CertificateStatus.issued:
        return '#00ED64'; // Success
      case CertificateStatus.pending:
        return '#F59E0B'; // Warning
      case CertificateStatus.revoked:
        return '#D4183D'; // Error
    }
  }

  /// Get icon untuk status
  String get iconName {
    switch (this) {
      case CertificateStatus.issued:
        return 'verified';
      case CertificateStatus.pending:
        return 'schedule';
      case CertificateStatus.revoked:
        return 'block';
    }
  }
}
