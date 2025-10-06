/// Ramein App Spacing System
/// Konsisten dan scalable spacing untuk layout yang harmonis
class AppSpacing {
  // Base spacing unit (4px)
  static const double _baseUnit = 4.0;
  
  // Spacing Scale
  static const double xs = _baseUnit * 1; // 4px
  static const double sm = _baseUnit * 2; // 8px
  static const double md = _baseUnit * 3; // 12px
  static const double lg = _baseUnit * 4; // 16px
  static const double xl = _baseUnit * 5; // 20px
  static const double xxl = _baseUnit * 6; // 24px
  static const double xxxl = _baseUnit * 8; // 32px
  static const double huge = _baseUnit * 10; // 40px
  static const double massive = _baseUnit * 12; // 48px
  static const double enormous = _baseUnit * 16; // 64px
  
  // Component Specific Spacing
  static const double cardPadding = lg; // 16px
  static const double screenPadding = lg; // 16px
  static const double sectionSpacing = xxxl; // 32px
  static const double itemSpacing = md; // 12px
  static const double buttonPadding = lg; // 16px
  static const double inputPadding = md; // 12px
  
  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;
  static const double radiusRound = 100.0;
  
  // Component Specific Radius
  static const double cardRadius = radiusLg; // 12px
  static const double buttonRadius = radiusMd; // 8px
  static const double inputRadius = radiusSm; // 6px
  static const double chipRadius = radiusRound; // 100px
  static const double fabRadius = radiusXl; // 16px
  
  // Bottom Navigation Heights
  static const double bottomNavHeight = 60.0;
  static const double bottomNavHeightLarge = 80.0;
  
  // Tab Heights
  static const double tabHeight = 48.0;
  static const double tabHeightLarge = 56.0;
  
  // App Bar Heights
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 80.0;
  
  // Avatar Sizes
  static const double avatarXs = 24.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 48.0;
  static const double avatarXl = 56.0;
  static const double avatarXxl = 64.0;
  static const double avatarHuge = 80.0;
  static const double avatarMassive = 96.0;
  
  // Icon Sizes
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  
  // Elevation System
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 12.0;
  
  // Component Elevations
  static const double cardElevation = 4.0;
  static const double buttonElevation = 2.0;
  static const double fabElevation = 6.0;
  static const double dialogElevation = 24.0;
  static const double bottomSheetElevation = 16.0;
  
  // Button Heights
  static const double buttonHeightSm = 40.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  static const double buttonHeightXl = 64.0;
  
  // Divider Heights
  static const double dividerThin = 0.5;
  static const double dividerThick = 1.0;
  static const double dividerExtraThick = 2.0;
  
  // Animation Durations (in milliseconds)
  static const int animationFast = 150;
  static const int animationNormal = 300;
  static const int animationSlow = 500;
  static const int animationVerySlow = 800;
  
  // Animation Curves
  static const String curveEaseIn = 'easeIn';
  static const String curveEaseOut = 'easeOut';
  static const String curveEaseInOut = 'easeInOut';
  static const String curveBounce = 'bounce';
  static const String curveElastic = 'elastic';
}
