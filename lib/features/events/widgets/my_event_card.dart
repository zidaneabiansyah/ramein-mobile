import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

/// My Event Card Widget untuk menampilkan kegiatan yang sudah didaftar
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class MyEventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback? onTap;
  final VoidCallback? onAttendance;
  final VoidCallback? onCertificate;

  const MyEventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onAttendance,
    this.onCertificate,
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: _getStatusColor(event['status']).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusLg),
                      topRight: Radius.circular(AppSpacing.radiusLg),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: event['image'] ?? '',
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: 120,
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Icon(
                          Icons.event_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  
                  // Status Badge
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(event['status']),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor(event['status']).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(event['status']),
                            color: Colors.white,
                            size: AppSpacing.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            _getStatusText(event['status']),
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Category Badge
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                        border: Border.all(
                          color: AppColors.borderLight,
                        ),
                      ),
                      child: Text(
                        event['category'] ?? '',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event['title'] ?? '',
                      style: AppTypography.eventTitle.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Date & Time
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: AppColors.primary,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          dateFormat.format(event['date']),
                          style: AppTypography.eventDate.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Icon(
                          Icons.access_time_rounded,
                          color: AppColors.textSecondary,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            event['time'] ?? '',
                            style: AppTypography.eventDate.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: AppColors.textSecondary,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            event['location'] ?? '',
                            style: AppTypography.eventLocation.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.md),
                    
                    // Token Info (for registered events)
                    if (event['status'] == 'registered')
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.confirmation_number_rounded,
                              color: AppColors.primary,
                              size: AppSpacing.iconMd,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Token Absensi',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  event['tokenNumber'] ?? '',
                                  style: AppTypography.buttonText.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    
                    // Attendance Info (for completed events)
                    if (event['status'] == 'completed')
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: event['attended'] == true 
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(
                            color: event['attended'] == true 
                                ? AppColors.success.withValues(alpha: 0.3)
                                : AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              event['attended'] == true 
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              color: event['attended'] == true 
                                  ? AppColors.success
                                  : AppColors.warning,
                              size: AppSpacing.iconMd,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status Kehadiran',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: event['attended'] == true 
                                          ? AppColors.success
                                          : AppColors.warning,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    event['attended'] == true ? 'Hadir' : 'Tidak Hadir',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: event['attended'] == true 
                                          ? AppColors.success
                                          : AppColors.warning,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (event['certificateAvailable'] == true)
                              Icon(
                                Icons.workspace_premium_rounded,
                                color: AppColors.accent,
                                size: AppSpacing.iconMd,
                              ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Action Buttons
                    Row(
                      children: [
                        // Attendance Button (for registered events on event day)
                        if (onAttendance != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onAttendance,
                              icon: const Icon(
                                Icons.qr_code_scanner_rounded,
                                size: AppSpacing.iconSm,
                              ),
                              label: Text(
                                'Absen',
                                style: AppTypography.buttonText.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                              ),
                            ),
                          ),
                        
                        // Certificate Button (for completed events with certificate)
                        if (onCertificate != null) ...[
                          if (onAttendance != null) const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onCertificate,
                              icon: const Icon(
                                Icons.workspace_premium_rounded,
                                size: AppSpacing.iconSm,
                              ),
                              label: Text(
                                'Sertifikat',
                                style: AppTypography.buttonText.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                              ),
                            ),
                          ),
                        ],
                        
                        // If no action buttons, show view details button
                        if (onAttendance == null && onCertificate == null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onTap,
                              icon: const Icon(
                                Icons.info_outline_rounded,
                                size: AppSpacing.iconSm,
                              ),
                              label: Text(
                                'Detail',
                                style: AppTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'registered':
        return AppColors.primary;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'registered':
        return Icons.app_registration_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'registered':
        return 'Terdaftar';
      case 'completed':
        return 'Selesai';
      default:
        return 'Unknown';
    }
  }
}
