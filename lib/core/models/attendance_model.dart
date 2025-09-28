/// Attendance Model untuk aplikasi Ramein
/// Berisi data kehadiran peserta di event
class AttendanceModel {
  final String id;
  final String registrationId;
  final String userId;
  final String eventId;
  final String token;
  final DateTime attendedAt;
  final String? location;
  final String? notes;
  final AttendanceStatus status;

  const AttendanceModel({
    required this.id,
    required this.registrationId,
    required this.userId,
    required this.eventId,
    required this.token,
    required this.attendedAt,
    this.location,
    this.notes,
    required this.status,
  });

  /// Factory constructor untuk membuat AttendanceModel dari JSON
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? '',
      registrationId: json['registration_id'] ?? '',
      userId: json['user_id'] ?? '',
      eventId: json['event_id'] ?? '',
      token: json['token'] ?? '',
      attendedAt: DateTime.parse(json['attended_at'] ?? DateTime.now().toIso8601String()),
      location: json['location'],
      notes: json['notes'],
      status: AttendanceStatus.fromString(json['status'] ?? 'present'),
    );
  }

  /// Method untuk mengkonversi AttendanceModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registration_id': registrationId,
      'user_id': userId,
      'event_id': eventId,
      'token': token,
      'attended_at': attendedAt.toIso8601String(),
      'location': location,
      'notes': notes,
      'status': status.toString().split('.').last,
    };
  }

  /// Copy method dengan parameter opsional untuk update
  AttendanceModel copyWith({
    String? id,
    String? registrationId,
    String? userId,
    String? eventId,
    String? token,
    DateTime? attendedAt,
    String? location,
    String? notes,
    AttendanceStatus? status,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      registrationId: registrationId ?? this.registrationId,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      token: token ?? this.token,
      attendedAt: attendedAt ?? this.attendedAt,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'AttendanceModel(id: $id, userId: $userId, eventId: $eventId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttendanceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Attendance Status Enum
enum AttendanceStatus {
  present,
  late,
  absent;

  /// Factory method untuk membuat status dari string
  static AttendanceStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'late':
        return AttendanceStatus.late;
      case 'absent':
        return AttendanceStatus.absent;
      default:
        return AttendanceStatus.present;
    }
  }

  /// Get display text untuk status
  String get displayText {
    switch (this) {
      case AttendanceStatus.present:
        return 'Hadir Tepat Waktu';
      case AttendanceStatus.late:
        return 'Terlambat';
      case AttendanceStatus.absent:
        return 'Tidak Hadir';
    }
  }

  /// Get color untuk status (untuk UI)
  String get colorHex {
    switch (this) {
      case AttendanceStatus.present:
        return '#00ED64'; // Success
      case AttendanceStatus.late:
        return '#F59E0B'; // Warning
      case AttendanceStatus.absent:
        return '#D4183D'; // Error
    }
  }

  /// Get icon untuk status
  String get iconName {
    switch (this) {
      case AttendanceStatus.present:
        return 'check_circle';
      case AttendanceStatus.late:
        return 'schedule';
      case AttendanceStatus.absent:
        return 'cancel';
    }
  }
}
