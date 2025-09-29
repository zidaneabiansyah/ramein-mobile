import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/onboarding_provider.dart';
import '../auth/screens/login_screen.dart';
import '../navigation/main_navigation.dart';
import '../onboarding/onboarding_screen.dart';

/// Splash Screen dengan animasi typing "Ramein" seperti Netflix
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  String _displayText = '';
  final String _fullText = 'Ramein';
  int _currentIndex = 0;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startTypingAnimation();
  }

  void _setupAnimations() {
    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
  }

  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_currentIndex < _fullText.length) {
        setState(() {
          _displayText = _fullText.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        timer.cancel();
        // Tunggu sebentar lalu animasi scale dan navigasi
        Future.delayed(const Duration(milliseconds: 800), () {
          _scaleController.forward().then((_) {
            // Navigasi berdasarkan app state
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                _navigateBasedOnAppState();
              }
            });
          });
        });
      }
    });
  }

  void _navigateBasedOnAppState() {
    final appState = ref.read(appProvider);
    final authState = ref.read(authProvider);
    final onboardingState = ref.read(onboardingProvider);
    
    if (!appState.isInitialized || onboardingState.isLoading) {
      // App belum terinisialisasi atau onboarding masih loading, tunggu
      return;
    }
    
    // Cek onboarding dulu
    if (!onboardingState.isCompleted) {
      // User belum menyelesaikan onboarding, ke onboarding screen
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else if (authState.isAuthenticated && authState.isEmailVerified) {
      // User sudah login dan email terverifikasi, ke main navigation
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MainNavigation(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else {
      // User belum login atau email belum terverifikasi, ke login
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to app initialization state
    ref.listen<AppState>(appProvider, (previous, next) {
      if (next.isInitialized && _currentIndex >= _fullText.length) {
        _navigateBasedOnAppState();
      }
    });

    // Listen to onboarding state changes
    ref.listen<OnboardingState>(onboardingProvider, (previous, next) {
      if (!next.isLoading && _currentIndex >= _fullText.length) {
        _navigateBasedOnAppState();
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Modern 3D-style logo placeholder
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFE0E7FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.event,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.xl * 2),
                    
                    // Animated Text - Only "Ramein"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _displayText,
                          style: AppTypography.displayLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 48,
                            letterSpacing: 2,
                            height: 1.1,
                          ),
                        ),
                        // Blinking cursor
                        if (_currentIndex <= _fullText.length)
                          AnimatedOpacity(
                            opacity: _currentIndex < _fullText.length ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              width: 3,
                              height: 48,
                              margin: const EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Subtitle with modern styling
                    Text(
                      'Event Management Platform',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        letterSpacing: 1.2,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.enormous * 2),
                    
                    // Modern loading indicator
                    Container(
                      width: 200,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: 200 * (_currentIndex / _fullText.length),
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.accent, AppColors.accentLight],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
