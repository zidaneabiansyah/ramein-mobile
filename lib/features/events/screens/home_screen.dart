import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/pattern_background.dart';
import 'events_screen.dart';
import '../../../shared/widgets/quick_action_button.dart';
import '../../../core/models/quick_action_model.dart';
import '../../qr_scanner/qr_scanner_screen.dart';
import '../../history/history_screen.dart';
import '../../certificates/screens/certificates_screen.dart';
import '../../profile/screens/profile_screen.dart';

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


    _animationController.forward();
  }


  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<QuickActionModel> _getQuickActions() {
    return [
      QuickActionModel(
        id: 'events',
        title: 'Event',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFF1A2BFF),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EventsScreen(),
            ),
          );
        },
      ),
      QuickActionModel(
        id: 'qr_scan',
        title: 'Scan QR',
        icon: Icons.qr_code_2_rounded,
        color: const Color(0xFF00ED64),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const QRScannerScreen(),
            ),
          );
        },
      ),
      QuickActionModel(
        id: 'history',
        title: 'Riwayat',
        icon: Icons.schedule_rounded,
        color: const Color(0xFFFF6B35),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HistoryScreen(),
            ),
          );
        },
      ),
      QuickActionModel(
        id: 'certificates',
        title: 'Sertifikat',
        icon: Icons.workspace_premium_rounded,
        color: const Color(0xFF9C27B0),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CertificatesScreen(),
            ),
          );
        },
      ),
      QuickActionModel(
        id: 'chatbot',
        title: 'Chatbot',
        icon: Icons.smart_toy_rounded,
        color: const Color(0xFF2196F3),
        badge: 'NEW',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chatbot feature coming soon!'),
              backgroundColor: Color(0xFF2196F3),
            ),
          );
        },
      ),
      QuickActionModel(
        id: 'profile',
        title: 'Profile',
        icon: Icons.account_circle_rounded,
        color: const Color(0xFF607D8B),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ),
          );
        },
      ),
      QuickActionModel(
        id: 'settings',
        title: 'Pengaturan',
        icon: Icons.tune_rounded,
        color: const Color(0xFF795548),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Settings feature coming soon!'),
              backgroundColor: Color(0xFF795548),
            ),
          );
        },
      ),
      QuickActionModel(
        id: 'more',
        title: 'Lainnya',
        icon: Icons.apps_rounded,
        color: const Color(0xFF9E9E9E),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('More features coming soon!'),
              backgroundColor: Color(0xFF9E9E9E),
            ),
          );
        },
      ),
    ];
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
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primaryDark,
                            AppColors.primary.withValues(alpha: 0.9),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
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

                // Quick Actions Section
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.lg,
                        AppSpacing.screenPadding,
                        AppSpacing.screenPadding,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: AppSpacing.xl,
                          mainAxisSpacing: AppSpacing.xl,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: _getQuickActions().length,
                        itemBuilder: (context, index) {
                          final action = _getQuickActions()[index];
                          return QuickActionButton(action: action);
                        },
                      ),
                    ),
                  ),
                ),



                // Banner/Promo Section
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                        vertical: AppSpacing.md,
                      ),
                      height: 160,
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
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
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

                // Tips & Informasi Section
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Tips & Informasi',
                                style: AppTypography.titleLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildTipCard(
                            icon: Icons.verified_rounded,
                            title: 'Verifikasi Email',
                            description: 'Pastikan email Anda terverifikasi untuk menerima token event',
                            color: AppColors.success,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildTipCard(
                            icon: Icons.notifications_active_rounded,
                            title: 'Notifikasi Event',
                            description: 'Aktifkan notifikasi agar tidak ketinggalan event favorit',
                            color: AppColors.warning,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildTipCard(
                            icon: Icons.workspace_premium_rounded,
                            title: 'Kumpulkan Sertifikat',
                            description: 'Hadiri event dan dapatkan sertifikat digital gratis',
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
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
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
