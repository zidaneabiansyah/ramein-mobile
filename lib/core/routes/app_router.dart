import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import screens
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/verify_email_screen.dart';
import '../../features/events/screens/home_screen.dart';
import '../../features/events/screens/event_detail_screen.dart';
import '../../features/events/screens/attendance_screen.dart';
import '../../features/events/screens/my_events_screen.dart';
import '../../features/certificates/screens/certificates_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/debug/debug_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';

/// App Router Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        pageBuilder: (context, state) {
          final email = state.extra as Map<String, dynamic>?;
          return MaterialPage(
            key: state.pageKey,
            child: VerifyEmailScreen(
              email: email?['email'] ?? '',
            ),
          );
        },
      ),

      // Main App Routes
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/event/:id',
        name: 'event-detail',
        pageBuilder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: EventDetailScreen(eventId: eventId),
          );
        },
      ),
      GoRoute(
        path: '/attendance/:eventId/:eventTitle/:token',
        name: 'attendance',
        pageBuilder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          final eventTitle = state.pathParameters['eventTitle'] ?? '';
          final token = state.pathParameters['token'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: AttendanceScreen(
              eventId: eventId,
              eventTitle: eventTitle,
              token: token,
            ),
          );
        },
      ),
      GoRoute(
        path: '/my-events',
        name: 'my-events',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MyEventsScreen(),
        ),
      ),
      GoRoute(
        path: '/certificates',
        name: 'certificates',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const CertificatesScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/debug',
        name: 'debug',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DebugScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),

      // Redirect root to login
      GoRoute(
        path: '/',
        redirect: (context, state) => '/login',
      ),
    ],
    
    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Halaman tidak ditemukan',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Path: ${state.uri.toString()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    ),
    
    // Redirect logic (for authentication)
    redirect: (context, state) {
      // TODO: Implement authentication state checking
      // For now, allow all routes
      return null;
    },
  );
});

/// Custom page transitions
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Offset begin;
  final Offset end;

  SlidePageRoute({
    required this.child,
    this.begin = const Offset(1.0, 0.0),
    this.end = Offset.zero,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

/// Fade page transitions
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadePageRoute({
    required this.child,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
