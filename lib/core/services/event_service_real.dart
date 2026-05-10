import '../config/api_config.dart';
import '../models/event_model_real.dart';
import 'api_client.dart';

/// Real Event Service
/// Handles all event-related operations with backend API
class EventService {
  final _apiClient = ApiClient();

  /// Get all events with optional filters
  Future<List<EventModel>> getEvents({
    String? search,
    String? category,
    String? eventType,
    bool? isFeatured,
    int? limit,
    int? page,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (category != null) {
        queryParams['category'] = category;
      }
      if (eventType != null) {
        queryParams['eventType'] = eventType;
      }
      if (isFeatured != null) {
        queryParams['isFeatured'] = isFeatured.toString();
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (page != null) {
        queryParams['page'] = page.toString();
      }

      final response = await _apiClient.get(
        ApiConfig.events,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventModel.fromJson(json)).toList();
      }

      throw Exception('Gagal memuat daftar event');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get featured events
  Future<List<EventModel>> getFeaturedEvents() async {
    try {
      final response = await _apiClient.get(ApiConfig.featuredEvents);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventModel.fromJson(json)).toList();
      }

      throw Exception('Gagal memuat event unggulan');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get upcoming events
  Future<List<EventModel>> getUpcomingEvents() async {
    try {
      final response = await _apiClient.get(ApiConfig.upcomingEvents);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventModel.fromJson(json)).toList();
      }

      throw Exception('Gagal memuat event mendatang');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get event detail by ID
  Future<EventModel> getEventDetail(String eventId) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.eventDetail(eventId),
      );

      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      }

      throw Exception('Gagal memuat detail event');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get event categories
  Future<List<EventCategory>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiConfig.categories);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventCategory.fromJson(json)).toList();
      }

      throw Exception('Gagal memuat kategori');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Register for an event
  Future<Map<String, dynamic>> registerEvent({
    required String eventId,
    String? paymentMethod,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.registerEvent,
        data: {
          'eventId': eventId,
          if (paymentMethod != null) 'paymentMethod': paymentMethod,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        return {
          'success': true,
          'message': data['message'] ?? 'Pendaftaran berhasil',
          'participant': data['participant'],
          'transaction': data['transaction'],
          'invoiceUrl': data['invoiceUrl'], // For Xendit payment
          'tokenNumber': data['tokenNumber'],
        };
      }

      throw Exception('Pendaftaran gagal');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get my registered events
  Future<List<Map<String, dynamic>>> getMyEvents() async {
    try {
      final response = await _apiClient.get(ApiConfig.myEvents);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => json as Map<String, dynamic>).toList();
      }

      throw Exception('Gagal memuat event saya');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Mark attendance with token
  Future<Map<String, dynamic>> markAttendance({
    required String eventId,
    required String tokenNumber,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.markAttendance,
        data: {
          'eventId': eventId,
          'tokenNumber': tokenNumber,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Absensi berhasil',
          'participant': response.data['participant'],
        };
      }

      throw Exception('Absensi gagal');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Search events
  Future<List<EventModel>> searchEvents(String query) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.events,
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventModel.fromJson(json)).toList();
      }

      throw Exception('Pencarian gagal');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Filter events by category
  Future<List<EventModel>> getEventsByCategory(String categoryId) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.events,
        queryParameters: {'category': categoryId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventModel.fromJson(json)).toList();
      }

      throw Exception('Gagal memuat event');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Filter events by type (online/offline)
  Future<List<EventModel>> getEventsByType(String eventType) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.events,
        queryParameters: {'eventType': eventType},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventModel.fromJson(json)).toList();
      }

      throw Exception('Gagal memuat event');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
