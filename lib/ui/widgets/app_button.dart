import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

enum _AppButtonVariant { primary, secondary, text }

class AppButton extends StatelessWidget {
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.disabledReason,
  }) : _variant = _AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.disabledReason,
  }) : _variant = _AppButtonVariant.secondary;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.disabledReason,
  }) : _variant = _AppButtonVariant.text;

  static const double _iconSize = 24;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? disabledReason;
  final _AppButtonVariant _variant;

  bool get _isFullWidth => _variant != _AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final button = _buildButton();
    final reason = disabledReason;
    if (onPressed != null || reason == null) {
      return button;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _isFullWidth
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      children: [
        button,
        const SizedBox(height: AppSpacing.space2),
        Text(
          reason,
          style: AppTextStyles.meta.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildButton() {
    final style = _styles[_variant]!;
    final child = _buildChild();
    return switch (_variant) {
      _AppButtonVariant.primary => FilledButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      _AppButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      _AppButtonVariant.text => TextButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    };
  }

  Widget _buildChild() {
    final text = Text(label, textAlign: TextAlign.center);
    final leading = icon;
    if (leading == null) {
      return text;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(leading, size: _iconSize),
        const SizedBox(width: AppSpacing.space2),
        Flexible(child: text),
      ],
    );
  }

  static final Map<_AppButtonVariant, ButtonStyle> _styles = {
    for (final variant in _AppButtonVariant.values) variant: _styleFor(variant),
  };

  static ButtonStyle _styleFor(_AppButtonVariant variant) {
    final idle = _idleColors(variant);
    final isFullWidth = variant != _AppButtonVariant.text;
    final foreground = WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? AppColors.textSecondary
          : idle.foreground,
    );
    return ButtonStyle(
      textStyle: const WidgetStatePropertyAll(AppTextStyles.label),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.disabledBg;
        }
        if (variant == _AppButtonVariant.primary &&
            states.contains(WidgetState.pressed)) {
          return AppColors.primaryPressed;
        }
        return idle.background;
      }),
      foregroundColor: foreground,
      iconColor: foreground,
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return const BorderSide(color: AppColors.disabledBg);
        }
        if (states.contains(WidgetState.focused)) {
          return const BorderSide(color: AppColors.focus, width: 2);
        }
        return idle.side;
      }),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: isFullWidth ? AppSpacing.space4 : AppSpacing.space2,
          vertical: AppSpacing.space2,
        ),
      ),
      minimumSize: WidgetStatePropertyAll(
        isFullWidth
            ? const Size.fromHeight(AppSizes.buttonHeight)
            : const Size(AppSizes.touchMin, AppSizes.touchMin),
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      elevation: const WidgetStatePropertyAll(0),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadii.md)),
        ),
      ),
    );
  }

  static ({Color background, Color foreground, BorderSide side}) _idleColors(
    _AppButtonVariant variant,
  ) {
    return switch (variant) {
      _AppButtonVariant.primary => (
        background: AppColors.primary,
        foreground: AppColors.onPrimary,
        side: BorderSide.none,
      ),
      _AppButtonVariant.secondary => (
        background: AppColors.surface,
        foreground: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
      ),
      _AppButtonVariant.text => (
        background: Colors.transparent,
        foreground: AppColors.primary,
        side: BorderSide.none,
      ),
    };
  }
}
