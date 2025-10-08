import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/models/quick_action_model.dart';

/// Quick Action Button seperti Gojek/Grab
class QuickActionButton extends StatelessWidget {
  final QuickActionModel action;

  const QuickActionButton({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image/Icon only - no background
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Main Icon/Image
              action.iconPath != null
                  ? Image.asset(
                      action.iconPath!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      action.icon ?? Icons.apps,
                      color: action.color,
                      size: 56,
                    ),
              // Badge
              if (action.badge != null)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          action.color,
                          action.color.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: action.color.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      action.badge!,
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
            
            const SizedBox(height: 6),
            
            // Enhanced Title
            SizedBox(
              width: 100,
              child: Text(
                action.title,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 0,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
    );
  }
}
