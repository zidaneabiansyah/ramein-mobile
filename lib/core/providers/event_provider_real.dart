import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model_real.dart';
import '../services/event_service_real.dart';

/// Event State Model
class EventState {
  final List<EventModel> events;
  final List<EventModel> featuredEvents;
  final List<EventModel> upcomingEvents;
  final List<EventCategory> categories;
  final EventModel? selectedEvent;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  final String? selectedCategory;
  final String? selectedType;

  const EventState({
    this.events = const [],
    this.featuredEvents = const [],
    this.upcomingEvents = const [],
    this.categories = const [],
    this.selectedEvent,
    this.isLoading = false,
    this.error,
    this.searchQuery,
    this.selectedCategory,
    this.selectedType,
  });

  EventState copyWith({
    List<EventModel>? events,
    List<EventModel>? featuredEvents,
    List<EventModel>? upcomingEvents,
    List<EventCategory>? categories,
    EventModel? selectedEvent,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedCategory,
    String? selectedType,
    bool clearError = false,
    bool clearSelectedEvent = false,
  }) {
    return EventState(
      events: events ?? this.events,
      featuredEvents: featuredEvents ?? this.featuredEvents,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      categories: categories ?? this.categories,
      selectedEvent: clearSelectedEvent ? null : (selectedEvent ?? this.selectedEvent),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

/// Event Notifier
class EventNotifier extends StateNotifier<EventState> {
  final EventService _eventService = EventService();

  EventNotifier() : super(const EventState()) {
    _initialize();
  }

  /// Initialize - Load featured and categories
  Future<void> _initialize() async {
    await Future.wait([
      loadFeaturedEvents(),
      loadCategories(),
    ]);
  }

  /// Load all events
  Future<void> loadEvents({
    String? search,
    String? category,
    String? eventType,
    bool? isFeatured,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final events = await _eventService.getEvents(
        search: search,
        category: category,
        eventType: eventType,
        isFeatured: isFeatured,
      );

      state = state.copyWith(
        events: events,
        isLoading: false,
        searchQuery: search,
        selectedCategory: category,
        selectedType: eventType,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load featured events
  Future<void> loadFeaturedEvents() async {
    try {
      final events = await _eventService.getFeaturedEvents();
      state = state.copyWith(featuredEvents: events);
    } catch (e) {
      // Silent fail for featured events
    }
  }

  /// Load upcoming events
  Future<void> loadUpcomingEvents() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final events = await _eventService.getUpcomingEvents();
      state = state.copyWith(
        upcomingEvents: events,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load event detail
  Future<void> loadEventDetail(String eventId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final event = await _eventService.getEventDetail(eventId);
      state = state.copyWith(
        selectedEvent: event,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load categories
  Future<void> loadCategories() async {
    try {
      final categories = await _eventService.getCategories();
      state = state.copyWith(categories: categories);
    } catch (e) {
      // Silent fail for categories
    }
  }

  /// Search events
  Future<void> searchEvents(String query) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final events = await _eventService.searchEvents(query);
      state = state.copyWith(
        events: events,
        isLoading: false,
        searchQuery: query,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Filter by category
  Future<void> filterByCategory(String categoryId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final events = await _eventService.getEventsByCategory(categoryId);
      state = state.copyWith(
        events: events,
        isLoading: false,
        selectedCategory: categoryId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Filter by type
  Future<void> filterByType(String eventType) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final events = await _eventService.getEventsByType(eventType);
      state = state.copyWith(
        events: events,
        isLoading: false,
        selectedType: eventType,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear filters
  Future<void> clearFilters() async {
    await loadEvents();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear selected event
  void clearSelectedEvent() {
    state = state.copyWith(clearSelectedEvent: true);
  }

  /// Refresh events
  Future<void> refresh() async {
    await Future.wait([
      loadEvents(),
      loadFeaturedEvents(),
      loadUpcomingEvents(),
    ]);
  }
}

/// Event Provider
final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier();
});

/// Event State Selectors
final eventsListProvider = Provider<List<EventModel>>((ref) {
  return ref.watch(eventProvider).events;
});

final featuredEventsProvider = Provider<List<EventModel>>((ref) {
  return ref.watch(eventProvider).featuredEvents;
});

final upcomingEventsProvider = Provider<List<EventModel>>((ref) {
  return ref.watch(eventProvider).upcomingEvents;
});

final categoriesProvider = Provider<List<EventCategory>>((ref) {
  return ref.watch(eventProvider).categories;
});

final selectedEventProvider = Provider<EventModel?>((ref) {
  return ref.watch(eventProvider).selectedEvent;
});

final eventLoadingProvider = Provider<bool>((ref) {
  return ref.watch(eventProvider).isLoading;
});

final eventErrorProvider = Provider<String?>((ref) {
  return ref.watch(eventProvider).error;
});
