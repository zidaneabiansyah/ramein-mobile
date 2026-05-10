/// Event Model untuk aplikasi Ramein (Real API)
/// Berisi data event dan method untuk serialization
class EventModel {
  final String id;
  final String title;
  final String description;
  final String date; // Format: YYYY-MM-DD
  final String time; // Format: HH:MM
  final String location;
  final String? flyer;
  final double price;
  final int maxParticipants;
  final int currentParticipants;
  final String registrationDeadline; // Format: YYYY-MM-DD
  final String eventType; // 'online' or 'offline'
  final String? contactPerson;
  final String? meetingLink;
  final List<String> tags;
  final bool isFeatured;
  final String? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    this.flyer,
    required this.price,
    required this.maxParticipants,
    this.currentParticipants = 0,
    required this.registrationDeadline,
    required this.eventType,
    this.contactPerson,
    this.meetingLink,
    this.tags = const [],
    this.isFeatured = false,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if event is free
  bool get isFree => price == 0;

  /// Check if event is online
  bool get isOnline => eventType.toLowerCase() == 'online';

  /// Check if event is full
  bool get isFull => currentParticipants >= maxParticipants;

  /// Check if registration is still open
  bool get isRegistrationOpen {
    try {
      final deadline = DateTime.parse(registrationDeadline);
      return DateTime.now().isBefore(deadline);
    } catch (e) {
      return false;
    }
  }

  /// Get event date as DateTime
  DateTime? get eventDate {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return null;
    }
  }

  /// Check if event has passed
  bool get isPast {
    final eventDateTime = eventDate;
    if (eventDateTime == null) return false;
    return DateTime.now().isAfter(eventDateTime);
  }

  /// Factory constructor untuk membuat EventModel dari JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      flyer: json['flyer'],
      price: (json['price'] ?? 0).toDouble(),
      maxParticipants: json['maxParticipants'] ?? 0,
      currentParticipants: json['currentParticipants'] ?? 0,
      registrationDeadline: json['registrationDeadline'] ?? '',
      eventType: json['eventType'] ?? 'offline',
      contactPerson: json['contactPerson'],
      meetingLink: json['meetingLink'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isFeatured: json['isFeatured'] ?? false,
      categoryId: json['categoryId'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Method untuk mengkonversi EventModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'flyer': flyer,
      'price': price,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'registrationDeadline': registrationDeadline,
      'eventType': eventType,
      'contactPerson': contactPerson,
      'meetingLink': meetingLink,
      'tags': tags,
      'isFeatured': isFeatured,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Copy method dengan parameter opsional untuk update
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    String? time,
    String? location,
    String? flyer,
    double? price,
    int? maxParticipants,
    int? currentParticipants,
    String? registrationDeadline,
    String? eventType,
    String? contactPerson,
    String? meetingLink,
    List<String>? tags,
    bool? isFeatured,
    String? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      flyer: flyer ?? this.flyer,
      price: price ?? this.price,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,
      eventType: eventType ?? this.eventType,
      contactPerson: contactPerson ?? this.contactPerson,
      meetingLink: meetingLink ?? this.meetingLink,
      tags: tags ?? this.tags,
      isFeatured: isFeatured ?? this.isFeatured,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, date: $date, price: $price, isFeatured: $isFeatured)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Event Category Model
class EventCategory {
  final String id;
  final String name;
  final String? description;
  final String? icon;

  const EventCategory({
    required this.id,
    required this.name,
    this.description,
    this.icon,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
    };
  }
}
