import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/ramein_input.dart';
import '../widgets/event_card.dart';
import '../widgets/category_chip.dart';

/// Home Screen untuk aplikasi Ramein
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedCategory = 'Semua';
  bool _isLoading = false;

  final List<String> _categories = [
    'Semua',
    'Teknologi',
    'Bisnis',
    'Edukasi',
    'Kesehatan',
    'Olahraga',
    'Seni',
  ];

  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'title': 'Workshop Flutter Development',
      'date': DateTime.now().add(const Duration(days: 3)),
      'time': '09:00 - 16:00',
      'location': 'Gedung Serbaguna ITB',
      'category': 'Teknologi',
      'price': 150000,
      'image': 'https://via.placeholder.com/300x200',
      'description': 'Belajar membuat aplikasi mobile dengan Flutter dari dasar hingga mahir.',
      'participants': 45,
      'maxParticipants': 100,
    },
    {
      'id': '2',
      'title': 'Seminar Digital Marketing',
      'date': DateTime.now().add(const Duration(days: 7)),
      'time': '13:00 - 17:00',
      'location': 'Hotel Grand Mercure',
      'category': 'Bisnis',
      'price': 200000,
      'image': 'https://via.placeholder.com/300x200',
      'description': 'Strategi pemasaran digital terbaru untuk meningkatkan penjualan online.',
      'participants': 78,
      'maxParticipants': 150,
    },
    {
      'id': '3',
      'title': 'Kelas Memasak Sehat',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '10:00 - 14:00',
      'location': 'Cooking Studio Bandung',
      'category': 'Kesehatan',
      'price': 100000,
      'image': 'https://via.placeholder.com/300x200',
      'description': 'Belajar memasak makanan sehat dan bergizi untuk keluarga.',
      'participants': 12,
      'maxParticipants': 20,
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadEvents();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadEvents,
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
                                        'Selamat datang!',
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
                            // Implement search logic
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
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                final category = _categories[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                                  child: CategoryChip(
                                    label: category,
                                    isSelected: _selectedCategory == category,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
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
                      child: Row(
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
                    ),
                  ),
                ),

                // Events List
                _isLoading
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
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final event = _events[index];
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
                                      // Guest dapat melihat detail event
                                      Navigator.of(context).pushNamed('/event-detail', arguments: {
                                        'eventId': event['id'],
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: _events.length,
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
      floatingActionButton: FadeTransition(
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
      ),
    );
  }
}
