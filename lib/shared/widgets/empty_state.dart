import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Custom Empty State Widget dengan ilustrasi unik
/// Memberikan visual feedback yang engaging saat tidak ada data
class EmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String? title;
  final String? message;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(type);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom Illustration
            _buildIllustration(config),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Title
            Text(
              title ?? config.title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Message
            Text(
              message ?? config.message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                ),
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(_EmptyStateConfig config) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            config.color.withValues(alpha: 0.1),
            config.color.withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background decorative circles
          Positioned(
            top: 20,
            right: 30,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: config.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: config.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Main icon container
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  config.color.withValues(alpha: 0.2),
                  config.color.withValues(alpha: 0.3),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: config.color.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              config.icon,
              size: 60,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  _EmptyStateConfig _getConfig(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.noEvents:
        return _EmptyStateConfig(
          icon: Icons.event_busy_rounded,
          color: AppColors.primary,
          title: 'Belum Ada Event',
          message: 'Saat ini belum ada event yang tersedia. Coba lagi nanti atau cari event lainnya.',
        );
      case EmptyStateType.noCertificates:
        return _EmptyStateConfig(
          icon: Icons.workspace_premium_rounded,
          color: const Color(0xFF9C27B0),
          title: 'Belum Ada Sertifikat',
          message: 'Anda belum memiliki sertifikat. Ikuti event dan dapatkan sertifikat digital gratis!',
        );
      case EmptyStateType.noHistory:
        return _EmptyStateConfig(
          icon: Icons.history_rounded,
          color: const Color(0xFFFF6B35),
          title: 'Belum Ada Riwayat',
          message: 'Riwayat event yang Anda ikuti akan muncul di sini.',
        );
      case EmptyStateType.searchNotFound:
        return _EmptyStateConfig(
          icon: Icons.search_off_rounded,
          color: AppColors.textSecondary,
          title: 'Tidak Ditemukan',
          message: 'Maaf, kami tidak menemukan hasil yang sesuai dengan pencarian Anda.',
        );
      case EmptyStateType.error:
        return _EmptyStateConfig(
          icon: Icons.error_outline_rounded,
          color: AppColors.error,
          title: 'Terjadi Kesalahan',
          message: 'Maaf, terjadi kesalahan. Silakan coba lagi nanti.',
        );
      case EmptyStateType.noConnection:
        return _EmptyStateConfig(
          icon: Icons.wifi_off_rounded,
          color: AppColors.warning,
          title: 'Tidak Ada Koneksi',
          message: 'Periksa koneksi internet Anda dan coba lagi.',
        );
    }
  }
}

enum EmptyStateType {
  noEvents,
  noCertificates,
  noHistory,
  searchNotFound,
  error,
  noConnection,
}

class _EmptyStateConfig {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  _EmptyStateConfig({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });
}
