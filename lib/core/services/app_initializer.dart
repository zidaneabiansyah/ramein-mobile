import 'storage_service.dart';

/// App Initializer
/// Handles app initialization tasks
class AppInitializer {
  static final AppInitializer _instance = AppInitializer._internal();
  factory AppInitializer() => _instance;
  AppInitializer._internal();

  bool _isInitialized = false;

  /// Initialize app
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize storage
      await StorageService().init();

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize app: $e');
    }
  }

  /// Check if app is initialized
  bool get isInitialized => _isInitialized;
}
