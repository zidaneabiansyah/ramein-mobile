import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/ramein_button.dart';
import '../../../shared/widgets/ramein_input.dart';

/// Forgot Password Screen untuk aplikasi Ramein
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isEmailSent = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    super.dispose();
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
                          
                          // Icon
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lock_reset_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Title
                          Text(
                            _isEmailSent ? 'Cek Email Anda' : 'Lupa Kata Sandi?',
                            style: AppTypography.displayMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: AppSpacing.sm),
                          
                          // Description
                          Text(
                            _isEmailSent 
                                ? 'Kami telah mengirim link reset password ke email Anda. Silakan cek inbox atau spam folder.'
                                : 'Masukkan email Anda dan kami akan mengirim link untuk reset password.',
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
                  
                  // Form
                  if (!_isEmailSent) ...[
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // Email Input
                            RameinInput(
                              label: 'Email',
                              hint: 'Masukkan email Anda',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: AppColors.textSecondary,
                                size: AppSpacing.iconMd,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Format email tidak valid';
                                }
                                return null;
                              },
                              isRequired: true,
                            ),
                            
                            const SizedBox(height: AppSpacing.xl),
                            
                            // Send Button
                            RameinButton(
                              text: 'Kirim Link Reset',
                              onPressed: authState.isLoading ? null : _handleSendResetLink,
                              isLoading: authState.isLoading,
                              isFullWidth: true,
                              size: RameinButtonSize.large,
                              icon: Icons.send_rounded,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Email Sent Success
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // Success Icon
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                              ),
                              child: const Icon(
                                Icons.mark_email_read_rounded,
                                color: AppColors.success,
                                size: 50,
                              ),
                            ),
                            
                            const SizedBox(height: AppSpacing.xl),
                            
                            // Email Address
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                border: Border.all(color: AppColors.borderLight),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primary,
                                    size: AppSpacing.iconMd,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      _emailController.text,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: AppSpacing.xl),
                            
                            // Resend Button
                            RameinButton(
                              text: 'Kirim Ulang',
                              onPressed: authState.isLoading ? null : _handleResendEmail,
                              isLoading: authState.isLoading,
                              isFullWidth: true,
                              size: RameinButtonSize.large,
                              variant: RameinButtonVariant.outline,
                              icon: Icons.refresh_rounded,
                            ),
                            
                            const SizedBox(height: AppSpacing.md),
                            
                            // Back to Login
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Kembali ke Login',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: AppSpacing.enormous),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authNotifier = ref.read(authProvider.notifier);
    
    final result = await authNotifier.requestPasswordReset(_emailController.text.trim());
    
    if (result.success) {
      setState(() {
        _isEmailSent = true;
      });
    }
  }

  Future<void> _handleResendEmail() async {
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.requestPasswordReset(_emailController.text.trim());
  }
}
