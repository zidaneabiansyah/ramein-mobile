import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/event_provider.dart';
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
    // Simple initialization
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      appBar: AppBar(
        title: const Text('Semua Event'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: Column(
        children: [
          // Enhanced Search Bar
          Container(
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
                    // Simple search without complex lifecycle management
                    try {
                      ref.read(eventProvider.notifier).searchEvents(value);
                    } catch (e) {
                      debugPrint('Search error: $e');
                    }
                  },
              ),
            ),
          ),

           // Enhanced Categories
            if (eventState.categories.isNotEmpty && eventState.categories.length > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 40,
                     child: ListView.separated(
                       scrollDirection: Axis.horizontal,
                       itemCount: eventState.categories.length,
                       separatorBuilder:
                           (context, index) =>
                               const SizedBox(width: AppSpacing.sm),
                       itemBuilder: (context, index) {
                         if (index >= eventState.categories.length) {
                           return const SizedBox.shrink();
                         }
                         final category = eventState.categories[index];
                         final isSelected = _selectedCategory == category;

                        return CategoryChip(
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Enhanced Sort Options
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.sort_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Urutkan:',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Container(
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
                        items:
                            _sortOptions.map((option) {
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
                               ref
                                   .read(eventProvider.notifier)
                                   .sortEvents(value);
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
                ),
              ],
            ),
          ),

          // Events List
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[50]),
              child: _buildEventsList(eventState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(dynamic eventState) {
    if (eventState.isLoading) {
      return Center(
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
      );
    }

    if (eventState.events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy_rounded,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Tidak ada event ditemukan',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Coba ubah filter atau kata kunci pencarian',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        try {
          await ref.read(eventProvider.notifier).loadEvents(refresh: true);
        } catch (e) {
          debugPrint('Refresh error: $e');
        }
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: eventState.events.length,
        separatorBuilder:
            (context, index) => const SizedBox(height: AppSpacing.lg),
         itemBuilder: (context, index) {
           try {
             if (index >= eventState.events.length) {
               return const SizedBox.shrink();
             }
             final event = eventState.events[index];
            return EventCard(
              event: event,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(eventId: event.id),
                  ),
                );
              },
            );
          } catch (e) {
            debugPrint('Event card error: $e');
            return Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
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
      ),
    );
  }
}
