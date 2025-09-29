import 'package:flutter/material.dart';

/// Model untuk data onboarding screen
class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final List<Color> gradientColors;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.gradientColors,
  });
}

/// Data onboarding screens
class OnboardingData {
  static const List<OnboardingModel> screens = [
    OnboardingModel(
      title: "Kelola Event dengan Mudah",
      description: "Buat dan kelola event Anda dengan fitur lengkap yang mudah digunakan untuk semua kebutuhan acara.",
      imagePath: "assets/images/onboarding_1.png",
      backgroundColor: Color(0xFF1A2BFF),
      gradientColors: [
        Color(0xFF1A2BFF),
        Color(0xFF0F1BCC),
        Color(0xFF0A0F99),
      ],
    ),
    OnboardingModel(
      title: "Pantau Kehadiran Real-time",
      description: "Lihat dan pantau kehadiran peserta secara real-time dengan sistem QR code yang aman dan cepat.",
      imagePath: "assets/images/onboarding_2.png",
      backgroundColor: Color(0xFF1A2BFF),
      gradientColors: [
        Color(0xFF1A2BFF),
        Color(0xFF0F1BCC),
        Color(0xFF0A0F99),
      ],
    ),
    OnboardingModel(
      title: "Sertifikat Otomatis",
      description: "Generate sertifikat kehadiran otomatis untuk semua peserta yang hadir dengan desain profesional.",
      imagePath: "assets/images/onboarding_3.png",
      backgroundColor: Color(0xFF1A2BFF),
      gradientColors: [
        Color(0xFF1A2BFF),
        Color(0xFF0F1BCC),
        Color(0xFF0A0F99),
      ],
    ),
  ];
}
