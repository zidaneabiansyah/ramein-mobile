import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../../shared/widgets/ramein_button.dart';

class AuthHelper {
  /// Menampilkan dialog untuk meminta user login ketika mengakses fitur yang membutuhkan autentikasi
  static void showLoginRequiredDialog(BuildContext context, {String? feature}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  child: const Icon(
                    Icons.login_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Title
                Text(
                  'Login Diperlukan',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Description
                Text(
                  feature != null 
                    ? 'Untuk menggunakan fitur $feature, Anda perlu masuk terlebih dahulu.'
                    : 'Untuk menggunakan fitur ini, Anda perlu masuk terlebih dahulu.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: RameinButton(
                        text: 'Nanti Saja',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        variant: RameinButtonVariant.outline,
                        size: RameinButtonSize.medium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: RameinButton(
                        text: 'Masuk',
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/login');
                        },
                        variant: RameinButtonVariant.primary,
                        size: RameinButtonSize.medium,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/register');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Daftar di sini',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Cek apakah user sudah login (sementara return false untuk demo guest mode)
  static bool isLoggedIn() {
    // TODO: Implement actual authentication check
    return false; // Sementara selalu false untuk demo guest mode
  }
  
  /// Require login untuk mengakses fitur tertentu
  static bool requireLogin(BuildContext context, {String? feature}) {
    if (!isLoggedIn()) {
      showLoginRequiredDialog(context, feature: feature);
      return false;
    }
    return true;
  }
}
