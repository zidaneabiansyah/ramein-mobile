import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/ramein_button.dart';

/// Event Detail Screen untuk aplikasi Ramein
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = true;
  bool _isRegistering = false;
  bool _isRegistered = false;

  // Mock event data
  Map<String, dynamic>? _event;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadEventDetail();
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  Future<void> _loadEventDetail() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data
    setState(() {
      _event = {
        'id': widget.eventId,
        'title': 'Workshop Flutter Development',
        'date': DateTime.now().add(const Duration(days: 3)),
        'time': '09:00 - 16:00',
        'location': 'Gedung Serbaguna ITB, Bandung',
        'category': 'Teknologi',
        'price': 150000,
        'image': 'https://via.placeholder.com/400x300',
        'description': 'Belajar membuat aplikasi mobile dengan Flutter dari dasar hingga mahir. Workshop ini akan dipandu oleh developer berpengalaman dan akan memberikan hands-on experience dalam pengembangan aplikasi mobile cross-platform.',
        'participants': 45,
        'maxParticipants': 100,
        'organizer': 'Tech Community Bandung',
        'requirements': [
          'Laptop dengan spesifikasi minimal RAM 8GB',
          'Android Studio atau VS Code terinstall',
          'Basic knowledge tentang programming',
          'Semangat untuk belajar',
        ],
        'agenda': [
          {'time': '09:00 - 09:30', 'activity': 'Registration & Welcome'},
          {'time': '09:30 - 10:30', 'activity': 'Introduction to Flutter'},
          {'time': '10:30 - 10:45', 'activity': 'Coffee Break'},
          {'time': '10:45 - 12:00', 'activity': 'Building Your First App'},
          {'time': '12:00 - 13:00', 'activity': 'Lunch Break'},
          {'time': '13:00 - 15:00', 'activity': 'Advanced Flutter Concepts'},
          {'time': '15:00 - 15:15', 'activity': 'Coffee Break'},
          {'time': '15:15 - 16:00', 'activity': 'Q&A and Networking'},
        ],
        'facilities': [
          'Sertifikat digital',
          'Materi pembelajaran',
          'Snack & lunch',
          'Networking session',
        ],
      };
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    final priceFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  foregroundColor: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // Share event
                  },
                  icon: const Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.3),
                    foregroundColor: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Bookmark event
                  },
                  icon: const Icon(
                    Icons.bookmark_outline_rounded,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.3),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: _event!['image'] ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Icon(
                          Icons.event_rounded,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Event Content
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
                        // Category & Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                              ),
                              child: Text(
                                _event!['category'] ?? '',
                                style: AppTypography.labelMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: _event!['price'] == 0 
                                    ? AppColors.accent 
                                    : AppColors.success,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                              ),
                              child: Text(
                                _event!['price'] == 0 
                                    ? 'GRATIS' 
                                    : priceFormat.format(_event!['price']),
                                style: AppTypography.labelMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Title
                        Text(
                          _event!['title'] ?? '',
                          style: AppTypography.displaySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Organizer
                        Row(
                          children: [
                            Icon(
                              Icons.business_rounded,
                              color: AppColors.textSecondary,
                              size: AppSpacing.iconSm,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Oleh ${_event!['organizer']}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Date, Time, Location
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                Icons.calendar_today_rounded,
                                'Tanggal',
                                dateFormat.format(_event!['date']),
                                AppColors.primary,
                              ),
                              const Divider(height: AppSpacing.xl),
                              _buildInfoRow(
                                Icons.access_time_rounded,
                                'Waktu',
                                _event!['time'] ?? '',
                                AppColors.secondary,
                              ),
                              const Divider(height: AppSpacing.xl),
                              _buildInfoRow(
                                Icons.location_on_rounded,
                                'Lokasi',
                                _event!['location'] ?? '',
                                AppColors.accent,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Participants Progress
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Peserta Terdaftar',
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${_event!['participants']}/${_event!['maxParticipants']}',
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              LinearProgressIndicator(
                                value: (_event!['participants'] as int) / (_event!['maxParticipants'] as int),
                                backgroundColor: AppColors.borderLight,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getProgressColor((_event!['participants'] as int) / (_event!['maxParticipants'] as int)),
                                ),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                                minHeight: 8,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Description
                        Text(
                          'Deskripsi',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _event!['description'] ?? '',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Requirements
                        Text(
                          'Persyaratan',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...(_event!['requirements'] as List).map((requirement) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    requirement,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusXl),
            topRight: Radius.circular(AppSpacing.radiusXl),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: RameinButton(
            text: _isRegistered ? 'Sudah Terdaftar' : 'Daftar Sekarang',
            onPressed: _isRegistered ? null : _handleRegister,
            isLoading: _isRegistering,
            isFullWidth: true,
            size: RameinButtonSize.large,
            variant: _isRegistered ? RameinButtonVariant.success : RameinButtonVariant.primary,
            icon: _isRegistered ? Icons.check_circle_rounded : Icons.app_registration_rounded,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppSpacing.iconMd,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) {
      return AppColors.error;
    } else if (progress >= 0.6) {
      return AppColors.warning;
    } else {
      return AppColors.success;
    }
  }

  Future<void> _handleRegister() async {
    setState(() {
      _isRegistering = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual registration logic
      
      setState(() {
        _isRegistered = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Berhasil mendaftar! Token akan dikirim ke email Anda.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pendaftaran gagal: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }
}
