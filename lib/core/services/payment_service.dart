import '../config/api_config.dart';
import 'api_client.dart';

/// Payment Service
/// Handles payment operations with Xendit integration
class PaymentService {
  final _apiClient = ApiClient();

  /// Create payment transaction
  Future<Map<String, dynamic>> createPayment({
    required String eventId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.createPayment,
        data: {
          'eventId': eventId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        return {
          'success': true,
          'orderId': data['orderId'],
          'invoiceUrl': data['invoiceUrl'], // Xendit invoice URL
          'invoiceId': data['invoiceId'],
          'amount': data['amount'],
          'status': data['status'],
          'expiryDate': data['expiryDate'],
        };
      }

      throw Exception('Gagal membuat pembayaran');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get payment status
  Future<Map<String, dynamic>> getPaymentStatus(String orderId) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.paymentStatus(orderId),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        return {
          'success': true,
          'orderId': data['orderId'],
          'status': data['status'],
          'amount': data['amount'],
          'paymentMethod': data['paymentMethod'],
          'paidAt': data['paidAt'],
        };
      }

      throw Exception('Gagal memuat status pembayaran');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Cancel payment
  Future<Map<String, dynamic>> cancelPayment(String orderId) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.cancelPayment(orderId),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Pembayaran dibatalkan',
        };
      }

      throw Exception('Gagal membatalkan pembayaran');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get payment summary
  Future<Map<String, dynamic>> getPaymentSummary({
    required String eventId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.paymentSummary,
        data: {
          'eventId': eventId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        return {
          'success': true,
          'event': data['event'],
          'amount': data['amount'],
          'adminFee': data['adminFee'],
          'totalAmount': data['totalAmount'],
        };
      }

      throw Exception('Gagal memuat ringkasan pembayaran');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
