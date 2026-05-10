import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../config/api_config.dart';
import 'api_client.dart';

/// Certificate Service
/// Handles certificate operations
class CertificateService {
  final _apiClient = ApiClient();

  /// Get my certificates
  Future<List<Map<String, dynamic>>> getMyCertificates() async {
    try {
      final response = await _apiClient.get(ApiConfig.myCertificates);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => json as Map<String, dynamic>).toList();
      }

      throw Exception('Gagal memuat sertifikat');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Verify certificate by code
  Future<Map<String, dynamic>> verifyCertificate(String code) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.verifyCertificate(code),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'certificate': response.data,
          'isValid': true,
        };
      }

      throw Exception('Sertifikat tidak valid');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Download certificate
  Future<String> downloadCertificate({
    required String certificateUrl,
    required String certificateNumber,
    Function(int, int)? onProgress,
  }) async {
    try {
      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final savePath = '${directory.path}/certificates';
      
      // Create certificates directory if not exists
      final dir = Directory(savePath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Full file path
      final filePath = '$savePath/$certificateNumber.pdf';

      // Download file
      final fullUrl = '${ApiConfig.baseUrl}$certificateUrl';
      await _apiClient.download(
        fullUrl,
        filePath,
        onReceiveProgress: onProgress,
      );

      return filePath;
    } catch (e) {
      throw Exception('Gagal mengunduh sertifikat: ${e.toString()}');
    }
  }

  /// Share certificate
  Future<void> shareCertificate({
    required String certificateUrl,
    required String certificateNumber,
  }) async {
    try {
      // Download first
      final filePath = await downloadCertificate(
        certificateUrl: certificateUrl,
        certificateNumber: certificateNumber,
      );

      // Share file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Sertifikat $certificateNumber',
      );
    } catch (e) {
      throw Exception('Gagal membagikan sertifikat: ${e.toString()}');
    }
  }

  /// Get certificate file path if already downloaded
  Future<String?> getCertificateFilePath(String certificateNumber) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/certificates/$certificateNumber.pdf';
      
      final file = File(filePath);
      if (await file.exists()) {
        return filePath;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Delete downloaded certificate
  Future<void> deleteCertificate(String certificateNumber) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/certificates/$certificateNumber.pdf';
      
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Gagal menghapus sertifikat: ${e.toString()}');
    }
  }

  /// Get all downloaded certificates
  Future<List<String>> getDownloadedCertificates() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final certificatesDir = Directory('${directory.path}/certificates');
      
      if (!await certificatesDir.exists()) {
        return [];
      }

      final files = await certificatesDir.list().toList();
      return files
          .where((file) => file.path.endsWith('.pdf'))
          .map((file) => file.path)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
