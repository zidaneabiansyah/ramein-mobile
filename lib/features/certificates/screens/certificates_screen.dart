import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/certificate_provider.dart';
import '../../../core/models/certificate_model.dart';
import '../../../shared/widgets/ramein_button.dart';
import '../../../shared/widgets/ramein_input.dart';

/// Certificates Screen untuk aplikasi Ramein
/// Menampilkan sertifikat yang sudah didapat user
class CertificatesScreen extends ConsumerStatefulWidget {
  const CertificatesScreen({super.key});

  @override
  ConsumerState<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends ConsumerState<CertificatesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  final List<String> _filterOptions = ['Semua', 'Terbaru', 'Terlama'];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadCertificates();
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

  void _loadCertificates() {
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && authState.user != null) {
      ref.read(certificateProvider.notifier).loadUserCertificates(authState.user!.id);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final certificateState = ref.watch(certificateProvider);

    // Filter certificates based on search and filter
    final filteredCertificates = _filterCertificates(
      certificateState.certificates,
      _searchController.text,
      _selectedFilter,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // App Bar
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sertifikat Saya',
                                  style: AppTypography.headlineMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${certificateState.certificates.length} sertifikat tersedia',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Download All Button
                          if (certificateState.certificates.isNotEmpty)
                            IconButton(
                              onPressed: _downloadAllCertificates,
                              icon: const Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                              ),
                              tooltip: 'Download Semua',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Search and Filter
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.md,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Search Input
                      RameinInput(
                        controller: _searchController,
                        hint: 'Cari sertifikat...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        onChanged: (value) {
                          setState(() {}); // Trigger rebuild for filtering
                        },
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear_rounded),
                              )
                            : null,
                      ),
                      
                      const SizedBox(height: AppSpacing.md),
                      
                      // Filter Chips
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filterOptions.length,
                          itemBuilder: (context, index) {
                            final filter = _filterOptions[index];
                            final isSelected = _selectedFilter == filter;
                            
                            return Padding(
                              padding: const EdgeInsets.only(right: AppSpacing.sm),
                              child: FilterChip(
                                label: Text(
                                  filter,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                backgroundColor: AppColors.surface,
                                selectedColor: AppColors.primary,
                                checkmarkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                                  side: BorderSide(
                                    color: isSelected ? AppColors.primary : AppColors.borderLight,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Certificates List
              Expanded(
                child: certificateState.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : filteredCertificates.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () async => _loadCertificates(),
                            color: AppColors.primary,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.screenPadding,
                              ),
                              itemCount: filteredCertificates.length,
                              itemBuilder: (context, index) {
                                final certificate = filteredCertificates[index];
                                
                                return FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: _buildCertificateCard(certificate, index),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
                Icons.school_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Belum ada sertifikat',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Sertifikat akan muncul setelah Anda menghadiri kegiatan dan mengisi daftar hadir.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            RameinButton(
              text: 'Jelajahi Kegiatan',
              onPressed: () => Navigator.of(context).pop(),
              variant: RameinButtonVariant.outline,
              icon: Icons.explore_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateCard(CertificateModel certificate, int index) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        elevation: AppSpacing.cardElevation,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: InkWell(
          onTap: () => _showCertificateDetail(certificate),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with certificate icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Icon(
                        Icons.verified_rounded,
                        color: AppColors.success,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            certificate.eventTitle,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Sertifikat Kehadiran',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                      size: AppSpacing.iconSm,
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Certificate details
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: AppSpacing.iconSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Diterbitkan: ${dateFormat.format(certificate.issuedAt)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.sm),
                
                Row(
                  children: [
                    Icon(
                      Icons.person_rounded,
                      size: AppSpacing.iconSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Peserta: ${certificate.userId}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: RameinButton(
                        text: 'Lihat Detail',
                        onPressed: () => _showCertificateDetail(certificate),
                        variant: RameinButtonVariant.outline,
                        size: RameinButtonSize.small,
                        icon: Icons.visibility_rounded,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: RameinButton(
                        text: 'Download',
                        onPressed: () => _downloadCertificate(certificate),
                        variant: RameinButtonVariant.primary,
                        size: RameinButtonSize.small,
                        icon: Icons.download_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<CertificateModel> _filterCertificates(
    List<CertificateModel> certificates,
    String searchQuery,
    String filter,
  ) {
    var filtered = certificates;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((cert) =>
          cert.eventTitle.toLowerCase().contains(searchQuery.toLowerCase()) ||
          cert.userId.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    // Apply sort filter
    switch (filter) {
      case 'Terbaru':
        filtered.sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
        break;
      case 'Terlama':
        filtered.sort((a, b) => a.issuedAt.compareTo(b.issuedAt));
        break;
      case 'Semua':
      default:
        // Keep original order
        break;
    }

    return filtered;
  }

  void _showCertificateDetail(CertificateModel certificate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCertificateDetailSheet(certificate),
    );
  }

  Widget _buildCertificateDetailSheet(CertificateModel certificate) {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Sertifikat',
                        style: AppTypography.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        certificate.eventTitle,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.borderLight,
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Certificate Preview
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_rounded,
                          size: 60,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Sertifikat Kehadiran',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          certificate.eventTitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Certificate Information
                  Text(
                    'Informasi Sertifikat',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  _buildInfoRow('Peserta', certificate.userId),
                  _buildInfoRow('Kegiatan', certificate.eventTitle),
                  _buildInfoRow('Tanggal Diterbitkan', dateFormat.format(certificate.issuedAt)),
                  _buildInfoRow('Status', 'Valid'),
                  _buildInfoRow('ID Sertifikat', certificate.id),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(
                  color: AppColors.borderLight,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RameinButton(
                    text: 'Download',
                    onPressed: () => _downloadCertificate(certificate),
                    variant: RameinButtonVariant.primary,
                    icon: Icons.download_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: RameinButton(
                    text: 'Tutup',
                    onPressed: () => Navigator.of(context).pop(),
                    variant: RameinButtonVariant.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
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
      ),
    );
  }

  Future<void> _downloadCertificate(CertificateModel certificate) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Mengunduh sertifikat...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Simulate download
      await Future.delayed(const Duration(seconds: 2));
      
      // Hide loading and show success message
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sertifikat "${certificate.eventTitle}" berhasil diunduh'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
      }
      
    } catch (e) {
      // Hide loading and show error message
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh sertifikat: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
      }
    }
  }

  Future<void> _downloadAllCertificates() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Mengunduh semua sertifikat...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Simulate download
      await Future.delayed(const Duration(seconds: 3));
      
      // Hide loading and show success message
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Semua sertifikat berhasil diunduh'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
      }
      
    } catch (e) {
      // Hide loading and show error message
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh sertifikat: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
      }
    }
  }
}