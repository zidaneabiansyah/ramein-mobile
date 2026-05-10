import '../config/api_config.dart';
import 'api_client.dart';

/// Participant Service
/// Handles participant-related operations
class ParticipantService {
  final _apiClient = ApiClient();

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

  /// Get my certificates
  Future<List<Map<String, dynamic>>> getMyCertificates() async {
    try {
      final response = await _apiClient.get(ApiConfig.myCertificates);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => json as Map<String, dynamic>).toList();
      }

      throw Exception('Gagal memuat sertifikat saya');
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

  /// Get event participants (for organizers)
  Future<List<Map<String, dynamic>>> getEventParticipants(String eventId) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.eventParticipants(eventId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => json as Map<String, dynamic>).toList();
      }

      throw Exception('Gagal memuat peserta');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
