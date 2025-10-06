import 'dart:async';
import '../models/user_model.dart';
import '../models/event_model.dart';
import '../models/registration_model.dart';
import '../models/attendance_model.dart';
import '../models/certificate_model.dart';

/// Mock API Service untuk simulasi backend
/// Menggunakan data statis yang realistis untuk development
class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  
  // Mock data storage
  final List<UserModel> _users = [];
  final List<EventModel> _events = [];
  final List<RegistrationModel> _registrations = [];
  final List<AttendanceModel> _attendances = [];
  final List<CertificateModel> _certificates = [];

  // Current logged in user
  UserModel? _currentUser;

  /// Initialize mock data
  Future<void> initialize() async {
    await _loadMockEvents();
    await _loadMockUsers();
    await _loadMockCertificates();
  }


  /// Load mock events data
  Future<void> _loadMockEvents() async {
    final now = DateTime.now();
    
    _events.addAll([
      EventModel(
        id: '1',
        title: 'Workshop Flutter Development',
        description: 'Belajar membuat aplikasi mobile dengan Flutter dari dasar hingga mahir. Workshop ini akan dipandu oleh developer berpengalaman dan akan memberikan hands-on experience dalam pengembangan aplikasi mobile cross-platform.',
        eventDate: now.add(const Duration(days: 3)),
        eventTime: '09:00 - 16:00',
        location: 'Gedung Serbaguna ITB, Bandung',
        category: 'Teknologi',
        price: 150000,
        flyerUrl: 'https://picsum.photos/400/600?random=1',
        certificateTemplateUrl: 'https://picsum.photos/800/600?random=11',
        maxParticipants: 100,
        currentParticipants: 45,
        organizer: 'Tech Community Bandung',
        requirements: [
          'Laptop dengan spesifikasi minimal RAM 8GB',
          'Android Studio atau VS Code terinstall',
          'Basic knowledge tentang programming',
          'Semangat untuk belajar',
        ],
        agenda: [
          EventAgenda(time: '09:00 - 09:30', activity: 'Registration & Welcome'),
          EventAgenda(time: '09:30 - 10:30', activity: 'Introduction to Flutter'),
          EventAgenda(time: '10:30 - 10:45', activity: 'Coffee Break'),
          EventAgenda(time: '10:45 - 12:00', activity: 'Building Your First App'),
          EventAgenda(time: '12:00 - 13:00', activity: 'Lunch Break'),
          EventAgenda(time: '13:00 - 15:00', activity: 'Advanced Flutter Concepts'),
          EventAgenda(time: '15:00 - 15:15', activity: 'Coffee Break'),
          EventAgenda(time: '15:15 - 16:00', activity: 'Q&A and Networking'),
        ],
        facilities: [
          'Sertifikat digital',
          'Materi pembelajaran',
          'Snack & lunch',
          'Networking session',
        ],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 1)),
        isActive: true,
        registrationDeadline: now.add(const Duration(days: 2, hours: 12)),
      ),
      
      EventModel(
        id: '2',
        title: 'Seminar Digital Marketing',
        description: 'Strategi pemasaran digital terbaru untuk meningkatkan penjualan online. Pelajari cara menggunakan social media, SEO, dan advertising untuk mengembangkan bisnis Anda.',
        eventDate: now.add(const Duration(days: 7)),
        eventTime: '13:00 - 17:00',
        location: 'Hotel Grand Mercure, Jakarta',
        category: 'Bisnis',
        price: 200000,
        flyerUrl: 'https://picsum.photos/400/600?random=2',
        certificateTemplateUrl: 'https://picsum.photos/800/600?random=12',
        maxParticipants: 150,
        currentParticipants: 78,
        organizer: 'Marketing Pro Indonesia',
        requirements: [
          'Laptop atau tablet untuk praktik',
          'Akun social media untuk praktik',
          'Basic knowledge tentang marketing',
        ],
        agenda: [
          EventAgenda(time: '13:00 - 13:30', activity: 'Registration & Networking'),
          EventAgenda(time: '13:30 - 14:30', activity: 'Digital Marketing Overview'),
          EventAgenda(time: '14:30 - 14:45', activity: 'Coffee Break'),
          EventAgenda(time: '14:45 - 15:45', activity: 'Social Media Strategy'),
          EventAgenda(time: '15:45 - 16:00', activity: 'Break'),
          EventAgenda(time: '16:00 - 17:00', activity: 'SEO & Advertising'),
        ],
        facilities: [
          'Sertifikat digital',
          'E-book materi',
          'Coffee break',
          'Networking session',
        ],
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 1)),
        isActive: true,
        registrationDeadline: now.add(const Duration(days: 6)),
      ),
      
      EventModel(
        id: '3',
        title: 'Kelas Memasak Sehat',
        description: 'Belajar memasak makanan sehat dan bergizi untuk keluarga. Chef profesional akan mengajarkan teknik memasak yang benar dan tips memilih bahan makanan yang sehat.',
        eventDate: now.add(const Duration(days: 5)),
        eventTime: '10:00 - 14:00',
        location: 'Cooking Studio Bandung',
        category: 'Kesehatan',
        price: 100000,
        flyerUrl: 'https://via.placeholder.com/400x600/F59E0B/FFFFFF?text=Healthy+Cooking',
        certificateTemplateUrl: 'https://via.placeholder.com/800x600/00ED64/FFFFFF?text=Certificate+Template',
        maxParticipants: 20,
        currentParticipants: 12,
        organizer: 'Healthy Living Community',
        requirements: [
          'Apron dan topi chef (disediakan)',
          'Siap untuk hands-on cooking',
          'Tidak ada alergi makanan',
        ],
        agenda: [
          EventAgenda(time: '10:00 - 10:30', activity: 'Welcome & Introduction'),
          EventAgenda(time: '10:30 - 11:30', activity: 'Basic Cooking Techniques'),
          EventAgenda(time: '11:30 - 12:00', activity: 'Break'),
          EventAgenda(time: '12:00 - 13:00', activity: 'Cooking Practice'),
          EventAgenda(time: '13:00 - 14:00', activity: 'Lunch & Discussion'),
        ],
        facilities: [
          'Sertifikat digital',
          'Recipe book',
          'Lunch',
          'Apron & cooking tools',
        ],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        isActive: true,
        registrationDeadline: now.add(const Duration(days: 4)),
      ),
      
      EventModel(
        id: '4',
        title: 'Webinar Data Science',
        description: 'Pengantar data science untuk pemula. Pelajari konsep dasar, tools yang digunakan, dan bagaimana data science dapat diterapkan dalam berbagai industri.',
        eventDate: now.add(const Duration(days: 10)),
        eventTime: '19:00 - 21:00',
        location: 'Online via Zoom',
        category: 'Teknologi',
        price: 0, // Free event
        flyerUrl: 'https://picsum.photos/400/600?random=3',
        certificateTemplateUrl: 'https://picsum.photos/800/600?random=13',
        maxParticipants: 500,
        currentParticipants: 234,
        organizer: 'Data Science Indonesia',
        requirements: [
          'Laptop dengan internet connection',
          'Basic knowledge tentang programming',
          'Zoom application',
        ],
        agenda: [
          EventAgenda(time: '19:00 - 19:15', activity: 'Welcome & Introduction'),
          EventAgenda(time: '19:15 - 20:00', activity: 'Introduction to Data Science'),
          EventAgenda(time: '20:00 - 20:15', activity: 'Break'),
          EventAgenda(time: '20:15 - 21:00', activity: 'Tools & Applications'),
        ],
        facilities: [
          'Sertifikat digital',
          'Recording webinar',
          'Materials & resources',
        ],
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        isActive: true,
        registrationDeadline: now.add(const Duration(days: 9)),
      ),
    ]);
  }

  /// Load mock users data
  Future<void> _loadMockUsers() async {
    final now = DateTime.now();
    
    _users.addAll([
      UserModel(
        id: '1',
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '081234567890',
        address: 'Jl. Sudirman No. 123, Jakarta',
        education: 'S1 Teknik Informatika',
        isEmailVerified: true,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      
      UserModel(
        id: '2',
        fullName: 'Jane Smith',
        email: 'jane@example.com',
        phoneNumber: '081234567891',
        address: 'Jl. Thamrin No. 456, Jakarta',
        education: 'S1 Marketing',
        isEmailVerified: true,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ]);
  }

  /// Load mock certificates data
  Future<void> _loadMockCertificates() async {
    final now = DateTime.now();
    
    _certificates.addAll([
      CertificateModel(
        id: 'CERT-001',
        userId: '1',
        eventId: '1',
        eventTitle: 'Workshop Flutter Development',
        certificateUrl: 'https://picsum.photos/800/600?random=cert1',
        issuedAt: now.subtract(const Duration(days: 15)),
        verificationCode: 'VER-FLUTTER-001',
        status: CertificateStatus.issued,
        notes: 'Sertifikat kehadiran workshop Flutter Development',
      ),
      CertificateModel(
        id: 'CERT-002',
        userId: '1',
        eventId: '2',
        eventTitle: 'Seminar Digital Marketing',
        certificateUrl: 'https://picsum.photos/800/600?random=cert2',
        issuedAt: now.subtract(const Duration(days: 10)),
        verificationCode: 'VER-MARKETING-002',
        status: CertificateStatus.issued,
        notes: 'Sertifikat kehadiran seminar digital marketing',
      ),
      CertificateModel(
        id: 'CERT-003',
        userId: '1',
        eventId: '3',
        eventTitle: 'Kelas Memasak Sehat',
        certificateUrl: 'https://picsum.photos/800/600?random=cert3',
        issuedAt: now.subtract(const Duration(days: 7)),
        verificationCode: 'VER-COOKING-003',
        status: CertificateStatus.issued,
        notes: 'Sertifikat kehadiran kelas memasak sehat',
      ),
      CertificateModel(
        id: 'CERT-004',
        userId: '1',
        eventId: '4',
        eventTitle: 'Webinar Data Science',
        certificateUrl: 'https://picsum.photos/800/600?random=cert4',
        issuedAt: now.subtract(const Duration(days: 3)),
        verificationCode: 'VER-DATASCIENCE-004',
        status: CertificateStatus.issued,
        notes: 'Sertifikat kehadiran webinar data science',
      ),
      CertificateModel(
        id: 'CERT-005',
        userId: '1',
        eventId: '1',
        eventTitle: 'Workshop UI/UX Design Fundamentals',
        certificateUrl: 'https://picsum.photos/800/600?random=cert5',
        issuedAt: now.subtract(const Duration(days: 20)),
        verificationCode: 'VER-UIUX-005',
        status: CertificateStatus.issued,
        notes: 'Sertifikat kehadiran workshop UI/UX design',
      ),
      CertificateModel(
        id: 'CERT-006',
        userId: '1',
        eventId: '2',
        eventTitle: 'Bootcamp Web Development',
        certificateUrl: 'https://picsum.photos/800/600?random=cert6',
        issuedAt: now.subtract(const Duration(days: 25)),
        verificationCode: 'VER-WEBDEV-006',
        status: CertificateStatus.issued,
        notes: 'Sertifikat kehadiran bootcamp web development',
      ),
    ]);
  }


  /// Get current user
  UserModel? get currentUser => _currentUser;

  /// Set current user
  void setCurrentUser(UserModel? user) {
    _currentUser = user;
  }

  /// Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  /// Logout user
  void logout() {
    _currentUser = null;
  }

  // Getters for accessing private fields from other services
  List<UserModel> get users => _users;
  List<EventModel> get events => _events;
  List<RegistrationModel> get registrations => _registrations;
  List<AttendanceModel> get attendances => _attendances;
  List<CertificateModel> get certificates => _certificates;
}
