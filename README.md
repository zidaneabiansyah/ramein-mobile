# 📱 Ramein Mobile - Event Management App

<div align="center">
  <img src="assets/images/logo.png" alt="Ramein Logo" width="120" height="120">
  <h3>Modern Event Management Mobile Application</h3>
  <p>Built with Flutter • Modern UI/UX • Cross-platform</p>
</div>

## 🌟 Overview

**Ramein Mobile** adalah aplikasi mobile modern untuk manajemen kegiatan (event) dengan desain yang minimalis dan unik. Aplikasi ini menyediakan dua peran utama: **Admin** dan **Peserta**, dengan fitur-fitur lengkap untuk pengelolaan event dan partisipasi publik.

## ✨ Key Features

### 👥 **Untuk Peserta**
- **🔐 Authentication System**
  - Pendaftaran akun dengan verifikasi email (OTP 5 menit)
  - Login dengan validasi keamanan
  - Password encryption dengan kombinasi kompleks

- **📅 Event Management**
  - Katalog kegiatan dengan sorting berdasarkan tanggal
  - Pencarian kegiatan berdasarkan kata kunci
  - Pendaftaran kegiatan real-time

- **🎟️ Token & Attendance System**
  - 10 digit kode token acak via email
  - Absensi dengan input token
  - Tombol absensi aktif hanya saat event berlangsung

- **🏆 Certificate & History**
  - Riwayat kegiatan yang pernah diikuti
  - Sertifikat digital dengan QR code verification
  - Download dan share sertifikat

### 🛡️ **Untuk Admin**
- **📊 Dashboard & Statistics**
  - Rekap data dengan grafik interaktif
  - Statistik peserta bulanan
  - Top 10 kegiatan dengan peserta terbanyak

- **🎯 Event Management**
  - CRUD kegiatan dengan validasi H-3
  - Upload flyer dan sertifikat template
  - Manajemen kategori dan pricing

- **👥 Participant Management**
  - Data peserta dan kehadiran
  - Export data ke XLS/CSV
  - Bulk participant management

## 🎨 Design Philosophy

### **Modern & Minimalist**
- Clean interface dengan hierarki visual yang jelas
- Consistent spacing dan typography system
- Modern color palette dengan gradient accents

### **Unique Identity**
- Custom color scheme yang membedakan dari aplikasi event lainnya
- Micro-interactions dan smooth animations
- Glassmorphism dan modern card designs

### **User-Centric**
- Intuitive navigation dan user flow
- Responsive design untuk berbagai ukuran layar
- Accessibility-first approach

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.7+ |
| **Language** | Dart |
| **State Management** | Riverpod 2.5+ |
| **Navigation** | GoRouter 14.2+ |
| **UI Components** | Material Design 3 |
| **Typography** | Google Fonts (Inter, Poppins) |
| **HTTP Client** | Dio 5.4+ |
| **Local Storage** | Hive 2.2+ |
| **Charts** | FL Chart 0.68+ |
| **Animations** | Flutter Animate 4.5+ |
| **Image Handling** | Cached Network Image 3.3+ |

## 📁 Project Structure

```
lib/
├── core/                   # Core functionality
│   ├── theme/             # Design system
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   └── app_theme.dart
│   ├── routes/            # Navigation
│   │   └── app_router.dart
│   ├── constants/         # App constants
│   ├── utils/            # Utility functions
│   └── services/         # Core services
│
├── features/              # Feature modules
│   ├── auth/             # Authentication
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── services/
│   ├── events/           # Event management
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── services/
│   ├── certificates/     # Certificate management
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── services/
│   └── admin/           # Admin features
│       ├── screens/
│       ├── widgets/
│       └── services/
│
├── shared/               # Shared components
│   ├── widgets/         # Reusable widgets
│   │   ├── ramein_button.dart
│   │   ├── ramein_input.dart
│   │   └── ...
│   └── models/          # Data models
│
└── main.dart            # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-repo/ramein-mobile.git
   cd ramein-mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   ```bash
   # Copy environment template
   cp lib/core/config/env.example.dart lib/core/config/env.dart
   
   # Edit the configuration file with your API endpoints
   ```

4. **Run the application**
   ```bash
   # Development mode
   flutter run
   
   # Release mode
   flutter run --release
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires macOS and Xcode)
flutter build ios --release
```

## 🎯 Design System

### **Color Palette**
```dart
// Primary Colors
Primary: #6366F1 (Indigo-500)
Primary Light: #818CF8 (Indigo-400)
Primary Dark: #4F46E5 (Indigo-600)

// Secondary Colors
Secondary: #06B6D4 (Cyan-500)
Accent: #EC4899 (Pink-500)

// Status Colors
Success: #10B981 (Emerald-500)
Warning: #F59E0B (Amber-500)
Error: #EF4444 (Red-500)
Info: #3B82F6 (Blue-500)
```

### **Typography Scale**
- **Display**: Poppins (32px, 28px, 24px)
- **Headline**: Inter (22px, 20px, 18px)
- **Title**: Inter (16px, 14px, 12px)
- **Body**: Inter (16px, 14px, 12px)
- **Label**: Inter (14px, 12px, 10px)

### **Spacing System**
- **Base Unit**: 4px
- **Scale**: 4px, 8px, 12px, 16px, 20px, 24px, 32px, 40px, 48px, 64px

## 📱 Screenshots

<div align="center">
  <img src="docs/screenshots/login.png" alt="Login Screen" width="250">
  <img src="docs/screenshots/home.png" alt="Home Screen" width="250">
  <img src="docs/screenshots/event-detail.png" alt="Event Detail" width="250">
</div>

<div align="center">
  <img src="docs/screenshots/attendance.png" alt="Attendance" width="250">
  <img src="docs/screenshots/certificates.png" alt="Certificates" width="250">
  <img src="docs/screenshots/my-events.png" alt="My Events" width="250">
</div>

## 🔧 Configuration

### **API Configuration**
```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://your-api-domain.com/api';
  static const String imageBaseUrl = 'https://your-cdn-domain.com';
  static const Duration timeout = Duration(seconds: 30);
}
```

### **App Configuration**
```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String appName = 'Ramein';
  static const String version = '1.0.0';
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
}
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## 📦 Dependencies

### **Core Dependencies**
- `flutter_riverpod` - State management
- `go_router` - Navigation and routing
- `dio` - HTTP client
- `hive` - Local database
- `google_fonts` - Typography

### **UI Dependencies**
- `cached_network_image` - Image caching
- `flutter_svg` - SVG support
- `shimmer` - Loading animations
- `fl_chart` - Charts and graphs
- `lottie` - Lottie animations

### **Utility Dependencies**
- `intl` - Internationalization
- `url_launcher` - External URL handling
- `share_plus` - Share functionality
- `permission_handler` - Permissions

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### **Development Workflow**
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### **Code Style**
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` for static analysis
- Format code with `flutter format`
- Write tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Material Design** - For the design system
- **Google Fonts** - For beautiful typography
- **Community Contributors** - For valuable feedback and contributions

## 📞 Support

- 📧 Email: support@ramein.app
- 💬 Discord: [Join our community](https://discord.gg/ramein)
- 📱 Telegram: [@ramein_support](https://t.me/ramein_support)
- 🐛 Issues: [GitHub Issues](https://github.com/your-repo/ramein-mobile/issues)

---

<div align="center">
  <p>Made with ❤️ by the Ramein Team</p>
  <p>© 2024 Ramein. All rights reserved.</p>
</div>