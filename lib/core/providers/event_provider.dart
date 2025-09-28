import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';
import '../models/registration_model.dart';
import '../services/event_service.dart';

/// Event State Model
class EventState {
  final List<EventModel> events;
  final List<String> categories;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  final String? selectedCategory;
  final EventSortType sortType;
  final int currentPage;
  final bool hasMore;

  const EventState({
    this.events = const [],
    this.categories = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery,
    this.selectedCategory,
    this.sortType = EventSortType.dateAsc,
    this.currentPage = 1,
    this.hasMore = true,
  });

  /// Copy method for state updates
  EventState copyWith({
    List<EventModel>? events,
    List<String>? categories,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedCategory,
    EventSortType? sortType,
    int? currentPage,
    bool? hasMore,
  }) {
    return EventState(
      events: events ?? this.events,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortType: sortType ?? this.sortType,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Event Notifier untuk mengelola state events
class EventNotifier extends StateNotifier<EventState> {
  final EventService _eventService = EventService();
  
  // Debouncing for search
  Timer? _searchTimer;

  EventNotifier() : super(const EventState()) {
    _initialize();
  }

  /// Initialize event data
  Future<void> _initialize() async {
    await loadCategories();
    await loadEvents();
  }

  /// Load event categories
  Future<void> loadCategories() async {
    try {
      final categories = await _eventService.getEventCategories();
      state = state.copyWith(categories: categories);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Load events with pagination
  Future<void> loadEvents({bool refresh = false}) async {
    if (state.isLoading && !refresh) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final page = refresh ? 1 : state.currentPage;
      final events = await _eventService.getEvents(
        category: state.selectedCategory,
        search: state.searchQuery,
        sortType: state.sortType,
        page: page,
        limit: 20,
      );

      final updatedEvents = refresh 
          ? events 
          : [...state.events, ...events];

      state = state.copyWith(
        events: updatedEvents,
        isLoading: false,
        currentPage: page,
        hasMore: events.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load more events (pagination)
  Future<void> loadMoreEvents() async {
    if (!state.hasMore || state.isLoading) return;

    await loadEvents();
  }

  /// Refresh events
  Future<void> refreshEvents() async {
    await loadEvents(refresh: true);
  }

  /// Search events with debouncing
  void searchEvents(String query) {
    // Cancel previous timer
    _searchTimer?.cancel();
    
    // Update query immediately for UI responsiveness
    state = state.copyWith(searchQuery: query);
    
    // Debounce the actual search
    _searchTimer = Timer(const Duration(milliseconds: 300), () async {
      await loadEvents(refresh: true);
    });
  }

  /// Filter by category
  Future<void> filterByCategory(String? category) async {
    state = state.copyWith(selectedCategory: category);
    await loadEvents(refresh: true);
  }


  /// Get event by ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      return await _eventService.getEventById(eventId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Register for event
  Future<RegistrationResult> registerForEvent({
    required String eventId,
    required String userId,
  }) async {
    try {
      return await _eventService.registerForEvent(
        eventId: eventId,
        userId: userId,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return RegistrationResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Sort events
  void sortEvents(String sortType) {
    try {
      final sortedEvents = _sortEventsList(state.events, sortType);
      state = state.copyWith(events: sortedEvents);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Sort events list based on sort type
  List<EventModel> _sortEventsList(List<EventModel> events, String sortType) {
    final sortedEvents = List<EventModel>.from(events);
    
    switch (sortType) {
      case 'date_asc':
        sortedEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));
        break;
      case 'date_desc':
        sortedEvents.sort((a, b) => b.eventDate.compareTo(a.eventDate));
        break;
      case 'price_asc':
        sortedEvents.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
      case 'price_desc':
        sortedEvents.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
      case 'participants_asc':
        sortedEvents.sort((a, b) => a.currentParticipants.compareTo(b.currentParticipants));
        break;
      case 'participants_desc':
        sortedEvents.sort((a, b) => b.currentParticipants.compareTo(a.currentParticipants));
        break;
      default:
        // Default sort by date ascending
        sortedEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    }
    
    return sortedEvents;
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }
}

/// Event Provider
final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier();
});

/// Event Selectors
final eventsProvider = Provider<List<EventModel>>((ref) {
  return ref.watch(eventProvider).events;
});

final eventCategoriesProvider = Provider<List<String>>((ref) {
  return ref.watch(eventProvider).categories;
});

final eventLoadingProvider = Provider<bool>((ref) {
  return ref.watch(eventProvider).isLoading;
});

final eventErrorProvider = Provider<String?>((ref) {
  return ref.watch(eventProvider).error;
});

/// Registration State Model
class RegistrationState {
  final List<RegistrationModel> registrations;
  final bool isLoading;
  final String? error;

  const RegistrationState({
    this.registrations = const [],
    this.isLoading = false,
    this.error,
  });

  RegistrationState copyWith({
    List<RegistrationModel>? registrations,
    bool? isLoading,
    String? error,
  }) {
    return RegistrationState(
      registrations: registrations ?? this.registrations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Registration Notifier
class RegistrationNotifier extends StateNotifier<RegistrationState> {
  final EventService _eventService = EventService();

  RegistrationNotifier() : super(const RegistrationState());

  /// Register for event
  Future<RegistrationResult> registerForEvent({
    required String eventId,
    required String userId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _eventService.registerForEvent(
        eventId: eventId,
        userId: userId,
      );

      if (result.success) {
        // Reload user registrations
        await loadUserRegistrations(userId);
      } else {
        state = state.copyWith(error: result.message);
      }

      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return RegistrationResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Load user registrations
  Future<void> loadUserRegistrations(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final registrations = await _eventService.getUserRegistrations(userId);
      state = state.copyWith(
        registrations: registrations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Check attendance
  Future<AttendanceResult> checkAttendance({
    required String eventId,
    required String userId,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _eventService.checkAttendance(
        eventId: eventId,
        userId: userId,
        token: token,
      );

      if (result.success) {
        // Reload user registrations to update status
        await loadUserRegistrations(userId);
      } else {
        state = state.copyWith(error: result.message);
      }

      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return AttendanceResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Get user registrations
  Future<List<RegistrationModel>> getUserRegistrations(String userId) async {
    return await _eventService.getUserRegistrations(userId);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Registration Provider
final registrationProvider = StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  return RegistrationNotifier();
});
