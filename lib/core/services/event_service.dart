import 'dart:math';
import '../models/event_model.dart';
import '../models/registration_model.dart';
import '../models/attendance_model.dart';
import 'mock_api_service.dart';

/// Event Service untuk aplikasi Ramein
/// Handle event operations, registration, dan attendance
class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final MockApiService _apiService = MockApiService();

  /// Get all events
  Future<List<EventModel>> getEvents({
    String? category,
    String? search,
    EventSortType sortType = EventSortType.dateAsc,
    int page = 1,
    int limit = 20,
  }) async {
    await _simulateNetworkDelay();

    List<EventModel> events = List.from(_apiService.events);

    // Filter by category
    if (category != null && category.isNotEmpty && category != 'Semua') {
      events = events.where((event) => event.category == category).toList();
    }

    // Filter by search
    if (search != null && search.isNotEmpty) {
      events = events.where((event) =>
        event.title.toLowerCase().contains(search.toLowerCase()) ||
        event.description.toLowerCase().contains(search.toLowerCase()) ||
        event.organizer.toLowerCase().contains(search.toLowerCase())
      ).toList();
    }

    // Sort events
    switch (sortType) {
      case EventSortType.dateAsc:
        events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
        break;
      case EventSortType.dateDesc:
        events.sort((a, b) => b.eventDate.compareTo(a.eventDate));
        break;
      case EventSortType.titleAsc:
        events.sort((a, b) => a.title.compareTo(b.title));
        break;
      case EventSortType.titleDesc:
        events.sort((a, b) => b.title.compareTo(a.title));
        break;
      case EventSortType.participantsAsc:
        events.sort((a, b) => a.currentParticipants.compareTo(b.currentParticipants));
        break;
      case EventSortType.participantsDesc:
        events.sort((a, b) => b.currentParticipants.compareTo(a.currentParticipants));
        break;
    }

    // Pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= events.length) {
      return [];
    }

    return events.sublist(
      startIndex,
      endIndex > events.length ? events.length : endIndex,
    );
  }

  /// Get event by ID
  Future<EventModel?> getEventById(String eventId) async {
    await _simulateNetworkDelay();

    try {
      return _apiService.events.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null;
    }
  }

  /// Get event categories
  Future<List<String>> getEventCategories() async {
    await _simulateNetworkDelay();

    final categories = _apiService.events
        .map((event) => event.category)
        .toSet()
        .toList();
    
    categories.sort();
    categories.insert(0, 'Semua');
    
    return categories;
  }

  /// Register for event
  Future<RegistrationResult> registerForEvent({
    required String eventId,
    required String userId,
  }) async {
    try {
      await _simulateNetworkDelay();

      // Check if event exists
      final event = await getEventById(eventId);
      if (event == null) {
        return RegistrationResult(
          success: false,
          message: 'Event tidak ditemukan',
        );
      }

      // Check if event can still be registered
      if (!event.canRegister) {
        return RegistrationResult(
          success: false,
          message: 'Pendaftaran sudah ditutup atau event penuh',
        );
      }

      // Check if user already registered
      final existingRegistration = _apiService.registrations.firstWhere(
        (reg) => reg.userId == userId && reg.eventId == eventId,
        orElse: () => throw Exception('Not found'),
      );

      if (existingRegistration.status == RegistrationStatus.approved) {
        return RegistrationResult(
          success: false,
          message: 'Anda sudah terdaftar untuk event ini',
        );
      }

      // Generate registration token
      final token = _generateRegistrationToken();

      // Create registration
      final registration = RegistrationModel(
        id: _generateId(),
        userId: userId,
        eventId: eventId,
        token: token,
        status: RegistrationStatus.approved, // Auto approve for mock
        registeredAt: DateTime.now(),
        tokenExpiredAt: event.eventDate.add(const Duration(hours: 2)), // Token valid until 2 hours after event
      );

      // Add to registrations
      _apiService.registrations.add(registration);

      // Update event participant count
      final eventIndex = _apiService.events.indexWhere((e) => e.id == eventId);
      if (eventIndex != -1) {
        final updatedEvent = _apiService.events[eventIndex].copyWith(
          currentParticipants: _apiService.events[eventIndex].currentParticipants + 1,
          updatedAt: DateTime.now(),
        );
        _apiService.events[eventIndex] = updatedEvent;
      }

      // Simulate sending token via email
      await _sendRegistrationTokenEmail(userId, event.title, token);

      return RegistrationResult(
        success: true,
        message: 'Berhasil mendaftar! Token telah dikirim ke email Anda.',
        registration: registration,
      );

    } catch (e) {
      // User not registered yet, proceed with registration
      return await registerForEvent(eventId: eventId, userId: userId);
    }
  }

  /// Check attendance with token
  Future<AttendanceResult> checkAttendance({
    required String eventId,
    required String userId,
    required String token,
  }) async {
    try {
      await _simulateNetworkDelay();

      // Find registration
      final registration = _apiService.registrations.firstWhere(
        (reg) => reg.userId == userId && reg.eventId == eventId && reg.token == token,
      );

      // Check if token is valid
      if (!registration.isTokenValid) {
        return AttendanceResult(
          success: false,
          message: 'Token sudah expired',
        );
      }

      // Check if already attended
      _apiService.attendances.firstWhere(
        (att) => att.userId == userId && att.eventId == eventId,
        orElse: () => throw Exception('Not found'),
      );

      return AttendanceResult(
        success: false,
        message: 'Anda sudah melakukan absensi',
      );

    } catch (e) {
      // Not attended yet, proceed with attendance
      
      // Get event info
      final event = await getEventById(eventId);
      if (event == null) {
        return AttendanceResult(
          success: false,
          message: 'Event tidak ditemukan',
        );
      }

      // Check if event has started
      if (!event.hasStarted) {
        return AttendanceResult(
          success: false,
          message: 'Absensi baru bisa dilakukan setelah event dimulai',
        );
      }

      // Find registration
      final registration = _apiService.registrations.firstWhere(
        (reg) => reg.userId == userId && reg.eventId == eventId && reg.token == token,
      );

      // Check if registration is approved
      if (registration.status != RegistrationStatus.approved) {
        return AttendanceResult(
          success: false,
          message: 'Registrasi belum disetujui',
        );
      }

      // Create attendance record
      final attendance = AttendanceModel(
        id: _generateId(),
        registrationId: registration.id,
        userId: userId,
        eventId: eventId,
        token: token,
        attendedAt: DateTime.now(),
        location: event.location,
        status: _determineAttendanceStatus(event),
      );

      // Add to attendances
      _apiService.attendances.add(attendance);

      // Update registration status
      final regIndex = _apiService.registrations.indexWhere(
        (reg) => reg.id == registration.id,
      );
      if (regIndex != -1) {
        final updatedRegistration = _apiService.registrations[regIndex].copyWith(
          status: RegistrationStatus.attended,
        );
        _apiService.registrations[regIndex] = updatedRegistration;
      }

      return AttendanceResult(
        success: true,
        message: 'Absensi berhasil!',
        attendance: attendance,
      );
    }
  }

  /// Get user registrations
  Future<List<RegistrationModel>> getUserRegistrations(String userId) async {
    await _simulateNetworkDelay();

    return _apiService.registrations
        .where((reg) => reg.userId == userId)
        .toList();
  }

  /// Get user attendances
  Future<List<AttendanceModel>> getUserAttendances(String userId) async {
    await _simulateNetworkDelay();

    return _apiService.attendances
        .where((att) => att.userId == userId)
        .toList();
  }

  /// Get user event history
  Future<List<EventHistoryItem>> getUserEventHistory(String userId) async {
    await _simulateNetworkDelay();

    final registrations = await getUserRegistrations(userId);
    final attendances = await getUserAttendances(userId);

    final historyItems = <EventHistoryItem>[];

    for (final registration in registrations) {
      final event = await getEventById(registration.eventId);
      if (event != null) {
        final attendance = attendances.firstWhere(
          (att) => att.eventId == registration.eventId,
          orElse: () => throw Exception('Not found'),
        );

        historyItems.add(EventHistoryItem(
          event: event,
          registration: registration,
          attendance: attendance,
        ));
      }
    }

    // Sort by event date (most recent first)
    historyItems.sort((a, b) => b.event.eventDate.compareTo(a.event.eventDate));

    return historyItems;
  }

  /// Generate registration token
  String _generateRegistrationToken() {
    const chars = '0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(10, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  /// Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Determine attendance status based on timing
  AttendanceStatus _determineAttendanceStatus(EventModel event) {
    final now = DateTime.now();
    final eventStartTime = event.eventDate;
    
    // If attended within 15 minutes of event start, considered on time
    if (now.difference(eventStartTime).inMinutes <= 15) {
      return AttendanceStatus.present;
    } else {
      return AttendanceStatus.late;
    }
  }

  /// Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Reduced for better performance
  }

  /// Simulate sending registration token email
  Future<void> _sendRegistrationTokenEmail(String userId, String eventTitle, String token) async {
    await Future.delayed(const Duration(milliseconds: 200)); // Reduced for better performance
    // In real app, this would send actual email
    // TODO: Implement actual email sending
  }
}

/// Event Sort Type Enum
enum EventSortType {
  dateAsc,
  dateDesc,
  titleAsc,
  titleDesc,
  participantsAsc,
  participantsDesc,
}

/// Registration Result Model
class RegistrationResult {
  final bool success;
  final String message;
  final RegistrationModel? registration;

  const RegistrationResult({
    required this.success,
    required this.message,
    this.registration,
  });
}

/// Attendance Result Model
class AttendanceResult {
  final bool success;
  final String message;
  final AttendanceModel? attendance;

  const AttendanceResult({
    required this.success,
    required this.message,
    this.attendance,
  });
}

/// Event History Item Model
class EventHistoryItem {
  final EventModel event;
  final RegistrationModel registration;
  final AttendanceModel? attendance;

  const EventHistoryItem({
    required this.event,
    required this.registration,
    this.attendance,
  });
}
