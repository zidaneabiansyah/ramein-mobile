import 'package:flutter/material.dart';

/// Ramein App Color Palette
/// Modern, minimalis, dan unik dengan identitas visual yang kuat
class AppColors {
  // Primary Brand Colors - Gradient Purple to Blue
  static const Color primary = Color(0xFF6366F1); // Indigo-500
  static const Color primaryLight = Color(0xFF818CF8); // Indigo-400
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo-600
  static const Color primaryAccent = Color(0xFF8B5CF6); // Violet-500
  
  // Secondary Colors - Modern Teal
  static const Color secondary = Color(0xFF06B6D4); // Cyan-500
  static const Color secondaryLight = Color(0xFF22D3EE); // Cyan-400
  static const Color secondaryDark = Color(0xFF0891B2); // Cyan-600
  
  // Neutral Colors - Modern Gray Scale
  static const Color background = Color(0xFFFAFAFA); // Gray-50
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF8FAFC); // Slate-50
  
  static const Color onBackground = Color(0xFF0F172A); // Slate-900
  static const Color onSurface = Color(0xFF1E293B); // Slate-800
  static const Color onSurfaceVariant = Color(0xFF475569); // Slate-600
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color textSecondary = Color(0xFF475569); // Slate-600
  static const Color textTertiary = Color(0xFF94A3B8); // Slate-400
  static const Color textDisabled = Color(0xFFCBD5E1); // Slate-300
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald-500
  static const Color successLight = Color(0xFF34D399); // Emerald-400
  static const Color successDark = Color(0xFF059669); // Emerald-600
  
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color warningLight = Color(0xFFFBBF24); // Amber-400
  static const Color warningDark = Color(0xFFD97706); // Amber-600
  
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color errorLight = Color(0xFFF87171); // Red-400
  static const Color errorDark = Color(0xFFDC2626); // Red-600
  
  static const Color info = Color(0xFF3B82F6); // Blue-500
  static const Color infoLight = Color(0xFF60A5FA); // Blue-400
  static const Color infoDark = Color(0xFF2563EB); // Blue-600
  
  // Special Colors
  static const Color accent = Color(0xFFEC4899); // Pink-500
  static const Color accentLight = Color(0xFFF472B6); // Pink-400
  static const Color accentDark = Color(0xFFDB2777); // Pink-600
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryAccent],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surfaceVariant],
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
