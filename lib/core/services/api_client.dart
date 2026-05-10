import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/api_config.dart';

/// API Client using Dio
/// Handles all HTTP requests with interceptors for auth and logging
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  late Dio _dio;
  final _storage = const FlutterSecureStorage();
  
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // Auth Interceptor - Add JWT token to requests
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from secure storage
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - Token expired
          if (error.response?.statusCode == 401) {
            // Clear token and redirect to login
            await _storage.delete(key: 'auth_token');
            await _storage.delete(key: 'user_data');
          }
          return handler.next(error);
        },
      ),
    );
    
    // Logger Interceptor - Log requests and responses
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
  
  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Upload file
  Future<Response> upload(
    String path,
    FormData formData, {
    ProgressCallback? onSendProgress,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Handle Dio errors
  Exception _handleError(DioException error) {
    String message = 'Terjadi kesalahan';
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Koneksi timeout. Periksa koneksi internet Anda.';
        break;
        
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        if (responseData is Map && responseData.containsKey('message')) {
          message = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('error')) {
          message = responseData['error'];
        } else {
          switch (statusCode) {
            case 400:
              message = 'Permintaan tidak valid';
              break;
            case 401:
              message = 'Sesi Anda telah berakhir. Silakan login kembali.';
              break;
            case 403:
              message = 'Anda tidak memiliki akses';
              break;
            case 404:
              message = 'Data tidak ditemukan';
              break;
            case 500:
              message = 'Terjadi kesalahan pada server';
              break;
            default:
              message = 'Terjadi kesalahan (${statusCode ?? 'unknown'})';
          }
        }
        break;
        
      case DioExceptionType.cancel:
        message = 'Permintaan dibatalkan';
        break;
        
      case DioExceptionType.connectionError:
        message = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
        break;
        
      case DioExceptionType.unknown:
        message = 'Terjadi kesalahan yang tidak diketahui';
        break;
        
      default:
        message = 'Terjadi kesalahan';
    }
    
    return Exception(message);
  }
  
  /// Get Dio instance (for advanced usage)
  Dio get dio => _dio;
}
