import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article_model.dart';

/// Article State Model
class ArticleState {
  final List<ArticleModel> articles;
  final String? selectedCategory; // 'Informasi', 'Artikel', 'Video'
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const ArticleState({
    this.articles = const [],
    this.selectedCategory,
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  /// Copy method for state updates
  ArticleState copyWith({
    List<ArticleModel>? articles,
    String? selectedCategory,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return ArticleState(
      articles: articles ?? this.articles,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// Get filtered articles by category
  List<ArticleModel> get filteredArticles {
    if (selectedCategory == null) return articles;
    return articles.where((article) => article.category == selectedCategory).toList();
  }
}

/// Article Notifier untuk mengelola state articles
class ArticleNotifier extends StateNotifier<ArticleState> {
  Timer? _timer;

  ArticleNotifier() : super(const ArticleState()) {
    _initialize();
  }

  /// Initialize article data
  Future<void> _initialize() async {
    await loadArticles();
  }

  /// Load articles - dengan dummy data untuk sementara
  /// TODO: Replace dengan API call saat integrasi backend
  Future<void> loadArticles({bool refresh = false}) async {
    if (state.isLoading && !refresh) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Dummy data - akan diganti dengan API call
      final dummyArticles = _getDummyArticles();

      state = state.copyWith(
        articles: dummyArticles,
        isLoading: false,
        hasMore: false, // No pagination for dummy data
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get dummy articles for development
  /// TODO: Remove saat sudah integrasi dengan backend
  List<ArticleModel> _getDummyArticles() {
    final now = DateTime.now();
    
    return [
      ArticleModel(
        id: '1',
        title: 'Dari Desa ke Pasar Nasional, Koperasi Desa Merah Putih Takalar Raih Prestasi Gemilang',
        content: '''
Koperasi Desa Merah Putih di Takalar, Sulawesi Selatan, telah mencatat prestasi luar biasa dengan berhasil menembus pasar nasional. Bermula dari sebuah desa kecil, koperasi ini kini menjadi contoh sukses dalam pengembangan produk lokal.

Dengan dukungan dari berbagai pihak dan semangat gotong royong masyarakat setempat, Koperasi Desa Merah Putih berhasil mengangkat produk-produk unggulan daerah ke kancah nasional. Produk-produk seperti kerajinan tangan, hasil pertanian, dan produk olahan makanan khas daerah kini telah dipasarkan ke berbagai kota besar di Indonesia.

Kesuksesan ini tidak lepas dari strategi pemasaran yang tepat dan peningkatan kualitas produk yang terus dilakukan. Koperasi ini juga aktif mengikuti berbagai pameran dan event nasional untuk memperkenalkan produk-produknya.

Para anggota koperasi juga mendapatkan pelatihan berkelanjutan untuk meningkatkan keterampilan dalam produksi dan manajemen usaha. Hal ini menjadi kunci keberhasilan dalam menghadapi persaingan pasar yang semakin ketat.

Prestasi gemilang ini menjadi inspirasi bagi koperasi-koperasi lain di Indonesia untuk terus berkembang dan tidak takut bersaing di pasar yang lebih luas.
''',
        category: 'Artikel',
        imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
        author: 'Admin Ramein',
        publishedDate: now.subtract(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
        isPublished: true,
        views: 1250,
        tags: ['koperasi', 'prestasi', 'takalar', 'umkm'],
      ),
      ArticleModel(
        id: '2',
        title: 'Copywriting Menulis, Tapi Bukan Untuk Sastrawan',
        content: '''
Copywriting adalah seni menulis yang berbeda dengan penulisan sastra. Jika sastrawan fokus pada keindahan bahasa dan ekspresi artistik, copywriter fokus pada persuasi dan konversi.

Dalam dunia digital marketing, copywriting memegang peranan penting dalam kesuksesan kampanye pemasaran. Sebuah copy yang baik dapat meningkatkan engagement, menggerakkan audiens untuk melakukan tindakan tertentu, dan pada akhirnya meningkatkan penjualan.

Kunci dari copywriting yang efektif adalah memahami target audiens. Seorang copywriter harus bisa "berbicara" dalam bahasa yang dipahami audiens dan menyampaikan pesan dengan cara yang menarik dan relevan.

Beberapa elemen penting dalam copywriting meliputi:
1. Headline yang menarik perhatian
2. Value proposition yang jelas
3. Call-to-action yang persuasif
4. Storytelling yang engaging
5. Social proof yang meyakinkan

Berbeda dengan penulisan kreatif, copywriting memiliki tujuan yang sangat spesifik: menggerakkan pembaca untuk melakukan sesuatu. Entah itu membeli produk, mendaftar newsletter, atau tindakan lainnya.

Namun, bukan berarti copywriting tidak memerlukan kreativitas. Justru, copywriter harus kreatif dalam menyampaikan pesan marketing dengan cara yang tidak terkesan hard-selling.
''',
        category: 'Artikel',
        imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=800',
        author: 'Admin Ramein',
        publishedDate: now.subtract(const Duration(days: 7)),
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
        isPublished: true,
        views: 890,
        tags: ['copywriting', 'marketing', 'digital'],
      ),
      ArticleModel(
        id: '3',
        title: 'Pengumuman Penerimaan Peserta PROA - ABS3 Batch 3 Tahun 2024',
        content: '''
Dengan bangga kami mengumumkan bahwa penerimaan peserta untuk Program PROA - ABS3 Batch 3 Tahun 2024 telah dibuka!

Program PROA (Professional Academy) adalah program pelatihan intensif yang dirancang untuk meningkatkan keterampilan profesional dalam bidang teknologi cloud, khususnya Alibaba Cloud Security.

Detail Program:
• Durasi: 3 bulan
• Mode: Online & Offline
• Sertifikasi: Alibaba Cloud Security
• Biaya: Gratis (Full Scholarship)

Persyaratan:
1. Minimal lulusan SMA/SMK/sederajat
2. Memiliki minat di bidang cloud computing
3. Berkomitmen mengikuti program hingga selesai
4. Mampu berkomunikasi dengan baik dalam tim

Fasilitas yang Didapat:
• Materi pembelajaran komprehensif
• Mentor berpengalaman
• Sertifikat resmi Alibaba Cloud
• Networking dengan profesional industri
• Job placement assistance

Pendaftaran dibuka mulai tanggal 23 September 2024 hingga 13 Oktober 2024. Jangan lewatkan kesempatan emas ini untuk meningkatkan skill Anda!

Untuk informasi lebih lanjut dan pendaftaran, silakan kunjungi website resmi kami atau hubungi contact center.
''',
        category: 'Informasi',
        imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800',
        author: 'Admin Ramein',
        publishedDate: DateTime(2024, 9, 23),
        createdAt: DateTime(2024, 9, 23),
        updatedAt: DateTime(2024, 9, 23),
        isPublished: true,
        views: 2340,
        tags: ['proa', 'abs3', 'pelatihan', 'cloud'],
      ),
      ArticleModel(
        id: '4',
        title: 'Pengumuman Penerimaan Peserta PROA - Batch 3 Tahun 2024',
        content: '''
Setelah kesuksesan batch sebelumnya, kami kembali membuka pendaftaran untuk PROA Batch 3 Tahun 2024!

Program PROA adalah komitmen kami untuk mengembangkan talenta digital Indonesia. Melalui program ini, kami ingin memberikan kesempatan kepada generasi muda Indonesia untuk menguasai teknologi terkini.

Kurikulum program telah disesuaikan dengan kebutuhan industri saat ini, mencakup:
• Cloud Infrastructure
• Network Security
• Data Protection
• Compliance & Governance
• Hands-on Projects

Keunggulan Program:
1. Pembelajaran berbasis project nyata
2. Certified trainer dari industri
3. Lab environment yang lengkap
4. Career support setelah lulus
5. Community support yang aktif

Batch 3 ini kami tingkatkan kualitasnya dengan menambahkan lebih banyak praktik dan studi kasus real-world. Peserta juga akan mendapatkan mentoring one-on-one untuk memastikan pemahaman yang maksimal.

Alumni PROA telah tersebar di berbagai perusahaan teknologi terkemuka di Indonesia. Bergabunglah dan jadilah bagian dari komunitas profesional cloud computing Indonesia!

Mari bersama membangun Indonesia yang lebih digital dan kompetitif di era cloud computing!
''',
        category: 'Informasi',
        imageUrl: 'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=800',
        author: 'Admin Ramein',
        publishedDate: DateTime(2024, 9, 13),
        createdAt: DateTime(2024, 9, 13),
        updatedAt: DateTime(2024, 9, 13),
        isPublished: true,
        views: 1890,
        tags: ['proa', 'pelatihan', 'cloud', 'digital'],
      ),
      ArticleModel(
        id: '5',
        title: 'Pengumuman Penerimaan Peserta Bootcamp FGA - Batch 2 Tahun 2024',
        content: '''
Fresh Graduate Academy (FGA) dengan bangga mengumumkan pembukaan pendaftaran Bootcamp Batch 2 Tahun 2024!

Program bootcamp ini dirancang khusus untuk fresh graduate yang ingin memulai karir di bidang teknologi. Dengan fokus pada pengembangan skill praktis yang dibutuhkan industri.

Program Studi yang Ditawarkan:
• Full Stack Web Development
• Mobile App Development
• UI/UX Design
• Data Science & Analytics
• Cloud Computing

Mengapa FGA Bootcamp?
1. Kurikulum berbasis industri
2. Instruktur berpengalaman 10+ tahun
3. Bootcamp intensif 12 minggu
4. Portfolio projects
5. 90% job placement rate

Syarat Pendaftaran:
• Fresh graduate maksimal 2 tahun
• Passionate tentang teknologi
• Siap belajar intensif
• Memiliki laptop/komputer sendiri

Program ini menggunakan metode pembelajaran immersive dimana peserta akan langsung terjun membuat project-project real-world. Setiap peserta akan dibimbing untuk membuat minimal 3 portfolio projects yang siap dipresentasikan ke perusahaan.

Selain technical skill, kami juga memberikan soft skill training seperti communication, presentation, dan interview preparation untuk memastikan peserta siap masuk ke dunia kerja.

Pendaftaran dibuka tanggal 21 Juni 2024. Kuota terbatas hanya 50 peserta per batch!
''',
        category: 'Informasi',
        imageUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
        author: 'Admin Ramein',
        publishedDate: DateTime(2024, 6, 21),
        createdAt: DateTime(2024, 6, 21),
        updatedAt: DateTime(2024, 6, 21),
        isPublished: true,
        views: 3120,
        tags: ['fga', 'bootcamp', 'fresh graduate'],
      ),
      ArticleModel(
        id: '6',
        title: 'Pengumuman Penerimaan Peserta FGA - Batch 2 Tahun 2024',
        content: '''
Kesempatan emas untuk para fresh graduate! FGA Batch 2 Tahun 2024 kini telah dibuka.

Fresh Graduate Academy hadir sebagai solusi bagi fresh graduate yang kesulitan mendapatkan pekerjaan karena kurangnya pengalaman. Program ini menjembatani gap antara pendidikan formal dan kebutuhan industri.

Highlight Program:
• 3 bulan intensive training
• Live projects dari perusahaan partner
• Weekly mentoring session
• Technical & soft skills development
• Career coaching & interview prep

Track Program:
1. Web Development Track
   - Frontend: React, Vue.js
   - Backend: Node.js, Python
   - Database: PostgreSQL, MongoDB
   
2. Mobile Development Track
   - Flutter
   - React Native
   - Native Android/iOS
   
3. Data Track
   - Data Analysis
   - Machine Learning
   - Data Visualization

Benefit Peserta:
✓ Sertifikat resmi
✓ Job guarantee program
✓ Networking dengan industri
✓ Mentoring seumur hidup
✓ Alumni community access

Proses Seleksi:
1. Pendaftaran online
2. Technical assessment
3. Interview
4. Announcement

Timeline penting:
- Pendaftaran: 3 Mei - 20 Juni 2024
- Seleksi: 21-30 Juni 2024
- Pengumuman: 1 Juli 2024
- Mulai program: 15 Juli 2024

Investasi terbaik untuk masa depan karirmu adalah skill. Jangan lewatkan kesempatan ini!
''',
        category: 'Informasi',
        imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=800',
        author: 'Admin Ramein',
        publishedDate: DateTime(2024, 5, 3),
        createdAt: DateTime(2024, 5, 3),
        updatedAt: DateTime(2024, 5, 3),
        isPublished: true,
        views: 2750,
        tags: ['fga', 'fresh graduate', 'teknologi'],
      ),
    ];
  }

  /// Filter by category
  void filterByCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Refresh articles
  Future<void> refreshArticles() async {
    await loadArticles(refresh: true);
  }

  /// Get article by ID
  ArticleModel? getArticleById(String articleId) {
    try {
      return state.articles.firstWhere((article) => article.id == articleId);
    } catch (e) {
      return null;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Article Provider
final articleProvider = StateNotifierProvider<ArticleNotifier, ArticleState>((ref) {
  return ArticleNotifier();
});

/// Article Selectors
final articlesProvider = Provider<List<ArticleModel>>((ref) {
  return ref.watch(articleProvider).articles;
});

final filteredArticlesProvider = Provider<List<ArticleModel>>((ref) {
  return ref.watch(articleProvider).filteredArticles;
});

final articleLoadingProvider = Provider<bool>((ref) {
  return ref.watch(articleProvider).isLoading;
});

final articleErrorProvider = Provider<String?>((ref) {
  return ref.watch(articleProvider).error;
});
