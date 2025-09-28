import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/ramein_button.dart';
import '../../../shared/widgets/ramein_input.dart';
import '../../../features/events/screens/home_screen.dart';

/// Email Verification Screen untuk aplikasi Ramein
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;
  
  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isResending = false;
  int _countdown = 300; // 5 minutes in seconds
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startCountdown();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _countdown > 0) {
        setState(() {
          _countdown--;
        });
        _startCountdown();
      } else if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String _formatCountdown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        );
      } else if (next.isAuthenticated && next.isEmailVerified) {
        // Navigate to home screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    });

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
                  const SizedBox(height: AppSpacing.enormous),
                  
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
                                onPressed: () => Navigator.of(context).pop(),
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
                          
                          // Animated Email Icon
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.secondaryGradient,
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.secondary.withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.mark_email_unread_rounded,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Title
                          Text(
                            'Verifikasi Email',
                            style: AppTypography.displayMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: AppSpacing.sm),
                          
                          Text(
                            'Kami telah mengirimkan kode verifikasi ke',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: AppSpacing.sm),
                          
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              widget.email,
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.enormous),
                  
                  // OTP Form
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // OTP Input
                          RameinInput(
                            label: 'Kode Verifikasi',
                            hint: 'Masukkan 6 digit kode',
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            maxLength: 6,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            onSubmitted: (_) => _handleVerify(),
                            prefixIcon: const Icon(
                              Icons.security_rounded,
                              color: AppColors.textSecondary,
                              size: AppSpacing.iconMd,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kode verifikasi tidak boleh kosong';
                              }
                              if (value.length != 6) {
                                return 'Kode verifikasi harus 6 digit';
                              }
                              return null;
                            },
                            isRequired: true,
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Countdown Timer
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: _canResend 
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              border: Border.all(
                                color: _canResend 
                                    ? AppColors.success.withValues(alpha: 0.3)
                                    : AppColors.warning.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _canResend ? Icons.check_circle_rounded : Icons.timer_rounded,
                                  color: _canResend ? AppColors.success : AppColors.warning,
                                  size: AppSpacing.iconMd,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  _canResend 
                                      ? 'Kode dapat dikirim ulang'
                                      : 'Kirim ulang dalam ${_formatCountdown(_countdown)}',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: _canResend ? AppColors.success : AppColors.warning,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Verify Button
                          RameinButton(
                            text: 'Verifikasi Email',
                            onPressed: authState.isLoading ? null : _handleVerify,
                            isLoading: authState.isLoading,
                            isFullWidth: true,
                            size: RameinButtonSize.large,
                            icon: Icons.verified_rounded,
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Resend Button
                          RameinButton(
                            text: 'Kirim Ulang Kode',
                            onPressed: _canResend && !_isResending ? _handleResend : null,
                            isLoading: _isResending,
                            variant: RameinButtonVariant.outline,
                            isFullWidth: true,
                            size: RameinButtonSize.medium,
                            icon: Icons.refresh_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.enormous),
                  
                  // Help Text
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
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
                                'Tidak menerima email?',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Periksa folder spam atau junk mail. Kode verifikasi akan kedaluwarsa dalam 5 menit.',
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

  Future<void> _handleVerify() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authNotifier = ref.read(authProvider.notifier);
    
    await authNotifier.verifyEmail(
      email: widget.email,
      token: _otpController.text,
    );
  }

  Future<void> _handleResend() async {
    setState(() {
      _isResending = true;
    });

    try {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.resendVerificationEmail(widget.email);
      
      // Reset countdown
      setState(() {
        _countdown = 300;
        _canResend = false;
      });
      _startCountdown();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Kode verifikasi telah dikirim ulang'),
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
            content: Text('Gagal mengirim ulang: ${e.toString()}'),
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
          _isResending = false;
        });
      }
    }
  }
}
