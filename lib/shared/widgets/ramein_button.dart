import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Ramein Custom Button Widget - Modernized with Gradients
class RameinButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final RameinButtonVariant variant;
  final RameinButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? child;
  final Color? textColor;
  final double? borderRadius;
  final LinearGradient? gradient;
  final bool enableAnimation;

  const RameinButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = RameinButtonVariant.primary,
    this.size = RameinButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.child,
    this.textColor,
    this.borderRadius,
    this.gradient,
    this.enableAnimation = true,
  });

  @override
  State<RameinButton> createState() => _RameinButtonState();
}

class _RameinButtonState extends State<RameinButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    if (widget.enableAnimation) {
      _animationController.forward();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (widget.enableAnimation) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = _getButtonSize();
    final buttonConfig = _getButtonConfig();
    
    Widget buttonChild = widget.isLoading
        ? SizedBox(
            width: buttonSize.iconSize,
            height: buttonSize.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                buttonConfig.textColor,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: buttonSize.iconSize,
                  color: buttonConfig.textColor,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (widget.child != null)
                widget.child!
              else
                Text(
                  widget.text,
                  style: AppTypography.buttonText.copyWith(
                    color: buttonConfig.textColor,
                    fontSize: buttonSize.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          );

    final gradient = widget.gradient ?? buttonConfig.gradient;
    final shadowColor = buttonConfig.shadowColor;

    Widget button = Listener(
      onPointerDown: widget.enableAnimation ? _onPointerDown : null,
      onPointerUp: widget.enableAnimation ? _onPointerUp : null,
      child: ScaleTransition(
        scale: widget.enableAnimation ? _scaleAnimation : AlwaysStoppedAnimation(1.0),
        child: SizedBox(
          width: widget.isFullWidth ? double.infinity : null,
          height: buttonSize.height,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? buttonSize.borderRadius,
              ),
              gradient: gradient,
              border: buttonConfig.border,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: shadowColor.withValues(alpha: 0.05),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : widget.onPressed,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? buttonSize.borderRadius,
                ),
                splashColor: Colors.white.withValues(alpha: 0.1),
                highlightColor: Colors.transparent,
                child: Center(child: buttonChild),
              ),
            ),
          ),
        ),
      ),
    );

    return button;
  }

  _ButtonConfig _getButtonConfig() {
    switch (widget.variant) {
      case RameinButtonVariant.primary:
        return _ButtonConfig(
          gradient: AppColors.purpleCTAGradient,
          textColor: widget.textColor ?? Colors.white,
          shadowColor: AppColors.accent.withValues(alpha: 0.3),
          border: null,
        );
      case RameinButtonVariant.secondary:
        return _ButtonConfig(
          gradient: AppColors.primaryGradient,
          textColor: widget.textColor ?? Colors.white,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          border: null,
        );
      case RameinButtonVariant.outline:
        return _ButtonConfig(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.transparent, Colors.transparent],
          ),
          textColor: widget.textColor ?? AppColors.primary,
          shadowColor: AppColors.borderLight.withValues(alpha: 0.2),
          border: Border.all(color: AppColors.primary, width: 2),
        );
      case RameinButtonVariant.ghost:
        return _ButtonConfig(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.transparent, Colors.transparent],
          ),
          textColor: widget.textColor ?? AppColors.primary,
          shadowColor: Colors.transparent,
          border: null,
        );
      case RameinButtonVariant.success:
        return _ButtonConfig(
          gradient: AppColors.successGradient,
          textColor: widget.textColor ?? Colors.white,
          shadowColor: AppColors.success.withValues(alpha: 0.3),
          border: null,
        );
      case RameinButtonVariant.error:
        return _ButtonConfig(
          gradient: AppColors.errorGradient,
          textColor: widget.textColor ?? Colors.white,
          shadowColor: AppColors.error.withValues(alpha: 0.3),
          border: null,
        );
      case RameinButtonVariant.warning:
        return _ButtonConfig(
          gradient: AppColors.warningGradient,
          textColor: widget.textColor ?? Colors.white,
          shadowColor: AppColors.warning.withValues(alpha: 0.3),
          border: null,
        );
    }
  }

  _ButtonSize _getButtonSize() {
    switch (widget.size) {
      case RameinButtonSize.small:
        return _ButtonSize(
          height: AppSpacing.buttonHeightSm,
          fontSize: 12,
          iconSize: AppSpacing.iconSm,
          borderRadius: AppSpacing.radiusSm,
        );
      case RameinButtonSize.medium:
        return _ButtonSize(
          height: AppSpacing.buttonHeightMd,
          fontSize: 14,
          iconSize: AppSpacing.iconMd,
          borderRadius: AppSpacing.buttonRadius,
        );
      case RameinButtonSize.large:
        return _ButtonSize(
          height: AppSpacing.buttonHeightLg,
          fontSize: 16,
          iconSize: AppSpacing.iconLg,
          borderRadius: AppSpacing.radiusLg,
        );
      case RameinButtonSize.extraLarge:
        return _ButtonSize(
          height: AppSpacing.buttonHeightXl,
          fontSize: 18,
          iconSize: AppSpacing.iconXl,
          borderRadius: AppSpacing.radiusXl,
        );
    }
  }
}

enum RameinButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  success,
  error,
  warning,
}

enum RameinButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

class _ButtonConfig {
  final LinearGradient gradient;
  final Color textColor;
  final Color shadowColor;
  final Border? border;

  _ButtonConfig({
    required this.gradient,
    required this.textColor,
    required this.shadowColor,
    this.border,
  });
}

class _ButtonSize {
  final double height;
  final double fontSize;
  final double iconSize;
  final double borderRadius;

  _ButtonSize({
    required this.height,
    required this.fontSize,
    required this.iconSize,
    required this.borderRadius,
  });
}
