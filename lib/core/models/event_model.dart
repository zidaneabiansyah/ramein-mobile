/// Event Model untuk aplikasi Ramein
/// Berisi data event dan method untuk serialization
class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String eventTime;
  final String location;
  final String category;
  final double? price;
  final String? flyerUrl;
  final String? certificateTemplateUrl;
  final int maxParticipants;
  final int currentParticipants;
  final String organizer;
  final List<String> requirements;
  final List<EventAgenda> agenda;
  final List<String> facilities;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final DateTime registrationDeadline;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.category,
    this.price,
    this.flyerUrl,
    this.certificateTemplateUrl,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.organizer,
    required this.requirements,
    required this.agenda,
    required this.facilities,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.registrationDeadline,
  });

  /// Factory constructor untuk membuat EventModel dari JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      eventDate: DateTime.parse(json['event_date'] ?? DateTime.now().toIso8601String()),
      eventTime: json['event_time'] ?? '',
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      price: json['price']?.toDouble(),
      flyerUrl: json['flyer_url'],
      certificateTemplateUrl: json['certificate_template_url'],
      maxParticipants: json['max_participants'] ?? 0,
      currentParticipants: json['current_participants'] ?? 0,
      organizer: json['organizer'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      agenda: (json['agenda'] as List?)
          ?.map((item) => EventAgenda.fromJson(item))
          .toList() ?? [],
      facilities: List<String>.from(json['facilities'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? true,
      registrationDeadline: DateTime.parse(json['registration_deadline'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Method untuk mengkonversi EventModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_date': eventDate.toIso8601String(),
      'event_time': eventTime,
      'location': location,
      'category': category,
      'price': price,
      'flyer_url': flyerUrl,
      'certificate_template_url': certificateTemplateUrl,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'organizer': organizer,
      'requirements': requirements,
      'agenda': agenda.map((item) => item.toJson()).toList(),
      'facilities': facilities,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'registration_deadline': registrationDeadline.toIso8601String(),
    };
  }

  /// Copy method dengan parameter opsional untuk update
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? eventDate,
    String? eventTime,
    String? location,
    String? category,
    double? price,
    String? flyerUrl,
    String? certificateTemplateUrl,
    int? maxParticipants,
    int? currentParticipants,
    String? organizer,
    List<String>? requirements,
    List<EventAgenda>? agenda,
    List<String>? facilities,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    DateTime? registrationDeadline,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      location: location ?? this.location,
      category: category ?? this.category,
      price: price ?? this.price,
      flyerUrl: flyerUrl ?? this.flyerUrl,
      certificateTemplateUrl: certificateTemplateUrl ?? this.certificateTemplateUrl,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      organizer: organizer ?? this.organizer,
      requirements: requirements ?? this.requirements,
      agenda: agenda ?? this.agenda,
      facilities: facilities ?? this.facilities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,
    );
  }

  /// Check apakah event masih bisa didaftar
  bool get canRegister {
    final now = DateTime.now();
    return isActive && 
           now.isBefore(registrationDeadline) && 
           currentParticipants < maxParticipants;
  }

  /// Check apakah event sudah dimulai
  bool get hasStarted {
    final now = DateTime.now();
    return now.isAfter(eventDate);
  }

  /// Check apakah event sudah selesai
  bool get hasEnded {
    final now = DateTime.now();
    final eventEndTime = eventDate.add(const Duration(hours: 8)); // Asumsi event 8 jam
    return now.isAfter(eventEndTime);
  }

  /// Persentase peserta
  double get participantPercentage {
    if (maxParticipants == 0) return 0;
    return currentParticipants / maxParticipants;
  }

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, eventDate: $eventDate, canRegister: $canRegister)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Event Agenda Model
class EventAgenda {
  final String time;
  final String activity;

  const EventAgenda({
    required this.time,
    required this.activity,
  });

  factory EventAgenda.fromJson(Map<String, dynamic> json) {
    return EventAgenda(
      time: json['time'] ?? '',
      activity: json['activity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'activity': activity,
    };
  }
}
