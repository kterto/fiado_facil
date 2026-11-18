import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

enum ConfirmDialogTone { neutral, warning }

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String dismissLabel,
  IconData? icon,
  ConfirmDialogTone tone = ConfirmDialogTone.neutral,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.scrim,
    builder: (dialogContext) => _ConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      dismissLabel: dismissLabel,
      icon: icon,
      tone: tone,
    ),
  );
  return result ?? false;
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.dismissLabel,
    required this.icon,
    required this.tone,
  });

  static const double _iconSize = 32;
  static const double _borderWidth = 2;

  final String title;
  final String message;
  final String confirmLabel;
  final String dismissLabel;
  final IconData? icon;
  final ConfirmDialogTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, accent, iconColor, titleColor) = switch (tone) {
      ConfirmDialogTone.neutral => (
        AppColors.surface,
        AppColors.border,
        AppColors.primary,
        AppColors.textPrimary,
      ),
      ConfirmDialogTone.warning => (
        AppColors.warningContainer,
        AppColors.onWarning,
        AppColors.onWarning,
        AppColors.onWarning,
      ),
    };
    final headIcon = icon;
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: title,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: accent, width: _borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(AppRadii.lg)),
            boxShadow: const <BoxShadow>[AppShadows.dialog],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space5,
              AppSpacing.space6,
              AppSpacing.space5,
              AppSpacing.space5,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (headIcon != null) ...[
                      Icon(headIcon, size: _iconSize, color: iconColor),
                      const SizedBox(width: AppSpacing.space2),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.title.copyWith(color: titleColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space3),
                Text(
                  message,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.space5),
                AppButton.primary(
                  label: confirmLabel,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                const SizedBox(height: AppSpacing.space2),
                AppButton.secondary(
                  label: dismissLabel,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
