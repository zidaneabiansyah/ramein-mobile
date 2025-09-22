import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/ramein_button.dart';
import '../../../shared/widgets/ramein_input.dart';
import '../widgets/certificate_card.dart';

/// Certificates Screen untuk aplikasi Ramein
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = true;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _certificates = [
    {
      'id': '1',
      'eventTitle': 'Workshop Flutter Development',
      'eventDate': DateTime.now().subtract(const Duration(days: 30)),
      'certificateNumber': 'CERT-001-2024',
      'issueDate': DateTime.now().subtract(const Duration(days: 25)),
      'category': 'Teknologi',
      'organizer': 'Tech Community Bandung',
      'status': 'active',
      'downloadUrl': 'https://example.com/cert1.pdf',
    },
    {
      'id': '2',
      'eventTitle': 'Seminar Digital Marketing',
      'eventDate': DateTime.now().subtract(const Duration(days: 60)),
      'certificateNumber': 'CERT-002-2024',
      'issueDate': DateTime.now().subtract(const Duration(days: 55)),
      'category': 'Bisnis',
      'organizer': 'Marketing Hub Indonesia',
      'status': 'active',
      'downloadUrl': 'https://example.com/cert2.pdf',
    },
    {
      'id': '3',
      'eventTitle': 'Kelas Memasak Sehat',
      'eventDate': DateTime.now().subtract(const Duration(days: 90)),
      'certificateNumber': 'CERT-003-2024',
      'issueDate': DateTime.now().subtract(const Duration(days: 85)),
      'category': 'Kesehatan',
      'organizer': 'Healthy Living Community',
      'status': 'active',
      'downloadUrl': 'https://example.com/cert3.pdf',
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadCertificates();
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

  Future<void> _loadCertificates() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredCertificates {
    if (_searchQuery.isEmpty) {
      return _certificates;
    }
    return _certificates.where((cert) {
      return cert['eventTitle'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             cert['certificateNumber'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             cert['category'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
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
            onRefresh: _loadCertificates,
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
                  leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
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
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.md),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    ),
                                    child: const Icon(
                                      Icons.workspace_premium_rounded,
                                      color: Colors.white,
                                      size: AppSpacing.iconLg,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sertifikat Saya',
                                          style: AppTypography.displayMedium.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '${_certificates.length} sertifikat tersedia',
                                          style: AppTypography.bodyMedium.copyWith(
                                            color: Colors.white.withValues(alpha: 0.9),
                                          ),
                                        ),
                                      ],
                                    ),
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
                          hint: 'Cari sertifikat...',
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Statistics Cards
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total Sertifikat',
                                '${_certificates.length}',
                                Icons.workspace_premium_rounded,
                                AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _buildStatCard(
                                'Tahun Ini',
                                '${_certificates.where((c) => c['issueDate'].year == DateTime.now().year).length}',
                                Icons.calendar_today_rounded,
                                AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.lg),
                ),

                // Certificates List
                if (_isLoading)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.enormous),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                else if (_filteredCertificates.isEmpty)
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        margin: const EdgeInsets.all(AppSpacing.screenPadding),
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              color: AppColors.textTertiary,
                              size: AppSpacing.iconHuge,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              _searchQuery.isEmpty 
                                  ? 'Belum Ada Sertifikat'
                                  : 'Sertifikat Tidak Ditemukan',
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Ikuti kegiatan dan dapatkan sertifikat digital'
                                  : 'Coba kata kunci yang berbeda',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textTertiary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_searchQuery.isEmpty) ...[
                              const SizedBox(height: AppSpacing.lg),
                              RameinButton(
                                text: 'Jelajahi Kegiatan',
                                onPressed: () {
                                  context.push('/events');
                                },
                                variant: RameinButtonVariant.outline,
                                size: RameinButtonSize.medium,
                                icon: Icons.explore_rounded,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final certificate = _filteredCertificates[index];
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.screenPadding,
                                vertical: AppSpacing.sm,
                              ),
                              child: CertificateCard(
                                certificate: certificate,
                                onTap: () {
                                  _showCertificateDetail(certificate);
                                },
                                onDownload: () {
                                  _downloadCertificate(certificate);
                                },
                                onShare: () {
                                  _shareCertificate(certificate);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _filteredCertificates.length,
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppSpacing.iconLg,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showCertificateDetail(Map<String, dynamic> certificate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCertificateDetailSheet(certificate),
    );
  }

  Widget _buildCertificateDetailSheet(Map<String, dynamic> certificate) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXl),
          topRight: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: AppSpacing.iconLg,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
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
                        certificate['certificateNumber'],
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Info
                  _buildDetailRow('Nama Kegiatan', certificate['eventTitle']),
                  _buildDetailRow('Kategori', certificate['category']),
                  _buildDetailRow('Penyelenggara', certificate['organizer']),
                  _buildDetailRow('Tanggal Kegiatan', dateFormat.format(certificate['eventDate'])),
                  _buildDetailRow('Tanggal Terbit', dateFormat.format(certificate['issueDate'])),
                  _buildDetailRow('Nomor Sertifikat', certificate['certificateNumber']),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: RameinButton(
                          text: 'Unduh PDF',
                          onPressed: () {
                            context.pop();
                            _downloadCertificate(certificate);
                          },
                          variant: RameinButtonVariant.primary,
                          size: RameinButtonSize.medium,
                          icon: Icons.download_rounded,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: RameinButton(
                          text: 'Bagikan',
                          onPressed: () {
                            context.pop();
                            _shareCertificate(certificate);
                          },
                          variant: RameinButtonVariant.outline,
                          size: RameinButtonSize.medium,
                          icon: Icons.share_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
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
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadCertificate(Map<String, dynamic> certificate) {
    // TODO: Implement certificate download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengunduh sertifikat ${certificate['certificateNumber']}'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }

  void _shareCertificate(Map<String, dynamic> certificate) {
    // TODO: Implement certificate sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membagikan sertifikat ${certificate['certificateNumber']}'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }
}
