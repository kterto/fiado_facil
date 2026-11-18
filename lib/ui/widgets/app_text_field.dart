import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'field_error.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.labelSuffix,
    this.controller,
    this.hintText,
    this.leadingIcon,
    this.maxLength,
    this.errorText,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
  });

  static final TextInputFormatter _denyAngleBrackets =
      FilteringTextInputFormatter.deny(RegExp('[<>]'));

  final String label;
  final String? labelSuffix;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? leadingIcon;
  final int? maxLength;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final inputStyle = AppTextStyles.body.copyWith(
      color: AppColors.textPrimary,
    );
    return AppFieldLayout(
      label: label,
      labelSuffix: labelSuffix,
      errorText: errorText,
      input: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        inputFormatters: <TextInputFormatter>[
          _denyAngleBrackets,
          ...?inputFormatters,
        ],
        onChanged: onChanged,
        maxLength: maxLength,
        textAlignVertical: TextAlignVertical.center,
        style: inputStyle,
        decoration: _decoration(inputStyle),
      ),
    );
  }

  InputDecoration _decoration(TextStyle inputStyle) {
    final icon = leadingIcon;
    return appFieldDecoration(
      hasError: errorText != null,
      inputStyle: inputStyle,
      hintText: hintText,
      prefix: icon == null ? null : Icon(icon, color: AppColors.border),
    ).copyWith(
      constraints: const BoxConstraints(minHeight: AppSizes.fieldHeight),
    );
  }
}

class AppFieldLayout extends StatelessWidget {
  const AppFieldLayout({
    super.key,
    required this.label,
    required this.input,
    this.labelSuffix,
    this.errorText,
  });

  final String label;
  final String? labelSuffix;
  final String? errorText;
  final Widget input;

  @override
  Widget build(BuildContext context) {
    final error = errorText;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MergeSemantics(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLabel(),
              const SizedBox(height: AppSpacing.space2),
              input,
            ],
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.space2),
          FieldError(error),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    final suffix = labelSuffix;
    return Text.rich(
      TextSpan(
        text: label,
        children: [
          if (suffix != null)
            TextSpan(
              text: ' $suffix',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
      style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
    );
  }
}

InputDecoration appFieldDecoration({
  required bool hasError,
  required TextStyle inputStyle,
  String? hintText,
  Widget? prefix,
}) {
  final sides = _borderSides(hasError: hasError);
  return InputDecoration(
    hintText: hintText,
    hintStyle: inputStyle.copyWith(color: AppColors.textSecondary),
    prefixIcon: prefix == null ? null : _paddedPrefix(prefix),
    prefixIconConstraints: const BoxConstraints(),
    filled: true,
    fillColor: AppColors.surface,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.space3,
      vertical: AppSpacing.space3,
    ),
    counterStyle: AppTextStyles.meta.copyWith(color: AppColors.textSecondary),
    enabledBorder: _outline(sides.idle),
    focusedBorder: _outline(sides.focused),
    disabledBorder: _outline(sides.idle),
  );
}

({BorderSide idle, BorderSide focused}) _borderSides({required bool hasError}) {
  const errorSide = BorderSide(color: AppColors.error, width: 2);
  if (hasError) {
    return (idle: errorSide, focused: errorSide);
  }
  return (
    idle: const BorderSide(color: AppColors.border),
    focused: const BorderSide(color: AppColors.primary, width: 2),
  );
}

Widget _paddedPrefix(Widget prefix) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(
      start: AppSpacing.space3,
      end: AppSpacing.space1,
    ),
    child: prefix,
  );
}

OutlineInputBorder _outline(BorderSide side) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm)),
    borderSide: side,
    gapPadding: 0,
  );
}
