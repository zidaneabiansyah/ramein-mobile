import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

/// Notifications Settings Screen
class NotificationsSettingsScreen extends ConsumerStatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  ConsumerState<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends ConsumerState<NotificationsSettingsScreen> {
  bool _eventReminders = true;
  bool _newEvents = true;
  bool _certificates = true;
  bool _promotions = false;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // Notification Types Section
          Text(
            'Notification Types',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          _buildNotificationCard(
            icon: Icons.event_rounded,
            iconColor: AppColors.primary,
            title: 'Event Reminders',
            subtitle: 'Get reminded about upcoming events',
            value: _eventReminders,
            onChanged: (value) {
              setState(() {
                _eventReminders = value;
              });
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildNotificationCard(
            icon: Icons.new_releases_rounded,
            iconColor: AppColors.accent,
            title: 'New Events',
            subtitle: 'Notify me when new events are available',
            value: _newEvents,
            onChanged: (value) {
              setState(() {
                _newEvents = value;
              });
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildNotificationCard(
            icon: Icons.workspace_premium_rounded,
            iconColor: const Color(0xFF9C27B0),
            title: 'Certificates',
            subtitle: 'Notify when certificates are ready',
            value: _certificates,
            onChanged: (value) {
              setState(() {
                _certificates = value;
              });
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildNotificationCard(
            icon: Icons.local_offer_rounded,
            iconColor: AppColors.warning,
            title: 'Promotions',
            subtitle: 'Receive promotional offers and updates',
            value: _promotions,
            onChanged: (value) {
              setState(() {
                _promotions = value;
              });
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // Delivery Methods Section
          Text(
            'Delivery Methods',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          _buildNotificationCard(
            icon: Icons.email_rounded,
            iconColor: const Color(0xFF42A5F5),
            title: 'Email Notifications',
            subtitle: 'Receive notifications via email',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          _buildNotificationCard(
            icon: Icons.notifications_active_rounded,
            iconColor: const Color(0xFFFF7043),
            title: 'Push Notifications',
            subtitle: 'Receive push notifications on this device',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // Save Info
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Changes are saved automatically',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
