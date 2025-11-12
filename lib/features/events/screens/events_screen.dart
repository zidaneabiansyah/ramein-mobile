import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/event_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/animations.dart';
import '../widgets/event_card.dart';
import '../widgets/category_chip.dart';
import 'event_detail_screen.dart';

/// Events Screen untuk menampilkan daftar semua event
class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedCategory = 'Semua';
  String _selectedSort = 'date_asc';

  final List<Map<String, dynamic>> _sortOptions = [
    {'value': 'date_asc', 'label': 'Tanggal Terdekat'},
    {'value': 'date_desc', 'label': 'Tanggal Terjauh'},
    {'value': 'name_asc', 'label': 'Nama A-Z'},
    {'value': 'name_desc', 'label': 'Nama Z-A'},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Load more when 200px from bottom
      final eventState = ref.read(eventProvider);
      if (!eventState.isLoading && eventState.hasMore) {
        ref.read(eventProvider.notifier).loadMoreEvents();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);
    
    // Handle potential error state
    if (eventState.error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Semua Event'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Terjadi kesalahan',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                eventState.error!,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  try {
                    ref.read(eventProvider.notifier).loadEvents(refresh: true);
                  } catch (e) {
                    debugPrint('Retry error: $e');
                  }
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(eventProvider.notifier).loadEvents(refresh: true);
        },
        color: AppColors.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Semua Event',
                                  style: AppTypography.headlineMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  '${eventState.events.length} event tersedia',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey[50]!, Colors.white],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari event menarik...',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: Colors.grey[500],
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    style: AppTypography.bodyMedium,
                    onChanged: (value) {
                      try {
                        ref.read(eventProvider.notifier).searchEvents(value);
                      } catch (e) {
                        debugPrint('Search error: $e');
                      }
                    },
                  ),
                ),
              ),
            ),

            // Categories
            if (eventState.categories.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.screenPadding,
                        AppSpacing.screenPadding,
                        0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Kategori',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                          left: AppSpacing.screenPadding,
                          right: AppSpacing.screenPadding,
                        ),
                        clipBehavior: Clip.none,
                        itemCount: eventState.categories.length,
                        itemBuilder: (context, index) {
                          if (index >= eventState.categories.length) {
                            return const SizedBox.shrink();
                          }
                          final category = eventState.categories[index];
                          final isSelected = _selectedCategory == category;

                          return Padding(
                            padding: EdgeInsets.only(
                              right: index < eventState.categories.length - 1 
                                  ? AppSpacing.sm 
                                  : 0,
                            ),
                            child: CategoryChip(
                              label: category,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                try {
                                  ref
                                      .read(eventProvider.notifier)
                                      .filterByCategory(
                                        category == 'Semua' ? null : category,
                                      );
                                } catch (e) {
                                  debugPrint('Filter error: $e');
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.screenPadding),
                  ],
                ),
              ),

            // Sort Options
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sort_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Urutkan',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.grey[50]!, Colors.white],
                        ),
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSort,
                          isExpanded: true,
                          items: _sortOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option['value'],
                              child: Text(
                                option['label'],
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedSort = value;
                              });
                              try {
                                ref.read(eventProvider.notifier).sortEvents(value);
                              } catch (e) {
                                debugPrint('Sort error: $e');
                              }
                            }
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Events List
            _buildEventsListSliver(eventState),

            // Loading indicator saat load more
            if (eventState.isLoading && eventState.events.isNotEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),

            // End of list indicator
            if (!eventState.hasMore && eventState.events.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text(
                      'Tidak ada event lagi',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsListSliver(dynamic eventState) {
    if (eventState.isLoading) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Memuat event...',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (eventState.events.isEmpty) {
      return SliverFillRemaining(
        child: EmptyState(
          type: _searchController.text.isNotEmpty 
              ? EmptyStateType.searchNotFound 
              : EmptyStateType.noEvents,
          message: _searchController.text.isNotEmpty
              ? 'Coba ubah kata kunci pencarian atau filter kategori'
              : null,
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            try {
              if (index >= eventState.events.length) {
                return const SizedBox.shrink();
              }
              final event = eventState.events[index];
              return FadeInAnimation(
                delay: Duration(milliseconds: (index * 50).clamp(0, 300).toInt()),
                duration: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: EventCard(
                    event: event,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EventDetailScreen(eventId: event.id),
                        ),
                      );
                    },
                  ),
                ),
              );
            } catch (e) {
              debugPrint('Event card error: $e');
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 24),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Error loading event: $e',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.red[600],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          childCount: eventState.events.length,
        ),
      ),
    );
  }
}