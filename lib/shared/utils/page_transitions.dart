import 'package:flutter/material.dart';

/// Custom Page Transitions untuk Ramein App
/// Memberikan smooth dan engaging transitions antar halaman

class RameinPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final TransitionType transitionType;

  RameinPageRoute({
    required this.page,
    this.transitionType = TransitionType.slideUp,
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              child,
              animation,
              secondaryAnimation,
              transitionType,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          settings: settings,
        );

  static Widget _buildTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    TransitionType type,
  ) {
    switch (type) {
      case TransitionType.slideUp:
        return _slideUpTransition(child, animation, secondaryAnimation);
      case TransitionType.slideRight:
        return _slideRightTransition(child, animation, secondaryAnimation);
      case TransitionType.fade:
        return _fadeTransition(child, animation, secondaryAnimation);
      case TransitionType.scale:
        return _scaleTransition(child, animation, secondaryAnimation);
      case TransitionType.fadeScale:
        return _fadeScaleTransition(child, animation, secondaryAnimation);
    }
  }

  static Widget _slideUpTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    final tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    final offsetAnimation = animation.drive(tween);
    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }

  static Widget _slideRightTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    const begin = Offset(-1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    final tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  static Widget _fadeTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }

  static Widget _scaleTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    const curve = Curves.easeOutCubic;

    final scaleTween = Tween(begin: 0.9, end: 1.0).chain(
      CurveTween(curve: curve),
    );

    return ScaleTransition(
      scale: animation.drive(scaleTween),
      child: child,
    );
  }

  static Widget _fadeScaleTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    const curve = Curves.easeOutCubic;

    final scaleTween = Tween(begin: 0.92, end: 1.0).chain(
      CurveTween(curve: curve),
    );

    final fadeTween = CurveTween(curve: curve);

    return FadeTransition(
      opacity: animation.drive(fadeTween),
      child: ScaleTransition(
        scale: animation.drive(scaleTween),
        child: child,
      ),
    );
  }
}

enum TransitionType {
  slideUp,
  slideRight,
  fade,
  scale,
  fadeScale,
}

/// Helper extension untuk easy navigation dengan custom transitions
extension NavigationExtension on BuildContext {
  Future<T?> pushWithTransition<T>(
    Widget page, {
    TransitionType transition = TransitionType.slideUp,
  }) {
    return Navigator.of(this).push<T>(
      RameinPageRoute(
        page: page,
        transitionType: transition,
      ),
    );
  }

  Future<T?> pushReplacementWithTransition<T, TO>(
    Widget page, {
    TransitionType transition = TransitionType.slideUp,
  }) {
    return Navigator.of(this).pushReplacement<T, TO>(
      RameinPageRoute(
        page: page,
        transitionType: transition,
      ),
    );
  }
}
