import 'package:flutter/material.dart';

/// Ramein App Color Palette - Event-Focused Bold Design
/// Deep Teal + Bold Purple + Warm Accents
class AppColors {
  // Primary Brand Colors - NEW: Deep Teal (Event-focused)
  static const Color primary = Color(0xFF1B6B7F); // Deep Teal from design reference
  static const Color primaryLight = Color(0xFF2A8FA8); // Lighter teal
  static const Color primaryDark = Color(0xFF0F4A56); // Darker teal
  static const Color primaryAccent = Color(0xFF6C3FBF); // Bold Purple accent
  
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
  
  // Status Colors - Vibrant & Bold for events
  static const Color success = Color(0xFF00D084); // Vibrant green - for "Going" status
  static const Color successLight = Color(0xFF34E9A4); // Lighter vibrant green
  static const Color successDark = Color(0xFF00A566); // Darker vibrant green
  
  static const Color warning = Color(0xFFFF9500); // Bold Orange - for limited spots
  static const Color warningLight = Color(0xFFFFB84D); // Lighter orange
  static const Color warningDark = Color(0xFFE67E00); // Darker orange
  
  static const Color error = Color(0xFFFF4757); // Bold Red - for sold out
  static const Color errorLight = Color(0xFFFF6B7A); // Lighter red
  static const Color errorDark = Color(0xFFE63C4B); // Darker red
  
  static const Color info = Color(0xFF6C3FBF); // Bold Purple - new secondary CTA
  static const Color infoLight = Color(0xFF8B5FD4); // Lighter purple
  static const Color infoDark = Color(0xFF4D2699); // Darker purple
  
  // Special Colors - NEW: Bold Purple accent for CTAs
  static const Color accent = Color(0xFF6C3FBF); // Bold Purple - main CTA color
  static const Color accentLight = Color(0xFF8B5FD4); // Lighter purple
  static const Color accentDark = Color(0xFF4D2699); // Darker purple
  
  // Gradient Colors - NEW: Event-focused bold gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B6B7F), // Deep Teal
      Color(0xFF0F4A56), // Darker Teal
    ],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFFFFFFF),
    ],
  );

  // NEW: Purple gradient for CTAs & buttons
  static const LinearGradient purpleCTAGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6C3FBF), // Bold Purple
      Color(0xFF4D2699), // Darker Purple
    ],
  );

  // NEW: Teal-Purple gradient for premium sections
  static const LinearGradient tealPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B6B7F), // Teal
      Color(0xFF6C3FBF), // Purple
    ],
  );

  // NEW: Warm gradient for highlight sections
  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF9500), // Bold Orange
      Color(0xFFFF6B7A), // Bold Red
    ],
  );

  // Card Gradient - subtle
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFF5F5F5),
    ],
  );

  // Signature Gradients - Event badges
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6C3FBF), // Purple
      Color(0xFF8B5FD4), // Lighter Purple
    ],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00D084), // Vibrant Green
      Color(0xFF34E9A4), // Lighter Green
    ],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF9500), // Bold Orange
      Color(0xFFFFB84D), // Lighter Orange
    ],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF4757), // Bold Red
      Color(0xFFFF6B7A), // Lighter Red
    ],
  );

  // Extended gradients for premium effects
  static const LinearGradient cyanTealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B6B7F), // Teal (matches primary now)
      Color(0xFF2A8FA8), // Lighter Teal
    ],
  );

  static const LinearGradient purplePinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6C3FBF), // Purple
      Color(0xFFE91E63), // Pink
    ],
  );

  static const LinearGradient orangeRedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF9500), // Orange
      Color(0xFFFF4757), // Red
    ],
  );

  // Mesh Gradient untuk background
  static const LinearGradient meshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFF0F4F8),
      Color(0xFFFAFAFA),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Premium gradient - now teal-based
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B6B7F),
      Color(0xFF6C3FBF),
      Color(0xFF0F4A56),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Splash gradient - teal-purple combination
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1B6B7F), // Deep Teal
      Color(0xFF0F4A56), // Darker Teal
      Color(0xFF082630), // Even darker teal
    ],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF717182), // Gray
      Color(0xFF9CA3AF), // Lighter gray
    ],
  );

  // NEW: Primary Extended Gradient for headers
  static const LinearGradient primaryExtendedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B6B7F),
      Color(0xFF0F4A56),
      Color(0xFF082630),
    ],
    stops: [0.0, 0.5, 1.0],
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
