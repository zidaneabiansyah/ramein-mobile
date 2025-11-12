import 'package:flutter/material.dart';

/// Ramein App Color Palette
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class AppColors {
  // Primary Brand Colors - Updated to match modern blue design
  static const Color primary = Color(0xFF1A2BFF); // Vibrant blue from image
  static const Color primaryLight = Color(0xFF3B4FFF); // Lighter blue
  static const Color primaryDark = Color(0xFF0F1BCC); // Darker blue
  static const Color primaryAccent = Color(0xFF00ED64); // Accent green
  
  // Secondary Colors - Modern Gray
  static const Color secondary = Color(0xFF717182); // Muted foreground dari frontend
  static const Color secondaryLight = Color(0xFF9CA3AF); // Lighter gray
  static const Color secondaryDark = Color(0xFF4B5563); // Darker gray
  
  // Neutral Colors - Sesuai frontend
  static const Color background = Color(0xFFFFFFFF); // White dari frontend
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF3F3F5); // Input background dari frontend
  
  static const Color onBackground = Color(0xFF030213); // Primary color dari frontend
  static const Color onSurface = Color(0xFF030213); // Primary color dari frontend
  static const Color onSurfaceVariant = Color(0xFF717182); // Muted foreground dari frontend
  
  // Text Colors - Sesuai frontend
  static const Color textPrimary = Color(0xFF030213); // Primary color dari frontend
  static const Color textSecondary = Color(0xFF717182); // Muted foreground dari frontend
  static const Color textTertiary = Color(0xFF9CA3AF); // Lighter gray
  static const Color textDisabled = Color(0xFFCBD5E1); // Slate-300
  
  // Status Colors - Soft and harmonious
  static const Color success = Color(0xFF10B981); // Emerald-500 - lebih soft
  static const Color successLight = Color(0xFF34D399); // Emerald-400
  static const Color successDark = Color(0xFF059669); // Emerald-600
  
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color warningLight = Color(0xFFFBBF24); // Amber-400
  static const Color warningDark = Color(0xFFD97706); // Amber-600
  
  static const Color error = Color(0xFFEF4444); // Red-500 - lebih soft
  static const Color errorLight = Color(0xFFF87171); // Red-400
  static const Color errorDark = Color(0xFFDC2626); // Red-600
  
  static const Color info = Color(0xFF3B82F6); // Blue-500
  static const Color infoLight = Color(0xFF60A5FA); // Blue-400
  static const Color infoDark = Color(0xFF2563EB); // Blue-600
  
  // Special Colors - Accent color yang lebih soft
  static const Color accent = Color(0xFF10B981); // Emerald-500 - tidak nabrak
  static const Color accentLight = Color(0xFF34D399); // Emerald-400
  static const Color accentDark = Color(0xFF059669); // Emerald-600
  
  // Gradient Colors - Updated for modern blue  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8F9FA),
      Color(0xFFFFFFFF),
    ],
  );

  // New: Subtle Card Gradient
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFBFF),
      Color(0xFFF8FEFF),
    ],
  );

  // New: Vibrant Primary Extended
  static const LinearGradient primaryExtendedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A2BFF),
      Color(0xFF0F1BCC),
      Color(0xFF0F1BCC),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Signature Gradients - Unique untuk Ramein
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFF059669)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF34D399)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, Color(0xFFFBBF24)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [error, Color(0xFFF87171)],
  );

  // New: Cyan to Teal
  static const LinearGradient cyanTealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF06B6D4), Color(0xFF14B8A6)],
  );

  // New: Purple to Pink
  static const LinearGradient purplePinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9B59B6), Color(0xFFEC4899)],
  );

  // New: Orange to Red
  static const LinearGradient orangeRedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9800), Color(0xFFE74C3C)],
  );

  // Mesh Gradient untuk background
  static const LinearGradient meshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF8F9FA),
      Color(0xFFE3F2FD),
      Color(0xFFF8F9FA),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Premium gradient dengan multiple colors
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      Color(0xFF6366F1),
      primaryDark,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A2BFF), // Deep blue
      Color(0xFF0F1BCC), // Darker blue
      Color(0xFF0A0F99), // Even darker blue
    ],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE2E8F0); // Slate-200
  static const Color borderMedium = Color(0xFFCBD5E1); // Slate-300
  static const Color borderDark = Color(0xFF94A3B8); // Slate-400
  
  // Overlay Colors
  static const Color overlayLight = Color(0x1A000000);
  static const Color overlayMedium = Color(0x33000000);
  static const Color overlayDark = Color(0x66000000);
  
  // Glass Effect Colors
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  
  // Dark Theme Colors (for future dark mode support)
  static const Color darkBackground = Color(0xFF0F172A); // Slate-900
  static const Color darkSurface = Color(0xFF1E293B); // Slate-800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate-700
  static const Color darkOnBackground = Color(0xFFF8FAFC); // Slate-50
  static const Color darkOnSurface = Color(0xFFE2E8F0); // Slate-200
  static const Color darkOnSurfaceVariant = Color(0xFFCBD5E1); // Slate-300
}
