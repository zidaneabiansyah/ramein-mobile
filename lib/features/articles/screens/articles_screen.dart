import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/article_provider.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import 'article_detail_screen.dart';

/// Articles Screen (Rilis Media) dengan tabs
class ArticlesScreen extends ConsumerStatefulWidget {
  const ArticlesScreen({super.key});

  @override
  ConsumerState<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends ConsumerState<ArticlesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final categories = ['Informasi', 'Artikel', 'Video'];
      ref.read(articleProvider.notifier).filterByCategory(categories[_tabController.index]);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final articleState = ref.watch(articleProvider);
    final filteredArticles = ref.watch(filteredArticlesProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'RILIS MEDIA',
          style: AppTypography.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: AppColors.primary,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Informasi'),
                Tab(text: 'Artikel'),
                Tab(text: 'Video'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Container(
              color: AppColors.background,
              child: articleState.isLoading
                  ? _buildLoadingState()
                  : filteredArticles.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            await ref.read(articleProvider.notifier).refreshArticles();
                          },
                          color: AppColors.primary,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(AppSpacing.screenPadding),
                            itemCount: filteredArticles.length,
                            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final article = filteredArticles[index];
                              return _buildArticleCard(article);
                            },
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(article) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(articleId: article.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: article.imageUrl != null
                  ? Image.network(
                      article.imageUrl!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary,
                                AppColors.primaryDark,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.article_rounded,
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 40,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primaryDark,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.article_rounded,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 40,
                      ),
                    ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(article.category).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        article.category,
                        style: AppTypography.labelSmall.copyWith(
                          color: _getCategoryColor(article.category),
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      article.title,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            article.formattedDate,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return const ShimmerLoading(
          width: double.infinity,
          height: 120,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Belum ada artikel',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Artikel akan segera ditambahkan',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
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
}
