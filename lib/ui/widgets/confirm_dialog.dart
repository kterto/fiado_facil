import 'package:flutter/semantics.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

enum ConfirmDialogTone { neutral, warning }

class ConfirmDialogContent {
  const ConfirmDialogContent({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.dismissLabel,
    this.icon,
    this.tone = ConfirmDialogTone.neutral,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String dismissLabel;
  final IconData? icon;
  final ConfirmDialogTone tone;
}

Future<bool> showConfirmDialog(
  BuildContext context,
  ConfirmDialogContent content,
) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.scrim,
    builder: (dialogContext) => _ConfirmDialog(content),
  );
  return result ?? false;
}

typedef _DialogPalette = ({
  Color background,
  Color accent,
  Color icon,
  Color title,
});

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog(this.content);

  static const double _iconSize = 32;
  static const double _borderWidth = 2;
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(
    AppSpacing.space5,
    AppSpacing.space6,
    AppSpacing.space5,
    AppSpacing.space5,
  );

  final ConfirmDialogContent content;

  static _DialogPalette _paletteFor(ConfirmDialogTone tone) {
    return switch (tone) {
      ConfirmDialogTone.neutral => (
        background: AppColors.surface,
        accent: AppColors.border,
        icon: AppColors.primary,
        title: AppColors.textPrimary,
      ),
      ConfirmDialogTone.warning => (
        background: AppColors.warningContainer,
        accent: AppColors.onWarning,
        icon: AppColors.onWarning,
        title: AppColors.onWarning,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(content.tone);
    return Dialog(
      semanticsRole: SemanticsRole.alertDialog,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: content.title,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: palette.background,
            border: Border.all(color: palette.accent, width: _borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(AppRadii.lg)),
            boxShadow: const <BoxShadow>[AppShadows.dialog],
          ),
          child: Padding(
            padding: _padding,
            child: _buildBody(context, palette),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, _DialogPalette palette) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(palette),
        const SizedBox(height: AppSpacing.space3),
        Text(
          content.message,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.space5),
        AppButton.primary(
          label: content.confirmLabel,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        const SizedBox(height: AppSpacing.space2),
        AppButton.secondary(
          label: content.dismissLabel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }

  Widget _buildHeader(_DialogPalette palette) {
    final headIcon = content.icon;
    return Row(
      children: [
        if (headIcon != null) ...[
          Icon(headIcon, size: _iconSize, color: palette.icon),
          const SizedBox(width: AppSpacing.space2),
        ],
        Expanded(
          child: Text(
            content.title,
            style: AppTextStyles.title.copyWith(color: palette.title),
          ),
        ),
      ],
    );
  }
}
