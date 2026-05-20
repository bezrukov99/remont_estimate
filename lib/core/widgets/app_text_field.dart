import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remont_estimate/core/theme/app_palette.dart';
import 'package:remont_estimate/core/theme/app_spacing.dart';

/// iOS-style text field: label above, flat fill, no outline.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.required = false,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofocus = false,
    this.maxLength,
    this.obscureText = false,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.errorText,
    this.margin = const EdgeInsets.only(bottom: AppSpacing.md),
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final bool required;
  final IconData? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final int? maxLength;
  final bool obscureText;
  final bool readOnly;
  final TextAlign textAlign;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final String? errorText;
  final EdgeInsetsGeometry margin;

  bool get _hasError => errorText != null && errorText!.isNotEmpty;

  String? get _labelText {
    if (label == null) {
      return null;
    }
    return required ? '$label *' : label;
  }

  static const _fieldRadius = 10.0;

  InputDecoration _decoration(AppPalette palette) {
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(_fieldRadius),
      borderSide: BorderSide(color: palette.overBudget, width: 1.5),
    );

    return InputDecoration(
      hintText: hint,
      errorText: _hasError ? errorText : null,
      errorStyle: TextStyle(
        fontSize: 12,
        color: palette.overBudget,
        height: 1.2,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              size: 20,
              color: _hasError ? palette.overBudget : palette.textTertiary,
            )
          : null,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      counterText: maxLength != null ? '' : null,
      filled: true,
      fillColor: _hasError
          ? palette.overBudget.withValues(alpha: 0.06)
          : palette.surfaceMuted,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius),
        borderSide: _hasError
            ? BorderSide(color: palette.overBudget, width: 1.5)
            : BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius),
        borderSide: BorderSide(
          color: _hasError
              ? palette.overBudget
              : palette.accent.withValues(alpha: 0.45),
          width: _hasError ? 1.5 : 1,
        ),
      ),
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final labelText = _labelText;

    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null) ...[
            Text(
              labelText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color:
                        _hasError ? palette.overBudget : palette.textSecondary,
                    height: 1.2,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            readOnly: readOnly,
            obscureText: obscureText,
            maxLength: maxLength,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            textAlign: textAlign,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            onEditingComplete: onEditingComplete,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: palette.textPrimary,
              height: 1.25,
            ),
            cursorColor: palette.accent,
            decoration: _decoration(palette),
          ),
        ],
      ),
    );
  }
}

/// Compact centered field (e.g. quantity stepper).
class AppCompactTextField extends StatelessWidget {
  const AppCompactTextField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.onSubmitted,
    this.onEditingComplete,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      cursorColor: palette.accent,
      decoration: InputDecoration(
        filled: true,
        fillColor: palette.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          borderSide: BorderSide(
            color: palette.accent.withValues(alpha: 0.45),
            width: 1,
          ),
        ),
      ),
    );
  }
}
