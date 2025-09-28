import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/event_provider.dart';
import '../../../core/providers/certificate_provider.dart';
import '../../../shared/widgets/ramein_button.dart';
import '../../../features/auth/screens/login_screen.dart';
import '../../../features/events/screens/my_events_screen.dart';
import '../../../features/certificates/screens/certificates_screen.dart';

/// Profile Screen untuk aplikasi Ramein
/// Menampilkan profil user dan statistik
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserData();
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

  void _loadUserData() {
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && authState.user != null) {
      // Load user events and certificates
      ref.read(registrationProvider.notifier).getUserRegistrations(authState.user!.id);
      ref.read(certificateProvider.notifier).loadUserCertificates(authState.user!.id);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final eventState = ref.watch(eventProvider);
    final certificateState = ref.watch(certificateProvider);

    if (!authState.isAuthenticated || authState.user == null) {
      return _buildNotLoggedInState();
    }

    final user = authState.user!;
    final userRegistrations = eventState.events
        .map((event) => _getUserRegistration(event.id, user.id))
        .where((reg) => reg != null)
        .cast<dynamic>()
        .toList();
    final certificates = certificateState.certificates;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Profile Avatar and Info
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: AppTypography.headlineSmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    user.email,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    user.phoneNumber,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppSpacing.xl),
                        
                        // Stats Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Kegiatan',
                                '${userRegistrations.length}',
                                Icons.event_rounded,
                                Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _buildStatCard(
                                'Sertifikat',
                                '${certificates.length}',
                                Icons.school_rounded,
                                Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _buildStatCard(
                                'Bergabung',
                                DateFormat('MMM yyyy', 'id_ID').format(user.createdAt),
                                Icons.calendar_today_rounded,
                                Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Profile Content
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Information
                          _buildSectionTitle('Informasi Pribadi'),
                          const SizedBox(height: AppSpacing.md),
                          _buildInfoCard(user),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Quick Actions
                          _buildSectionTitle('Aksi Cepat'),
                          const SizedBox(height: AppSpacing.md),
                          _buildQuickActions(),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Settings
                          _buildSectionTitle('Pengaturan'),
                          const SizedBox(height: AppSpacing.md),
                          _buildSettingsList(),
                          
                          const SizedBox(height: AppSpacing.enormous),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotLoggedInState() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    ),
                    child: Icon(
                      Icons.person_off_rounded,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Belum Login',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Silakan login untuk mengakses profil Anda',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  RameinButton(
                    text: 'Login',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    variant: RameinButtonVariant.primary,
                    icon: Icons.login_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.headlineSmall.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInfoCard(dynamic user) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppSpacing.cardElevation,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow('Nama Lengkap', user.fullName),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow('Email', user.email),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow('No. Handphone', user.phoneNumber),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow('Alamat', user.address),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow('Pendidikan Terakhir', user.lastEducation),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        _buildActionTile(
          'Kegiatan Saya',
          'Lihat semua kegiatan yang sudah didaftar',
          Icons.event_rounded,
          AppColors.primary,
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MyEventsScreen(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildActionTile(
          'Sertifikat Saya',
          'Lihat dan download sertifikat yang sudah didapat',
          Icons.school_rounded,
          AppColors.success,
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CertificatesScreen(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppSpacing.cardElevation,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppSpacing.iconMd,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return Column(
      children: [
        _buildSettingsTile(
          'Edit Profil',
          'Ubah informasi pribadi',
          Icons.edit_rounded,
          () => _showComingSoon(),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildSettingsTile(
          'Ubah Password',
          'Ganti password akun Anda',
          Icons.lock_rounded,
          () => _showComingSoon(),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildSettingsTile(
          'Notifikasi',
          'Kelola pengaturan notifikasi',
          Icons.notifications_rounded,
          () => _showComingSoon(),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildSettingsTile(
          'Bantuan',
          'FAQ dan dukungan pelanggan',
          Icons.help_rounded,
          () => _showComingSoon(),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildSettingsTile(
          'Tentang Aplikasi',
          'Versi dan informasi aplikasi',
          Icons.info_rounded,
          () => _showComingSoon(),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildSettingsTile(
          'Logout',
          'Keluar dari akun',
          Icons.logout_rounded,
          () => _showLogoutDialog(),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppSpacing.cardElevation,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: (isDestructive ? AppColors.error : AppColors.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.error : AppColors.primary,
            size: AppSpacing.iconMd,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fitur akan segera hadir!'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Batal',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
            },
            child: Text(
              'Logout',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic _getUserRegistration(String eventId, String userId) {
    // This is a mock implementation
    // In real app, this would come from the registration provider
    return null; // TODO: Implement proper registration retrieval
  }
}
