import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/ramein_button.dart';
import '../../../shared/widgets/ramein_input.dart';

/// Register Screen untuk aplikasi Ramein
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _educationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _educationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                          
                          // Logo
                          Container(
                            width: 70,
                            height: 70,
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
                              Icons.person_add_rounded,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Title
                          Text(
                            'Buat Akun Baru',
                            style: AppTypography.displayMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: AppSpacing.sm),
                          
                          Text(
                            'Daftar untuk mengakses semua fitur Ramein',
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
                  
                  // Registration Form
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // Name Input
                          RameinInput(
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama lengkap Anda',
                            controller: _nameController,
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.textSecondary,
                              size: AppSpacing.iconMd,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama lengkap tidak boleh kosong';
                              }
                              if (value.length < 2) {
                                return 'Nama minimal 2 karakter';
                              }
                              return null;
                            },
                            isRequired: true,
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
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
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Phone Input
                          RameinInput(
                            label: 'Nomor HP',
                            hint: 'Masukkan nomor HP Anda',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(13),
                            ],
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: AppColors.textSecondary,
                              size: AppSpacing.iconMd,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor HP tidak boleh kosong';
                              }
                              if (value.length < 10) {
                                return 'Nomor HP minimal 10 digit';
                              }
                              return null;
                            },
                            isRequired: true,
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Address Input
                          RameinInput(
                            label: 'Alamat',
                            hint: 'Masukkan alamat lengkap Anda',
                            controller: _addressController,
                            textInputAction: TextInputAction.next,
                            maxLines: 2,
                            prefixIcon: const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.textSecondary,
                              size: AppSpacing.iconMd,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat tidak boleh kosong';
                              }
                              if (value.length < 10) {
                                return 'Alamat minimal 10 karakter';
                              }
                              return null;
                            },
                            isRequired: true,
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Education Input
                          RameinInput(
                            label: 'Pendidikan Terakhir',
                            hint: 'Contoh: SMA, D3, S1, S2, dll',
                            controller: _educationController,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(
                              Icons.school_outlined,
                              color: AppColors.textSecondary,
                              size: AppSpacing.iconMd,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pendidikan terakhir tidak boleh kosong';
                              }
                              return null;
                            },
                            isRequired: true,
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Password Input
                          RameinPasswordInput(
                            label: 'Kata Sandi',
                            hint: 'Masukkan kata sandi Anda',
                            controller: _passwordController,
                            helperText: 'Minimal 8 karakter dengan kombinasi huruf, angka, dan simbol',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kata sandi tidak boleh kosong';
                              }
                              if (value.length < 8) {
                                return 'Kata sandi minimal 8 karakter';
                              }
                              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
                                  .hasMatch(value)) {
                                return 'Kata sandi harus mengandung huruf besar, kecil, angka, dan simbol';
                              }
                              return null;
                            },
                            isRequired: true,
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Confirm Password Input
                          RameinPasswordInput(
                            label: 'Konfirmasi Kata Sandi',
                            hint: 'Masukkan ulang kata sandi Anda',
                            controller: _confirmPasswordController,
                            onSubmitted: (_) => _handleRegister(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi kata sandi tidak boleh kosong';
                              }
                              if (value != _passwordController.text) {
                                return 'Kata sandi tidak cocok';
                              }
                              return null;
                            },
                            isRequired: true,
                          ),
                          
                          const SizedBox(height: AppSpacing.lg),
                          
                          // Terms and Conditions
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreeToTerms = value ?? false;
                                  });
                                },
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                                  child: RichText(
                                    text: TextSpan(
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Saya menyetujui '),
                                        TextSpan(
                                          text: 'Syarat dan Ketentuan',
                                          style: AppTypography.bodyMedium.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const TextSpan(text: ' dan '),
                                        TextSpan(
                                          text: 'Kebijakan Privasi',
                                          style: AppTypography.bodyMedium.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Register Button
                          RameinButton(
                            text: 'Daftar Sekarang',
                            onPressed: _isLoading ? null : _handleRegister,
                            isLoading: _isLoading,
                            isFullWidth: true,
                            size: RameinButtonSize.large,
                            icon: Icons.person_add_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.enormous),
                  
                  // Login Link
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Masuk di sini',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
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
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Anda harus menyetujui syarat dan ketentuan'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual registration logic
      // final authService = Provider.of<AuthService>(context, listen: false);
      // await authService.register(
      //   name: _nameController.text.trim(),
      //   email: _emailController.text.trim(),
      //   phone: _phoneController.text.trim(),
      //   address: _addressController.text.trim(),
      //   education: _educationController.text.trim(),
      //   password: _passwordController.text,
      // );
      
      // Navigate to email verification
      if (mounted) {
        Navigator.of(context).pushNamed('/verify-email', arguments: {
          'email': _emailController.text.trim(),
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi gagal: ${e.toString()}'),
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
          _isLoading = false;
        });
      }
    }
  }
}
