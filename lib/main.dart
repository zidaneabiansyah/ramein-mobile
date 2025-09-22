import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/verify_email_screen.dart';
import 'features/events/screens/home_screen.dart';
import 'features/events/screens/event_detail_screen.dart';
import 'features/events/screens/attendance_screen.dart';
import 'features/events/screens/my_events_screen.dart';
import 'features/certificates/screens/certificates_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const RameinApp());
}

class RameinApp extends StatelessWidget {
  const RameinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramein - Event Management',
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      // Home route - Splash screen
      home: const SplashScreen(),
      
      // Routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/my-events': (context) => const MyEventsScreen(),
        '/certificates': (context) => const CertificatesScreen(),
      },
      
      // Route generator untuk routes dengan parameter
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/verify-email':
            final args = settings.arguments as Map<String, dynamic>?;
            final email = args?['email'] ?? '';
            return MaterialPageRoute(
              builder: (context) => VerifyEmailScreen(email: email),
            );
          case '/event-detail':
            final args = settings.arguments as Map<String, dynamic>?;
            final eventId = args?['eventId'] ?? '';
            return MaterialPageRoute(
              builder: (context) => EventDetailScreen(eventId: eventId),
            );
          case '/attendance':
            return MaterialPageRoute(
              builder: (context) => const AttendanceScreen(),
            );
          default:
            return null;
        }
      },
      
      // Localization
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Builder for additional configurations
      builder: (context, child) {
        return MediaQuery(
          // Use TextScaler instead of deprecated textScaleFactor
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}