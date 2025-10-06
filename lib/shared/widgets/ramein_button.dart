import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Ramein Custom Button Widget
/// Modern, minimalis, dan unik dengan berbagai variant
class RameinButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final RameinButtonVariant variant;
  final RameinButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? child;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

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
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.elevation,
  });

  @override
  State<RameinButton> createState() => _RameinButtonState();
}

class _RameinButtonState extends State<RameinButton> {

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final buttonSize = _getButtonSize();
    
    Widget buttonChild = widget.isLoading
        ? SizedBox(
            width: buttonSize.iconSize,
            height: buttonSize.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.variant == RameinButtonVariant.primary ? Colors.white : AppColors.primary,
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
                  color: buttonStyle.textColor,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (widget.child != null)
                widget.child!
              else
                Text(
                  widget.text,
                  style: AppTypography.buttonText.copyWith(
                    color: buttonStyle.textColor,
                    fontSize: buttonSize.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          );

    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      height: buttonSize.height,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonStyle.backgroundColor,
          foregroundColor: buttonStyle.textColor,
          elevation: widget.elevation ?? buttonStyle.elevation,
          shadowColor: AppColors.shadowLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? buttonSize.borderRadius,
            ),
            side: buttonStyle.borderSide,
          ),
          padding: widget.padding ?? buttonSize.padding,
        ),
        child: buttonChild,
      ),
    );
  }

  _ButtonStyle _getButtonStyle() {
    switch (widget.variant) {
      case RameinButtonVariant.primary:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.primary,
          textColor: widget.textColor ?? Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.secondary:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.secondary,
          textColor: widget.textColor ?? Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.outline:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          textColor: widget.textColor ?? AppColors.primary,
          elevation: 0,
          borderSide: BorderSide(
            color: widget.backgroundColor ?? AppColors.primary,
            width: 1.5,
          ),
        );
      case RameinButtonVariant.ghost:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          textColor: widget.textColor ?? AppColors.primary,
          elevation: 0,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.success:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.success,
          textColor: widget.textColor ?? Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.error:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.error,
          textColor: widget.textColor ?? Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.warning:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppColors.warning,
          textColor: widget.textColor ?? Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        );
      case RameinButtonSize.medium:
        return _ButtonSize(
          height: AppSpacing.buttonHeightMd,
          fontSize: 14,
          iconSize: AppSpacing.iconMd,
          borderRadius: AppSpacing.buttonRadius,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPadding,
            vertical: AppSpacing.md,
          ),
        );
      case RameinButtonSize.large:
        return _ButtonSize(
          height: AppSpacing.buttonHeightLg,
          fontSize: 16,
          iconSize: AppSpacing.iconLg,
          borderRadius: AppSpacing.radiusLg,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
        );
      case RameinButtonSize.extraLarge:
        return _ButtonSize(
          height: AppSpacing.buttonHeightXl,
          fontSize: 18,
          iconSize: AppSpacing.iconXl,
          borderRadius: AppSpacing.radiusXl,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
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

class _ButtonStyle {
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final BorderSide borderSide;

  _ButtonStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.elevation,
    required this.borderSide,
  });
}

class _ButtonSize {
  final double height;
  final double fontSize;
  final double iconSize;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  _ButtonSize({
    required this.height,
    required this.fontSize,
    required this.iconSize,
    required this.borderRadius,
    required this.padding,
  });
}

/// Ramein Icon Button
class RameinIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final RameinButtonVariant variant;
  final RameinButtonSize size;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final String? tooltip;

  const RameinIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = RameinButtonVariant.primary,
    this.size = RameinButtonSize.medium,
    this.isLoading = false,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final buttonSize = _getButtonSize();
    
    Widget buttonChild = isLoading
        ? SizedBox(
            width: buttonSize.iconSize,
            height: buttonSize.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(buttonStyle.textColor),
            ),
          )
        : Icon(
            icon,
            size: buttonSize.iconSize,
            color: iconColor ?? buttonStyle.textColor,
          );

    Widget button = SizedBox(
      width: buttonSize.height,
      height: buttonSize.height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? buttonStyle.backgroundColor,
          foregroundColor: buttonStyle.textColor,
          elevation: elevation ?? buttonStyle.elevation,
          shadowColor: AppColors.shadowLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? buttonSize.borderRadius,
            ),
            side: buttonStyle.borderSide,
          ),
          padding: padding ?? EdgeInsets.zero,
        ),
        child: buttonChild,
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }

  _ButtonStyle _getButtonStyle() {
    switch (variant) {
      case RameinButtonVariant.primary:
        return _ButtonStyle(
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.secondary:
        return _ButtonStyle(
          backgroundColor: AppColors.secondary,
          textColor: Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.outline:
        return _ButtonStyle(
          backgroundColor: Colors.transparent,
          textColor: AppColors.primary,
          elevation: 0,
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        );
      case RameinButtonVariant.ghost:
        return _ButtonStyle(
          backgroundColor: Colors.transparent,
          textColor: AppColors.primary,
          elevation: 0,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.success:
        return _ButtonStyle(
          backgroundColor: AppColors.success,
          textColor: Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.error:
        return _ButtonStyle(
          backgroundColor: AppColors.error,
          textColor: Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
        );
      case RameinButtonVariant.warning:
        return _ButtonStyle(
          backgroundColor: AppColors.warning,
          textColor: Colors.white,
          elevation: AppSpacing.buttonElevation,
          borderSide: BorderSide.none,
        );
    }
  }

  _ButtonSize _getButtonSize() {
    switch (size) {
      case RameinButtonSize.small:
        return _ButtonSize(
          height: AppSpacing.buttonHeightSm,
          fontSize: 12,
          iconSize: AppSpacing.iconSm,
          borderRadius: AppSpacing.radiusSm,
          padding: EdgeInsets.zero,
        );
      case RameinButtonSize.medium:
        return _ButtonSize(
          height: AppSpacing.buttonHeightMd,
          fontSize: 14,
          iconSize: AppSpacing.iconMd,
          borderRadius: AppSpacing.buttonRadius,
          padding: EdgeInsets.zero,
        );
      case RameinButtonSize.large:
        return _ButtonSize(
          height: AppSpacing.buttonHeightLg,
          fontSize: 16,
          iconSize: AppSpacing.iconLg,
          borderRadius: AppSpacing.radiusLg,
          padding: EdgeInsets.zero,
        );
      case RameinButtonSize.extraLarge:
        return _ButtonSize(
          height: AppSpacing.buttonHeightXl,
          fontSize: 18,
          iconSize: AppSpacing.iconXl,
          borderRadius: AppSpacing.radiusXl,
          padding: EdgeInsets.zero,
        );
    }
  }
}
