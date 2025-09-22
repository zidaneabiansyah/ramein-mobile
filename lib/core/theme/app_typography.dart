import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Ramein App Typography
/// Modern, clean, dan readable dengan hierarki yang jelas
class AppTypography {
  // Font Family
  static const String _primaryFontFamily = 'Inter';
  static const String _displayFontFamily = 'Poppins';
  
  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  
  // Display Styles - Untuk heading utama
  static TextStyle get displayLarge => GoogleFonts.getFont(
    _displayFontFamily,
    fontSize: 32,
    fontWeight: extraBold,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  static TextStyle get displayMedium => GoogleFonts.getFont(
    _displayFontFamily,
    fontSize: 28,
    fontWeight: bold,
    height: 1.3,
    letterSpacing: -0.25,
  );
  
  static TextStyle get displaySmall => GoogleFonts.getFont(
    _displayFontFamily,
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: 0,
  );
  
  // Headline Styles - Untuk section headers
  static TextStyle get headlineLarge => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 22,
    fontWeight: semiBold,
    height: 1.4,
    letterSpacing: 0,
  );
  
  static TextStyle get headlineMedium => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 20,
    fontWeight: semiBold,
    height: 1.4,
    letterSpacing: 0,
  );
  
  static TextStyle get headlineSmall => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 18,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0,
  );
  
  // Title Styles - Untuk card titles dan labels
  static TextStyle get titleLarge => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 16,
    fontWeight: medium,
    height: 1.5,
    letterSpacing: 0,
  );
  
  static TextStyle get titleMedium => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 14,
    fontWeight: medium,
    height: 1.5,
    letterSpacing: 0.1,
  );
  
  static TextStyle get titleSmall => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.5,
    letterSpacing: 0.1,
  );
  
  // Body Styles - Untuk text content
  static TextStyle get bodyLarge => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.6,
    letterSpacing: 0,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.6,
    letterSpacing: 0,
  );
  
  static TextStyle get bodySmall => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.6,
    letterSpacing: 0,
  );
  
  // Label Styles - Untuk buttons dan small labels
  static TextStyle get labelLarge => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 14,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
  );
  
  static TextStyle get labelMedium => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
  );
  
  static TextStyle get labelSmall => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 10,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
  );
  
  // Special Styles
  static TextStyle get button => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  static TextStyle get caption => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 11,
    fontWeight: regular,
    height: 1.4,
    letterSpacing: 0,
  );
  
  static TextStyle get overline => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 10,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 1.5,
  );
  
  // Custom Styles untuk aplikasi Ramein
  static TextStyle get eventTitle => GoogleFonts.getFont(
    _displayFontFamily,
    fontSize: 18,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: 0,
  );
  
  static TextStyle get eventDate => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
  );
  
  static TextStyle get eventLocation => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 11,
    fontWeight: regular,
    height: 1.4,
    letterSpacing: 0,
  );
  
  static TextStyle get price => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 16,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 0,
  );
  
  static TextStyle get token => GoogleFonts.getFont(
    'JetBrains Mono',
    fontSize: 16,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 2,
  );
  
  static TextStyle get certificateTitle => GoogleFonts.getFont(
    _displayFontFamily,
    fontSize: 20,
    fontWeight: bold,
    height: 1.3,
    letterSpacing: 0,
  );
  
  static TextStyle get certificateSubtitle => GoogleFonts.getFont(
    _primaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.4,
    letterSpacing: 0,
  );
}
