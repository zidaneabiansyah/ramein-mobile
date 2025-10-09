/// Article Model untuk aplikasi Ramein
/// Berisi data artikel/media dan method untuk serialization
class ArticleModel {
  final String id;
  final String title;
  final String content;
  final String category; // 'Artikel', 'Informasi', 'Video'
  final String? imageUrl;
  final String? videoUrl;
  final String author;
  final DateTime publishedDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;
  final int views;
  final List<String> tags;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    this.videoUrl,
    required this.author,
    required this.publishedDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublished,
    this.views = 0,
    this.tags = const [],
  });

  /// Factory constructor untuk membuat ArticleModel dari JSON
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? 'Artikel',
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      author: json['author'] ?? '',
      publishedDate: DateTime.parse(json['published_date'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      isPublished: json['is_published'] ?? true,
      views: json['views'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  /// Method untuk mengkonversi ArticleModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'author': author,
      'published_date': publishedDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_published': isPublished,
      'views': views,
      'tags': tags,
    };
  }

  /// Copy method dengan parameter opsional untuk update
  ArticleModel copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? imageUrl,
    String? videoUrl,
    String? author,
    DateTime? publishedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
    int? views,
    List<String>? tags,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      author: author ?? this.author,
      publishedDate: publishedDate ?? this.publishedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      views: views ?? this.views,
      tags: tags ?? this.tags,
    );
  }

  /// Check apakah artikel adalah video
  bool get isVideo => category.toLowerCase() == 'video';

  /// Check apakah artikel adalah informasi
  bool get isInformasi => category.toLowerCase() == 'informasi';

  /// Format tanggal untuk ditampilkan
  String get formattedDate {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${publishedDate.day} ${months[publishedDate.month - 1]} ${publishedDate.year}';
  }

  @override
  String toString() {
    return 'ArticleModel(id: $id, title: $title, category: $category, publishedDate: $publishedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArticleModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
