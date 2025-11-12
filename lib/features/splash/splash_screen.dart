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

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // Try to navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_hasNavigated) {
        _tryNavigate();
      }
    });
  }

  void _tryNavigate() {
    final appState = ref.read(appProvider);
    final onboardingState = ref.read(onboardingProvider);
    
    // Check if app is initialized
    if (!appState.isInitialized) {
      // Wait for initialization
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_hasNavigated) {
          _tryNavigate();
        }
      });
      return;
    }
    
    if (onboardingState.isLoading) {
      // Wait for onboarding to load
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_hasNavigated) {
          _tryNavigate();
        }
      });
      return;
    }
    
    _navigateBasedOnAppState();
  }

  void _navigateBasedOnAppState() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    
    final authState = ref.read(authProvider);
    final onboardingState = ref.read(onboardingProvider);
    
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    // Ramein Logo - Beautiful Colorful Hands
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              width: 160,
                              height: 160,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppSpacing.xl * 2),
                    
                    // Static Text "Ramein" with fade animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: child,
                        );
                      },
                      child: Text(
                        'Ramein',
                        style: AppTypography.displayLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 48,
                          letterSpacing: 2,
                          height: 1,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.lg),
                    
                    // Subtitle
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: child,
                        );
                      },
                      child: Text(
                        'Event Management Platform',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
