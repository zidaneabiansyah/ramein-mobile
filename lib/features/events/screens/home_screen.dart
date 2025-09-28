import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/event_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/ramein_input.dart';
import '../widgets/event_card.dart';
import '../widgets/category_chip.dart';
import 'event_detail_screen.dart';

/// Home Screen untuk aplikasi Ramein
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedCategory = 'Semua';
  String _selectedSort = 'date_asc';


  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400), // Reduced from 800ms
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }


  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);
    final authState = ref.watch(authProvider);

    // Get filtered events
    final filteredEvents = _selectedCategory == 'Semua' 
        ? eventState.events 
        : eventState.events.where((event) => event.category == _selectedCategory).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(eventProvider.notifier).loadEvents(refresh: true);
            },
            color: AppColors.primary,
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
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
                                        authState.isAuthenticated 
                                            ? 'Halo, ${authState.user?.fullName ?? 'User'}!' 
                                            : 'Selamat datang!',
                                        style: AppTypography.bodyLarge.copyWith(
                                          color: Colors.white.withValues(alpha: 0.9),
                                        ),
                                      ),
                                      Text(
                                        'Ramein',
                                        style: AppTypography.displayMedium.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Conditional header based on auth state
                                  if (authState.isAuthenticated) ...[
                                    // User Profile Button
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/profile');
                                      },
                                      icon: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                        ),
                                        child: const Icon(
                                          Icons.person_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    // Guest Mode - Login/Register buttons
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed('/login');
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.md,
                                              vertical: AppSpacing.xs,
                                            ),
                                          ),
                                          child: Text(
                                            'Masuk',
                                            style: AppTypography.labelLarge.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed('/register');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: AppColors.primary,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.lg,
                                              vertical: AppSpacing.xs,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                            ),
                                          ),
                                          child: Text(
                                            'Daftar',
                                            style: AppTypography.labelLarge.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.screenPadding),
                        child: RameinSearchInput(
                          controller: _searchController,
                          hint: 'Cari kegiatan menarik...',
                          onChanged: (value) {
                            ref.read(eventProvider.notifier).searchEvents(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Categories
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.screenPadding,
                            ),
                            child: Text(
                              'Kategori',
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.screenPadding,
                              ),
                              itemCount: ['Semua', ...eventState.categories].length,
                              itemBuilder: (context, index) {
                                final categories = ['Semua', ...eventState.categories];
                                final category = categories[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                                  child: CategoryChip(
                                    label: category,
                                    isSelected: _selectedCategory == category,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                      ref.read(eventProvider.notifier).filterByCategory(
                                        category == 'Semua' ? null : category,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.lg),
                ),

                // Events Header
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Kegiatan Terbaru',
                                style: AppTypography.headlineSmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/events');
                                },
                                child: Text(
                                  'Lihat Semua',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Sorting Dropdown
                          Row(
                            children: [
                              Icon(
                                Icons.sort_rounded,
                                size: AppSpacing.iconSm,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Urutkan:',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                  border: Border.all(
                                    color: AppColors.borderLight,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedSort,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'date_asc',
                                        child: Text(
                                          'Tanggal Terdekat',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'date_desc',
                                        child: Text(
                                          'Tanggal Terjauh',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'price_asc',
                                        child: Text(
                                          'Harga Terendah',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'price_desc',
                                        child: Text(
                                          'Harga Tertinggi',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'participants_asc',
                                        child: Text(
                                          'Peserta Sedikit',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'participants_desc',
                                        child: Text(
                                          'Peserta Banyak',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedSort = value;
                                        });
                                        ref.read(eventProvider.notifier).sortEvents(value);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.textSecondary,
                                      size: AppSpacing.iconSm,
                                    ),
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Events List
                eventState.isLoading
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.enormous),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    : filteredEvents.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.enormous),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.event_busy_rounded,
                                      size: 64,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    Text(
                                      'Belum ada kegiatan',
                                      style: AppTypography.headlineSmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'Coba ubah filter atau cari kata kunci lain',
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final event = filteredEvents[index];
                                return FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.screenPadding,
                                        vertical: AppSpacing.sm,
                                      ),
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
                                  ),
                                );
                              },
                              childCount: filteredEvents.length,
                            ),
                          ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.enormous),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: authState.isAuthenticated
          ? FadeTransition(
              opacity: _fadeAnimation,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).pushNamed('/my-events');
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.event_rounded),
                label: Text(
                  'Kegiatan Saya',
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                elevation: AppSpacing.fabElevation,
              ),
            )
          : null,
    );
  }
}
