import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/event_provider.dart';
import '../../../core/providers/article_provider.dart';
import '../../../shared/widgets/pattern_background.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/optimized_image.dart';
import '../../../shared/widgets/animations.dart';
import 'events_screen.dart';
import 'event_detail_screen.dart';
import '../../../shared/widgets/quick_action_button.dart';
import '../../../core/models/quick_action_model.dart';
import '../../qr_scanner/qr_scanner_screen.dart';
import '../../history/history_screen.dart';
import '../../certificates/screens/certificates_screen.dart';
import '../../articles/screens/articles_screen.dart';
import '../../articles/screens/article_detail_screen.dart';
import '../../articles/widgets/article_card.dart';

/// Home Screen untuk aplikasi Ramein
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late List<QuickActionModel> _quickActions;

  @override
  void initState() {
    super.initState();
    _quickActions = _getQuickActions();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200), // Optimized
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<QuickActionModel> _getQuickActions() {
    return [
      // 1. Event
      QuickActionModel(
        id: 'events',
        title: 'Event',
        iconPath: 'assets/icons/Event.png',
        color: AppColors.primary,
        onTap: () => _handleQuickAction('events'),
      ),
      // 2. Scan QR
      QuickActionModel(
        id: 'qr_scan',
        title: 'Scan QR',
        iconPath: 'assets/icons/Scan QR.png',
        color: AppColors.success,
        onTap: () => _handleQuickAction('qr_scan'),
      ),
      // 3. Sertifikat
      QuickActionModel(
        id: 'certificates',
        title: 'Sertifikat',
        iconPath: 'assets/icons/Sertifikat.png',
        color: const Color(0xFF9C27B0), // Purple
        onTap: () => _handleQuickAction('certificates'),
      ),
      // 4. Riwayat
      QuickActionModel(
        id: 'history',
        title: 'Riwayat',
        iconPath: 'assets/icons/Riwayat.png',
        color: AppColors.warning,
        onTap: () => _handleQuickAction('history'),
      ),
      // 5. Chat Bot
      QuickActionModel(
        id: 'chatbot',
        title: 'Chat Bot',
        iconPath: 'assets/icons/Chatbot.png',
        color: const Color(0xFF00BCD4), // Cyan
        badge: 'NEW',
        onTap: () => _handleQuickAction('chatbot'),
      ),
    ];
  }

  void _handleQuickAction(String actionId) {
    switch (actionId) {
      case 'events':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const EventsScreen()),
        );
        break;
      case 'qr_scan':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const QRScannerScreen()),
        );
        break;
      case 'certificates':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CertificatesScreen()),
        );
        break;
      case 'history':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 'chatbot':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Chat Bot feature coming soon! 🤖'),
            backgroundColor: const Color(0xFF00BCD4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: PatternBackground(
        pattern: PatternType.dots,
        opacity: 0.03,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                // Refresh functionality moved to events page
              },
              color: AppColors.primary,
              child: CustomScrollView(
                slivers: [
                  // Enhanced App Bar
                  SliverAppBar(
                    expandedHeight: 140,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            colors: [
                              AppColors.primary,
                              AppColors.primaryDark,
                              AppColors.primary.withValues(alpha: 0.9),
                            ],
                          ),
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
                                            color: Colors.white.withValues(alpha: 0.95),
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Ramein',
                                          style: AppTypography.displayMedium.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.2,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withValues(alpha: 0.3),
                                                offset: const Offset(0, 2),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (authState.isAuthenticated) ...[
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

                  // Quick Actions Section
                  SliverToBoxAdapter(
                    child: RepaintBoundary(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenPadding,
                            vertical: AppSpacing.md,
                          ),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.dashboard_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'Quick Actions',
                                    style: AppTypography.titleMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      QuickActionButton(
                                        key: ValueKey(_quickActions[0].id),
                                        action: _quickActions[0],
                                      ),
                                      QuickActionButton(
                                        key: ValueKey(_quickActions[1].id),
                                        action: _quickActions[1],
                                      ),
                                      QuickActionButton(
                                        key: ValueKey(_quickActions[2].id),
                                        action: _quickActions[2],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      QuickActionButton(
                                        key: ValueKey(_quickActions[3].id),
                                        action: _quickActions[3],
                                      ),
                                      const SizedBox(width: 50),
                                      QuickActionButton(
                                        key: ValueKey(_quickActions[4].id),
                                        action: _quickActions[4],
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

                  // Promo Banner
                  SliverToBoxAdapter(
                    child: RepaintBoundary(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(
                            AppSpacing.screenPadding,
                            AppSpacing.sm,
                            AppSpacing.screenPadding,
                            AppSpacing.md,
                          ),
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary,
                                AppColors.primaryDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                top: -20,
                                child: Icon(
                                  Icons.celebration_rounded,
                                  size: 120,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.xs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '🎉 PROMO SPESIAL',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    Text(
                                      'Daftar Event Gratis!',
                                      style: AppTypography.headlineSmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Ikuti berbagai event menarik dan dapatkan sertifikat',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Featured/Upcoming Events Section
                  SliverToBoxAdapter(
                    child: RepaintBoundary(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.screenPadding,
                                AppSpacing.md,
                                AppSpacing.screenPadding,
                                AppSpacing.sm,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.event_available_rounded,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Text(
                                        'Event Mendatang',
                                        style: AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const EventsScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Lihat Semua',
                                      style: AppTypography.labelMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 190,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final eventState = ref.watch(eventProvider);
                                  
                                  if (eventState.isLoading) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.screenPadding,
                                      ),
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: 260,
                                          margin: const EdgeInsets.only(right: AppSpacing.md),
                                          child: const ShimmerLoading(
                                            width: 260,
                                            height: 190,
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  // Lazy loading: hanya ambil 5 event pertama untuk home
                                  final upcomingEvents = eventState.events.take(5).toList();

                                  if (upcomingEvents.isEmpty) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(AppSpacing.lg),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.event_busy_rounded,
                                              size: 48,
                                              color: AppColors.textTertiary,
                                            ),
                                            const SizedBox(height: AppSpacing.sm),
                                            Text(
                                              'Belum ada event',
                                              style: AppTypography.bodyMedium.copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.screenPadding,
                                    ),
                                    itemCount: upcomingEvents.length,
                                    itemBuilder: (context, index) {
                                      final event = upcomingEvents[index];
                                      return _buildFeaturedEventCard(event);
                                    },
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
                    child: SizedBox(height: AppSpacing.md),
                  ),

                  // Rilis Media Section
                  SliverToBoxAdapter(
                    child: RepaintBoundary(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.screenPadding,
                                AppSpacing.md,
                                AppSpacing.screenPadding,
                                AppSpacing.sm,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.article_rounded,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Text(
                                        'Rilis Media',
                                        style: AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const ArticlesScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Lihat Semua',
                                      style: AppTypography.labelMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 260,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final articleState = ref.watch(articleProvider);
                                  
                                  if (articleState.isLoading) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.screenPadding,
                                      ),
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        final screenWidth = MediaQuery.of(context).size.width;
                                        final cardWidth = screenWidth * 0.85;
                                        
                                        return Container(
                                          width: cardWidth,
                                          margin: const EdgeInsets.only(right: AppSpacing.md),
                                          child: ShimmerLoading(
                                            width: cardWidth,
                                            height: 260,
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  // Lazy loading: hanya ambil 5 artikel pertama untuk home
                                  final articles = articleState.articles.take(5).toList();

                                  if (articles.isEmpty) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(AppSpacing.lg),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.article_outlined,
                                              size: 48,
                                              color: AppColors.textTertiary,
                                            ),
                                            const SizedBox(height: AppSpacing.sm),
                                            Text(
                                              'Belum ada artikel',
                                              style: AppTypography.bodyMedium.copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.screenPadding,
                                    ),
                                    itemCount: articles.length,
                                    itemBuilder: (context, index) {
                                      final article = articles[index];
                                      return ArticleCard(
                                        article: article,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ArticleDetailScreen(
                                                articleId: article.id,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
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
                    child: SizedBox(height: AppSpacing.xl),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedEventCard(dynamic event) {
    return ScaleFadeAnimation(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: RepaintBoundary(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EventDetailScreen(eventId: event.id),
              ),
            );
          },
          child: Container(
            width: 260,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Image with Badge
                Stack(
                  children: [
                    OptimizedImage(
                      imageUrl: event.flyerUrl,
                      width: double.infinity,
                      height: 110,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      errorWidget: Container(
                        width: double.infinity,
                        height: 110,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary,
                              AppColors.primaryDark,
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.event_rounded,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 48,
                        ),
                      ),
                    ),
                    // Free Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'GRATIS',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Event Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.calendar_today_rounded,
                            size: 12,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.eventDate.toString().split(' ')[0],
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}