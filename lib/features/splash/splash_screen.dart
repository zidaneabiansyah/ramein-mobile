import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../auth/screens/login_screen.dart';
import '../events/screens/home_screen.dart';

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
    
    if (!appState.isInitialized) {
      // App belum terinisialisasi, tunggu
      return;
    }
    
    if (authState.isAuthenticated && authState.isEmailVerified) {
      // User sudah login dan email terverifikasi, ke home
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
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

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Text - Only "Ramein"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _displayText,
                        style: AppTypography.displayLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 64,
                          letterSpacing: 4,
                          height: 1.1,
                        ),
                      ),
                      // Blinking cursor
                      if (_currentIndex <= _fullText.length)
                        AnimatedOpacity(
                          opacity: _currentIndex < _fullText.length ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            width: 4,
                            height: 64,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00ED64), // Accent color from frontend
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Subtitle
                  Text(
                    'Event Management Platform',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                      fontSize: 16,
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.enormous * 2),
                  
                  // Loading indicator
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF00ED64), // Accent color from frontend
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
