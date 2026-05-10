/// API Configuration
/// Contains all API endpoints and configuration
class ApiConfig {
  // Base URLs
  static const String baseUrl = 'https://ramein-backend.up.railway.app';
  static const String apiUrl = '$baseUrl/api';
  
  // Development URLs (uncomment for local development)
  // static const String baseUrl = 'http://localhost:3001';
  // static const String apiUrl = '$baseUrl/api';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String googleAuth = '/auth/google';
  static const String verifyEmail = '/auth/verify-email';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String requestVerification = '/auth/request-verification';
  
  // User Endpoints
  static const String profile = '/auth/profile';
  static const String updateProfile = '/auth/profile';
  
  // Event Endpoints
  static const String events = '/events';
  static String eventDetail(String id) => '/events/$id';
  static const String featuredEvents = '/events/featured';
  static const String upcomingEvents = '/events/upcoming';
  
  // Participant Endpoints
  static const String registerEvent = '/participants/register';
  static const String myEvents = '/participants/my-events';
  static const String myCertificates = '/participants/my-certificates';
  static const String markAttendance = '/participants/mark-attendance';
  static String eventParticipants(String eventId) => '/participants/event/$eventId';
  
  // Certificate Endpoints
  static const String certificates = '/certificates';
  static String verifyCertificate(String code) => '/certificates/verify/$code';
  static String eventCertificates(String eventId) => '/certificates/event/$eventId';
  
  // Payment Endpoints
  static const String createPayment = '/payment/create';
  static const String paymentSummary = '/payment/summary';
  static String paymentStatus(String orderId) => '/payment/status/$orderId';
  static String cancelPayment(String orderId) => '/payment/cancel/$orderId';
  
  // Article Endpoints
  static const String articles = '/articles';
  static String articleDetail(String slug) => '/articles/$slug';
  static const String articleCategories = '/articles/categories';
  
  // Category Endpoints
  static const String categories = '/categories';
  
  // File Upload
  static const String uploadFile = '/files/upload';
  
  // Google OAuth
  static const String googleClientId = '546818413084-i0a8bncl7e05inka6nuas80dj59nc1fu.apps.googleusercontent.com';
  
  // Xendit
  static const String xenditPublicKey = 'xnd_public_development_zt7mXFglzB5s69jRqupIkAKtnDWAuvlT9IMwdVTTS4SKjWiNrpgPjPg0KJrqqN';
}
