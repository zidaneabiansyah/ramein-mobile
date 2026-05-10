import '../config/api_config.dart';
import 'api_client.dart';

/// Article Model
class ArticleModel {
  final String id;
  final String title;
  final String slug;
  final String content;
  final String excerpt;
  final String? coverImage;
  final String? categoryId;
  final String? categoryName;
  final String author;
  final int views;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    required this.excerpt,
    this.coverImage,
    this.categoryId,
    this.categoryName,
    required this.author,
    this.views = 0,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'] ?? '',
      excerpt: json['excerpt'] ?? '',
      coverImage: json['coverImage'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      author: json['author'] ?? 'Admin',
      views: json['views'] ?? 0,
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'content': content,
      'excerpt': excerpt,
      'coverImage': coverImage,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'author': author,
      'views': views,
      'publishedAt': publishedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Article Category Model
class ArticleCategoryModel {
  final String id;
  final String name;
  final String? description;

  const ArticleCategoryModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory ArticleCategoryModel.fromJson(Map<String, dynamic> json) {
    return ArticleCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

/// Article Service
/// Handles article operations
class ArticleService {
  final _apiClient = ApiClient();

  /// Get all articles
  Future<List<ArticleModel>> getArticles({
    String? category,
    int? limit,
    int? page,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (category != null) {
        queryParams['category'] = category;
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (page != null) {
        queryParams['page'] = page.toString();
      }

      final response = await _apiClient.get(
        ApiConfig.articles,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ArticleModel.fromJson(json)).toList();
      }

      throw Exception('Gagal memuat artikel');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get article detail by slug
  Future<ArticleModel> getArticleDetail(String slug) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.articleDetail(slug),
      );

      if (response.statusCode == 200) {
        return ArticleModel.fromJson(response.data);
      }

      throw Exception('Gagal memuat detail artikel');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Get article categories
  Future<List<ArticleCategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiConfig.articleCategories);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ArticleCategoryModel.fromJson(json)).toList();
      }

      throw Exception('Gagal memuat kategori');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
