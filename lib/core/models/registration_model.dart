/// Registration Model untuk aplikasi Ramein
/// Berisi data pendaftaran event oleh user
class RegistrationModel {
  final String id;
  final String userId;
  final String eventId;
  final String token;
  final RegistrationStatus status;
  final DateTime registeredAt;
  final DateTime? tokenExpiredAt;
  final String? notes;

  const RegistrationModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.token,
    required this.status,
    required this.registeredAt,
    this.tokenExpiredAt,
    this.notes,
  });

  /// Factory constructor untuk membuat RegistrationModel dari JSON
  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      eventId: json['event_id'] ?? '',
      token: json['token'] ?? '',
      status: RegistrationStatus.fromString(json['status'] ?? 'pending'),
      registeredAt: DateTime.parse(json['registered_at'] ?? DateTime.now().toIso8601String()),
      tokenExpiredAt: json['token_expired_at'] != null 
          ? DateTime.parse(json['token_expired_at'])
          : null,
      notes: json['notes'],
    );
  }

  /// Method untuk mengkonversi RegistrationModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_id': eventId,
      'token': token,
      'status': status.toString().split('.').last,
      'registered_at': registeredAt.toIso8601String(),
      'token_expired_at': tokenExpiredAt?.toIso8601String(),
      'notes': notes,
    };
  }

  /// Copy method dengan parameter opsional untuk update
  RegistrationModel copyWith({
    String? id,
    String? userId,
    String? eventId,
    String? token,
    RegistrationStatus? status,
    DateTime? registeredAt,
    DateTime? tokenExpiredAt,
    String? notes,
  }) {
    return RegistrationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      token: token ?? this.token,
      status: status ?? this.status,
      registeredAt: registeredAt ?? this.registeredAt,
      tokenExpiredAt: tokenExpiredAt ?? this.tokenExpiredAt,
      notes: notes ?? this.notes,
    );
  }

  /// Check apakah token masih valid
  bool get isTokenValid {
    if (tokenExpiredAt == null) return true;
    return DateTime.now().isBefore(tokenExpiredAt!);
  }

  /// Check apakah sudah bisa absen
  bool get canAttend {
    return status == RegistrationStatus.approved && isTokenValid;
  }

  @override
  String toString() {
    return 'RegistrationModel(id: $id, userId: $userId, eventId: $eventId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegistrationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Registration Status Enum
enum RegistrationStatus {
  pending,
  approved,
  rejected,
  cancelled,
  attended,
  notAttended;

  /// Factory method untuk membuat status dari string
  static RegistrationStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return RegistrationStatus.pending;
      case 'approved':
        return RegistrationStatus.approved;
      case 'rejected':
        return RegistrationStatus.rejected;
      case 'cancelled':
        return RegistrationStatus.cancelled;
      case 'attended':
        return RegistrationStatus.attended;
      case 'not_attended':
        return RegistrationStatus.notAttended;
      default:
        return RegistrationStatus.pending;
    }
  }

  /// Get display text untuk status
  String get displayText {
    switch (this) {
      case RegistrationStatus.pending:
        return 'Menunggu Konfirmasi';
      case RegistrationStatus.approved:
        return 'Terdaftar';
      case RegistrationStatus.rejected:
        return 'Ditolak';
      case RegistrationStatus.cancelled:
        return 'Dibatalkan';
      case RegistrationStatus.attended:
        return 'Hadir';
      case RegistrationStatus.notAttended:
        return 'Tidak Hadir';
    }
  }

  /// Get color untuk status (untuk UI)
  String get colorHex {
    switch (this) {
      case RegistrationStatus.pending:
        return '#F59E0B'; // Warning
      case RegistrationStatus.approved:
        return '#00ED64'; // Success
      case RegistrationStatus.rejected:
        return '#D4183D'; // Error
      case RegistrationStatus.cancelled:
        return '#717182'; // Secondary
      case RegistrationStatus.attended:
        return '#00ED64'; // Success
      case RegistrationStatus.notAttended:
        return '#D4183D'; // Error
    }
  }
}
