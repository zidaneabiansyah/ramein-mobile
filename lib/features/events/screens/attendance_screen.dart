import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/ramein_button.dart';
import '../../../shared/widgets/ramein_input.dart';

/// Attendance Screen untuk aplikasi Ramein
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isSubmitting = false;
  final bool _isEventActive = true; // Check if event is currently active

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkEventStatus();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _checkEventStatus() async {
    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call to check event status
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Implement actual event status check
    // Check if current time is within event time range

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _tokenController.dispose();
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Header
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // Back Button
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => context.pop(),
                                icon: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: AppColors.textPrimary,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.surface,
                                  foregroundColor: AppColors.textPrimary,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Animated Attendance Icon
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    gradient: _isEventActive 
                                        ? AppColors.primaryGradient
                                        : LinearGradient(
                                            colors: [AppColors.textTertiary, AppColors.borderMedium],
                                          ),
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _isEventActive 
                                            ? AppColors.primary.withValues(alpha: 0.3)
                                            : AppColors.shadowLight,
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isEventActive 
                                        ? Icons.qr_code_scanner_rounded
                                        : Icons.schedule_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Title
                          Text(
                            'Daftar Hadir',
                            style: AppTypography.displayMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: AppSpacing.sm),
                          
                          Text(
                            _isEventActive 
                                ? 'Masukkan kode token untuk konfirmasi kehadiran'
                                : 'Absensi hanya dapat dilakukan saat kegiatan berlangsung',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.enormous),
                  
                  if (_isEventActive) ...[
                    // Token Input Form
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // Token Input
                            RameinInput(
                              label: 'Kode Token',
                              hint: 'Masukkan 10 digit kode token',
                              controller: _tokenController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                                UpperCaseTextFormatter(),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onSubmitted: (_) => _handleSubmitAttendance(),
                              prefixIcon: const Icon(
                                Icons.confirmation_number_rounded,
                                color: AppColors.textSecondary,
                                size: AppSpacing.iconMd,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kode token tidak boleh kosong';
                                }
                                if (value.length != 10) {
                                  return 'Kode token harus 10 karakter';
                                }
                                return null;
                              },
                              isRequired: true,
                            ),
                            
                            const SizedBox(height: AppSpacing.lg),
                            
                            // Token Info
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: AppColors.info.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                border: Border.all(
                                  color: AppColors.info.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.info,
                                        size: AppSpacing.iconMd,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Text(
                                        'Informasi Token',
                                        style: AppTypography.bodyMedium.copyWith(
                                          color: AppColors.info,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Kode token telah dikirimkan ke email Anda saat mendaftar kegiatan. Periksa inbox atau folder spam.',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: AppSpacing.xl),
                            
                            // Submit Button
                            RameinButton(
                              text: 'Konfirmasi Kehadiran',
                              onPressed: _isSubmitting ? null : _handleSubmitAttendance,
                              isLoading: _isSubmitting,
                              isFullWidth: true,
                              size: RameinButtonSize.large,
                              icon: Icons.check_circle_rounded,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Event Not Active
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              color: AppColors.warning,
                              size: AppSpacing.iconHuge,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'Kegiatan Belum Dimulai',
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Tombol absensi akan aktif pada hari dan jam kegiatan berlangsung. Pastikan Anda hadir tepat waktu.',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: AppSpacing.enormous),
                  
                  // Help Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.help_outline_rounded,
                                color: AppColors.primary,
                                size: AppSpacing.iconMd,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Bantuan',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            '• Kode token dikirimkan via email saat mendaftar\n'
                            '• Token hanya berlaku pada hari kegiatan\n'
                            '• Pastikan Anda hadir di lokasi kegiatan\n'
                            '• Hubungi panitia jika mengalami masalah',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmitAttendance() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual attendance submission logic
      // final attendanceService = Provider.of<AttendanceService>(context, listen: false);
      // await attendanceService.submitAttendance(_tokenController.text);
      
      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _buildSuccessDialog(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Absensi gagal: ${e.toString()}'),
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

  Widget _buildSuccessDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            Text(
              'Kehadiran Berhasil!',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            Text(
              'Terima kasih telah menghadiri kegiatan ini. Sertifikat akan tersedia setelah kegiatan selesai.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            Row(
              children: [
                Expanded(
                  child: RameinButton(
                    text: 'Lihat Sertifikat',
                    onPressed: () {
                      context.pop(); // Close dialog
                      context.push('/certificates');
                    },
                    variant: RameinButtonVariant.outline,
                    size: RameinButtonSize.medium,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: RameinButton(
                    text: 'Selesai',
                    onPressed: () {
                      context.pop(); // Close dialog
                      context.go('/home');
                    },
                    size: RameinButtonSize.medium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom TextInputFormatter to convert input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
