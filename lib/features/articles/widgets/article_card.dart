import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/article_model.dart';
import '../../../shared/widgets/optimized_image.dart';

/// Article Card Widget untuk home page
class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.85; // 85% dari lebar layar
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with category badge
            Stack(
              children: [
                OptimizedImage(
                  imageUrl: article.imageUrl,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  errorWidget: _buildPlaceholderImage(),
                ),
                // Category badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      article.category,
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          article.formattedDate,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCategoryColor(),
            _getCategoryColor().withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getCategoryIcon(),
          color: Colors.white.withValues(alpha: 0.6),
          size: 48,
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (article.category.toLowerCase()) {
      case 'informasi':
        return AppColors.info;
      case 'artikel':
        return AppColors.primary;
      case 'video':
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  IconData _getCategoryIcon() {
    switch (article.category.toLowerCase()) {
      case 'informasi':
        return Icons.info_rounded;
      case 'artikel':
        return Icons.article_rounded;
      case 'video':
        return Icons.play_circle_rounded;
      default:
        return Icons.description_rounded;
    }
  }
}
