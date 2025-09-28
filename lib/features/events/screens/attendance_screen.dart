import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/event_provider.dart';
import '../../../shared/widgets/ramein_button.dart';
import '../../../shared/widgets/ramein_input.dart';

/// Attendance Screen untuk aplikasi Ramein
/// Menampilkan form untuk input token kehadiran
class AttendanceScreen extends ConsumerStatefulWidget {
  final String eventId;
  final String eventTitle;
  final String token;

  const AttendanceScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
    required this.token,
  });

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _feedbackController = TextEditingController();
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _tokenController.text = widget.token; // Pre-fill with registration token
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
    _tokenController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);
    
    // Get event details
    final event = eventState.events
        .where((e) => e.id == widget.eventId)
        .firstOrNull;

    if (event == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Kegiatan tidak ditemukan',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  RameinButton(
                    text: 'Kembali',
                    onPressed: () => Navigator.of(context).pop(),
                    variant: RameinButtonVariant.outline,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
                                  'Daftar Hadir',
                                  style: AppTypography.headlineMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  widget.eventTitle,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event Info Card
                          Container(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(AppSpacing.sm),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                      ),
                                      child: Icon(
                                        Icons.event_rounded,
                                        color: AppColors.primary,
                                        size: AppSpacing.iconMd,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Informasi Kegiatan',
                                            style: AppTypography.titleMedium.copyWith(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: AppSpacing.xs),
                                          Text(
                                            'Lengkapi form kehadiran di bawah',
                                            style: AppTypography.bodySmall.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Event details
                                _buildEventDetailRow(
                                  Icons.calendar_today_rounded,
                                  'Tanggal',
                                  DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(event.eventDate),
                                ),
                                
                                const SizedBox(height: AppSpacing.sm),
                                
                                _buildEventDetailRow(
                                  Icons.access_time_rounded,
                                  'Waktu',
                                  event.eventTime,
                                ),
                                
                                const SizedBox(height: AppSpacing.sm),
                                
                                _buildEventDetailRow(
                                  Icons.location_on_rounded,
                                  'Lokasi',
                                  event.location,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Attendance Form
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Form Kehadiran',
                                  style: AppTypography.titleLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Token Input
                                RameinInput(
                                  controller: _tokenController,
                                  label: 'Token Kehadiran',
                                  hint: 'Masukkan token yang dikirim ke email Anda',
                                  prefixIcon: const Icon(Icons.key_rounded),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Token kehadiran harus diisi';
                                    }
                                    if (value.length != 10) {
                                      return 'Token harus terdiri dari 10 digit';
                                    }
                                    if (value != widget.token) {
                                      return 'Token tidak valid';
                                    }
                                    return null;
                                  },
                                  readOnly: true, // Pre-filled and read-only
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Feedback Input (Optional)
                                RameinInput(
                                  controller: _feedbackController,
                                  label: 'Feedback (Opsional)',
                                  hint: 'Bagikan pengalaman atau saran Anda tentang kegiatan ini',
                                  prefixIcon: const Icon(Icons.feedback_rounded),
                                  maxLines: 3,
                                  textInputAction: TextInputAction.newline,
                                ),
                                
                                const SizedBox(height: AppSpacing.xl),
                                
                                // Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  child: RameinButton(
                                    text: 'Konfirmasi Kehadiran',
                                    onPressed: _isSubmitting ? null : _submitAttendance,
                                    variant: RameinButtonVariant.primary,
                                    size: RameinButtonSize.large,
                                    icon: Icons.check_circle_rounded,
                                    isLoading: _isSubmitting,
                                  ),
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Info Text
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.info.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    border: Border.all(
                                      color: AppColors.info.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.info,
                                        size: AppSpacing.iconSm,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          'Pastikan Anda mengisi token yang benar. Kehadiran tidak dapat dibatalkan setelah dikonfirmasi.',
                                          style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.info,
                                          ),
                                        ),
                                      ),
                                    ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppSpacing.iconSm,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitAttendance() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual attendance submission
      // final result = await eventNotifier.submitAttendance(
      //   eventId: widget.eventId,
      //   userId: authState.user?.id ?? '',
      //   token: _tokenController.text,
      //   feedback: _feedbackController.text,
      // );

      // Show success
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Kehadiran berhasil dikonfirmasi!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
        
        // Navigate back after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pop(true); // Return true to indicate success
          }
        });
      }
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengkonfirmasi kehadiran: $e'),
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
          _isSubmitting = false;
        });
      }
    }
  }
}