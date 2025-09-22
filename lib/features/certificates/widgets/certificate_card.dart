import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

/// Certificate Card Widget untuk menampilkan informasi sertifikat
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class CertificateCard extends StatelessWidget {
  final Map<String, dynamic> certificate;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  const CertificateCard({
    super.key,
    required this.certificate,
    this.onTap,
    this.onDownload,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    return Card(
      elevation: AppSpacing.cardElevation,
      shadowColor: AppColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.surface,
                _getCategoryColor(certificate['category']).withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Certificate Icon
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getCategoryColor(certificate['category']),
                          _getCategoryColor(certificate['category']).withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: _getCategoryColor(certificate['category']).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: AppSpacing.iconLg,
                    ),
                  ),
                  
                  const SizedBox(width: AppSpacing.md),
                  
                  // Certificate Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(certificate['category']).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                            border: Border.all(
                              color: _getCategoryColor(certificate['category']).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            certificate['category'] ?? '',
                            style: AppTypography.labelSmall.copyWith(
                              color: _getCategoryColor(certificate['category']),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: AppSpacing.sm),
                        
                        // Certificate Number
                        Text(
                          certificate['certificateNumber'] ?? '',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(certificate['status']).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                      border: Border.all(
                        color: _getStatusColor(certificate['status']).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(certificate['status']),
                          color: _getStatusColor(certificate['status']),
                          size: AppSpacing.iconXs,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          _getStatusText(certificate['status']),
                          style: AppTypography.labelSmall.copyWith(
                            color: _getStatusColor(certificate['status']),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Event Title
              Text(
                certificate['eventTitle'] ?? '',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              // Organizer
              Row(
                children: [
                  Icon(
                    Icons.business_rounded,
                    color: AppColors.textSecondary,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      certificate['organizer'] ?? '',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Dates
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Kegiatan',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          dateFormat.format(certificate['eventDate']),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Terbit',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Text(
                          dateFormat.format(certificate['issueDate']),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              const Divider(
                height: 1,
                color: AppColors.borderLight,
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onDownload,
                      icon: const Icon(
                        Icons.download_rounded,
                        size: AppSpacing.iconSm,
                      ),
                      label: Text(
                        'Unduh',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: AppColors.borderLight,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onShare,
                      icon: const Icon(
                        Icons.share_rounded,
                        size: AppSpacing.iconSm,
                      ),
                      label: Text(
                        'Bagikan',
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'teknologi':
        return AppColors.primary;
      case 'bisnis':
        return AppColors.secondary;
      case 'kesehatan':
        return AppColors.success;
      case 'edukasi':
        return AppColors.info;
      case 'seni':
        return AppColors.accent;
      case 'olahraga':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'expired':
        return AppColors.warning;
      case 'revoked':
        return AppColors.error;
      default:
        return AppColors.success;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Icons.check_circle_rounded;
      case 'expired':
        return Icons.schedule_rounded;
      case 'revoked':
        return Icons.cancel_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return 'Aktif';
      case 'expired':
        return 'Kedaluwarsa';
      case 'revoked':
        return 'Dicabut';
      default:
        return 'Aktif';
    }
  }
}
