import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Pattern Background Widget
/// Memberikan signature visual identity dengan pattern unik
class PatternBackground extends StatelessWidget {
  final Widget child;
  final PatternType pattern;
  final Color? color;
  final double opacity;

  const PatternBackground({
    super.key,
    required this.child,
    this.pattern = PatternType.dots,
    this.color,
    this.opacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Pattern layer
        Positioned.fill(
          child: CustomPaint(
            painter: _PatternPainter(
              pattern: pattern,
              color: (color ?? AppColors.primary).withValues(alpha: opacity),
            ),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}

enum PatternType {
  dots,
  grid,
  waves,
  diagonal,
}

class _PatternPainter extends CustomPainter {
  final PatternType pattern;
  final Color color;

  _PatternPainter({
    required this.pattern,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (pattern) {
      case PatternType.dots:
        _paintDots(canvas, size, paint);
        break;
      case PatternType.grid:
        _paintGrid(canvas, size, paint);
        break;
      case PatternType.waves:
        _paintWaves(canvas, size, paint);
        break;
      case PatternType.diagonal:
        _paintDiagonal(canvas, size, paint);
        break;
    }
  }

  void _paintDots(Canvas canvas, Size size, Paint paint) {
    const spacing = 30.0;
    const dotRadius = 2.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  void _paintGrid(Canvas canvas, Size size, Paint paint) {
    const spacing = 30.0;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  void _paintWaves(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    const waveHeight = 20.0;
    const waveLength = 60.0;
    const spacing = 40.0;

    for (double y = 0; y < size.height; y += spacing) {
      path.reset();
      path.moveTo(0, y);

      for (double x = 0; x <= size.width; x += waveLength) {
        path.quadraticBezierTo(
          x + waveLength / 4,
          y - waveHeight,
          x + waveLength / 2,
          y,
        );
        path.quadraticBezierTo(
          x + 3 * waveLength / 4,
          y + waveHeight,
          x + waveLength,
          y,
        );
      }

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.5;
      canvas.drawPath(path, paint);
    }
  }

  void _paintDiagonal(Canvas canvas, Size size, Paint paint) {
    const spacing = 20.0;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    // Diagonal lines from top-left to bottom-right
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_PatternPainter oldDelegate) {
    return oldDelegate.pattern != pattern || oldDelegate.color != color;
  }
}

/// Animated Blob Shape Widget
/// Decorative blob untuk visual interest
class BlobShape extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const BlobShape({
    super.key,
    this.size = 200,
    required this.color,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _BlobPainter(
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  final Color color;

  _BlobPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // Create organic blob shape using bezier curves
    path.moveTo(centerX + radius, centerY);

    // Top right
    path.cubicTo(
      centerX + radius,
      centerY - radius * 0.8,
      centerX + radius * 0.6,
      centerY - radius * 1.2,
      centerX,
      centerY - radius,
    );

    // Top left
    path.cubicTo(
      centerX - radius * 0.6,
      centerY - radius * 1.2,
      centerX - radius,
      centerY - radius * 0.8,
      centerX - radius,
      centerY,
    );

    // Bottom left
    path.cubicTo(
      centerX - radius,
      centerY + radius * 0.8,
      centerX - radius * 0.6,
      centerY + radius * 1.2,
      centerX,
      centerY + radius,
    );

    // Bottom right
    path.cubicTo(
      centerX + radius * 0.6,
      centerY + radius * 1.2,
      centerX + radius,
      centerY + radius * 0.8,
      centerX + radius,
      centerY,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BlobPainter oldDelegate) => false;
}
