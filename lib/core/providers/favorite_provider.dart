import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Favorite Provider untuk manage favorite events
/// Menggunakan SharedPreferences untuk persist data
class FavoriteState {
  final Set<String> favoriteEventIds;
  final bool isLoading;

  const FavoriteState({
    this.favoriteEventIds = const {},
    this.isLoading = false,
  });

  FavoriteState copyWith({
    Set<String>? favoriteEventIds,
    bool? isLoading,
  }) {
    return FavoriteState(
      favoriteEventIds: favoriteEventIds ?? this.favoriteEventIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FavoriteNotifier extends StateNotifier<FavoriteState> {
  static const String _favoritesKey = 'favorite_events';

  FavoriteNotifier() : super(const FavoriteState()) {
    _loadFavorites();
  }

  /// Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList(_favoritesKey) ?? [];
      state = state.copyWith(favoriteEventIds: favorites.toSet());
    } catch (e) {
      // Handle error silently
      state = state.copyWith(favoriteEventIds: {});
    }
  }

  /// Toggle favorite status for an event
  Future<void> toggleFavorite(String eventId) async {
    final newFavorites = Set<String>.from(state.favoriteEventIds);
    
    if (newFavorites.contains(eventId)) {
      newFavorites.remove(eventId);
    } else {
      newFavorites.add(eventId);
    }

    state = state.copyWith(favoriteEventIds: newFavorites);
    
    // Save to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, newFavorites.toList());
    } catch (e) {
      // Handle error silently
    }
  }

  /// Check if event is favorite
  bool isFavorite(String eventId) {
    return state.favoriteEventIds.contains(eventId);
  }

  /// Get all favorite event IDs
  Set<String> getFavorites() {
    return state.favoriteEventIds;
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    state = state.copyWith(favoriteEventIds: {});
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
    } catch (e) {
      // Handle error silently
    }
  }
}

/// Provider untuk Favorite
final favoriteProvider = StateNotifierProvider<FavoriteNotifier, FavoriteState>(
  (ref) => FavoriteNotifier(),
);
