import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

const Duration _snackbarDuration = Duration(seconds: 4);

void showAppSnackbar(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: _snackbarDuration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      content: _SnackbarContent(message),
    ),
  );
}

class _SnackbarContent extends StatelessWidget {
  const _SnackbarContent(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.all(Radius.circular(AppRadii.md)),
        boxShadow: <BoxShadow>[AppShadows.dialog],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.space3,
          horizontal: AppSpacing.space4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.primary),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
