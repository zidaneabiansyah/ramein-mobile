import 'package:flutter/material.dart';

/// Ramein App Typography
/// Modern, clean, dan readable dengan hierarki yang jelas
class AppTypography {
  // Font Family - Using Flutter's default fonts for better performance
  static const String _primaryFontFamily = 'Roboto';
  static const String _displayFontFamily = 'Roboto';
  
  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  
  // Display Styles - Untuk heading utama (ukuran lebih kecil sesuai frontend)
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 28, // Reduced from 32
    fontWeight: extraBold,
    height: 1.1, // Reduced from 1.2
    letterSpacing: -0.025, // Reduced from -0.5
  );
  
  static TextStyle get displayMedium => const TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 22, // Reduced from 24
    fontWeight: bold,
    height: 1.2, // Reduced from 1.3
    letterSpacing: -0.025, // Reduced from -0.25
  );
  
  static TextStyle get displaySmall => const TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 20, // Reduced from 24
    fontWeight: bold,
    height: 1.3, // Reduced from 1.4
    letterSpacing: -0.025, // Reduced from -0.25
  );

  // Headline Styles - Untuk heading section
  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 24, // Reduced from 28
    fontWeight: bold,
    height: 1.2, // Reduced from 1.3
    letterSpacing: -0.025, // Reduced from -0.25
  );
  
  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 20, // Reduced from 22
    fontWeight: semiBold,
    height: 1.3, // Reduced from 1.4
    letterSpacing: -0.025, // Reduced from -0.25
  );
  
  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 18, // Reduced from 20
    fontWeight: semiBold,
    height: 1.4, // Reduced from 1.5
    letterSpacing: -0.025, // Reduced from -0.25
  );

  // Title Styles - Untuk sub-heading
  static TextStyle get titleLarge => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 18, // Reduced from 20
    fontWeight: semiBold,
    height: 1.4, // Reduced from 1.5
    letterSpacing: 0,
  );
  
  static TextStyle get titleMedium => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 16, // Reduced from 18
    fontWeight: medium,
    height: 1.5, // Reduced from 1.6
    letterSpacing: 0,
  );
  
  static TextStyle get titleSmall => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14, // Reduced from 16
    fontWeight: medium,
    height: 1.5, // Reduced from 1.6
    letterSpacing: 0,
  );

  // Body Styles - Untuk teks utama
  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 16, // Reduced from 18
    fontWeight: regular,
    height: 1.6, // Reduced from 1.7
    letterSpacing: 0,
  );
  
  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14, // Reduced from 16
    fontWeight: regular,
    height: 1.6, // Reduced from 1.7
    letterSpacing: 0,
  );
  
  static TextStyle get bodySmall => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12, // Reduced from 14
    fontWeight: regular,
    height: 1.6, // Reduced from 1.7
    letterSpacing: 0,
  );

  // Label Styles - Untuk label dan caption
  static TextStyle get labelLarge => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14, // Reduced from 16
    fontWeight: medium,
    height: 1.5, // Reduced from 1.6
    letterSpacing: 0.1,
  );
  
  static TextStyle get labelMedium => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12, // Reduced from 14
    fontWeight: medium,
    height: 1.5, // Reduced from 1.6
    letterSpacing: 0.1,
  );
  
  static TextStyle get labelSmall => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 10, // Reduced from 12
    fontWeight: medium,
    height: 1.5, // Reduced from 1.6
    letterSpacing: 0.1,
  );

  // Custom Styles untuk aplikasi Ramein
  
  // App Bar Title
  static TextStyle get appBarTitle => const TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 18,
    fontWeight: semiBold,
    height: 1.2,
    letterSpacing: -0.025,
  );
  
  // Button Text
  static TextStyle get buttonText => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  // Navigation Label
  static TextStyle get navigationLabel => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  // Event Title
  static TextStyle get eventTitle => const TextStyle(
    fontFamily: _displayFontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: -0.025,
  );
  
  // Event Date
  static TextStyle get eventDate => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  // Event Location
  static TextStyle get eventLocation => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.2,
    letterSpacing: 0,
  );
  
  // Event Price
  static TextStyle get eventPrice => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 0,
  );
  
  // Category Chip
  static TextStyle get categoryChip => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 10,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  // Search Hint
  static TextStyle get searchHint => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.2,
    letterSpacing: 0,
  );
  
  // Error Text
  static TextStyle get errorText => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.2,
    letterSpacing: 0,
  );
  
  // Success Text
  static TextStyle get successText => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.2,
    letterSpacing: 0,
  );
  
  // Form Label
  static TextStyle get formLabel => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0,
  );
  
  // Form Input
  static TextStyle get formInput => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.2,
    letterSpacing: 0,
  );
  
  // Link Text
  static TextStyle get linkText => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0,
    decoration: TextDecoration.underline,
  );
  
  // Caption Text
  static TextStyle get captionText => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 10,
    fontWeight: regular,
    height: 1.2,
    letterSpacing: 0,
  );
  
  // Overline Text
  static TextStyle get overlineText => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 10,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  // Button Text (alias for buttonText)
  static TextStyle get button => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  // Token Text (for registration tokens)
  static TextStyle get token => const TextStyle(
    fontFamily: _primaryFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0.1,
  );
}