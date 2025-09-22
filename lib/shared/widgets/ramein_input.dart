import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Ramein Custom Input Widget
/// Modern, minimalis, dan unik dengan berbagai variant
class RameinInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final RameinInputVariant variant;
  final RameinInputSize size;
  final bool isRequired;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final String? counterText;

  const RameinInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.variant = RameinInputVariant.outlined,
    this.size = RameinInputSize.medium,
    this.isRequired = false,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.counterText,
  });

  @override
  State<RameinInput> createState() => _RameinInputState();
}

class _RameinInputState extends State<RameinInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputSize = _getInputSize();
    final inputStyle = _getInputStyle();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTypography.labelLarge.copyWith(
                  color: _isFocused ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.isRequired) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '*',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          style: AppTypography.bodyMedium.copyWith(
            color: widget.enabled ? AppColors.textPrimary : AppColors.textDisabled,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            counterText: widget.counterText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            filled: inputStyle.filled,
            fillColor: widget.backgroundColor ?? inputStyle.backgroundColor,
            border: _buildBorder(inputStyle.borderColor),
            enabledBorder: _buildBorder(inputStyle.borderColor),
            focusedBorder: _buildBorder(
              widget.focusedBorderColor ?? AppColors.primary,
              width: 2,
            ),
            errorBorder: _buildBorder(
              widget.errorBorderColor ?? AppColors.error,
            ),
            focusedErrorBorder: _buildBorder(
              widget.errorBorderColor ?? AppColors.error,
              width: 2,
            ),
            disabledBorder: _buildBorder(AppColors.borderLight),
            contentPadding: widget.contentPadding ?? inputSize.padding,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            helperStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            errorStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.error,
            ),
            counterStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
          size: AppSpacing.iconMd,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }

  InputBorder _buildBorder(Color color, {double width = 1.0}) {
    final borderRadius = widget.borderRadius ?? AppSpacing.inputRadius;
    
    switch (widget.variant) {
      case RameinInputVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: color, width: width),
        );
      case RameinInputVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: color, width: width),
        );
      case RameinInputVariant.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
        );
    }
  }

  _InputSize _getInputSize() {
    switch (widget.size) {
      case RameinInputSize.small:
        return _InputSize(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        );
      case RameinInputSize.medium:
        return _InputSize(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.inputPadding,
            vertical: AppSpacing.md,
          ),
        );
      case RameinInputSize.large:
        return _InputSize(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
        );
    }
  }

  _InputStyle _getInputStyle() {
    switch (widget.variant) {
      case RameinInputVariant.outlined:
        return _InputStyle(
          filled: false,
          backgroundColor: Colors.transparent,
          borderColor: widget.borderColor ?? AppColors.borderLight,
        );
      case RameinInputVariant.filled:
        return _InputStyle(
          filled: true,
          backgroundColor: AppColors.surfaceVariant,
          borderColor: widget.borderColor ?? AppColors.borderLight,
        );
      case RameinInputVariant.underlined:
        return _InputStyle(
          filled: false,
          backgroundColor: Colors.transparent,
          borderColor: widget.borderColor ?? AppColors.borderMedium,
        );
    }
  }
}

enum RameinInputVariant {
  outlined,
  filled,
  underlined,
}

enum RameinInputSize {
  small,
  medium,
  large,
}

class _InputSize {
  final EdgeInsetsGeometry padding;

  _InputSize({required this.padding});
}

class _InputStyle {
  final bool filled;
  final Color backgroundColor;
  final Color borderColor;

  _InputStyle({
    required this.filled,
    required this.backgroundColor,
    required this.borderColor,
  });
}

/// Ramein Search Input
class RameinSearchInput extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;

  const RameinSearchInput({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return RameinInput(
      hint: hint ?? 'Cari kegiatan...',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.textSecondary,
        size: AppSpacing.iconMd,
      ),
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: const Icon(
                Icons.clear,
                color: AppColors.textSecondary,
                size: AppSpacing.iconMd,
              ),
              onPressed: () {
                controller?.clear();
                onClear?.call();
              },
            )
          : null,
      variant: RameinInputVariant.filled,
      size: RameinInputSize.medium,
    );
  }
}

/// Ramein Password Input
class RameinPasswordInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final RameinInputVariant variant;
  final RameinInputSize size;
  final bool isRequired;

  const RameinPasswordInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.variant = RameinInputVariant.outlined,
    this.size = RameinInputSize.medium,
    this.isRequired = false,
  });

  @override
  State<RameinPasswordInput> createState() => _RameinPasswordInputState();
}

class _RameinPasswordInputState extends State<RameinPasswordInput> {
  @override
  Widget build(BuildContext context) {
    return RameinInput(
      label: widget.label,
      hint: widget.hint ?? 'Masukkan kata sandi',
      helperText: widget.helperText,
      errorText: widget.errorText,
      controller: widget.controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      variant: widget.variant,
      size: widget.size,
      isRequired: widget.isRequired,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(
        Icons.lock_outline,
        color: AppColors.textSecondary,
        size: AppSpacing.iconMd,
      ),
    );
  }
}
