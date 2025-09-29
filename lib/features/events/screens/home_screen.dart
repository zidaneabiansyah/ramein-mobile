import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';
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
        icon: Icons.event,
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
        icon: Icons.qr_code_scanner,
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
        icon: Icons.history,
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
        icon: Icons.school,
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
        icon: Icons.chat,
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
        icon: Icons.person,
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
        icon: Icons.settings,
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
        icon: Icons.more_horiz,
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
      body: Container(
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
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 0, AppSpacing.screenPadding, AppSpacing.screenPadding),
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.grey[50]!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 8),
                            spreadRadius: -10,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.8),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: AppSpacing.lg,
                              mainAxisSpacing: AppSpacing.lg,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: _getQuickActions().length,
                            itemBuilder: (context, index) {
                              final action = _getQuickActions()[index];
                              return QuickActionButton(action: action);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),



                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.lg),
                ),


                // Simple welcome message
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.all(AppSpacing.screenPadding),
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.grey[50]!,
                          ],
                        ),
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
                            Icons.event_available_rounded,
                            size: 48,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Selamat Datang di Ramein',
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Gunakan aksi cepat di atas untuk mulai menjelajahi berbagai kegiatan menarik',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
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
    );
  }
}
