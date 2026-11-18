import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

enum OfflineBannerMode { offline, sending }

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.mode});

  static const String _offlineCopy =
      'Sem internet. Pode continuar usando: os dados serão enviados depois.';
  static const String _sendingCopy = 'Enviando dados...';

  final OfflineBannerMode mode;

  @override
  Widget build(BuildContext context) {
    final (icon, copy) = switch (mode) {
      OfflineBannerMode.offline => (Icons.cloud_off_rounded, _offlineCopy),
      OfflineBannerMode.sending => (Icons.cloud_upload_rounded, _sendingCopy),
    };
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSizes.touchMin),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.space2,
          horizontal: AppSpacing.space4,
        ),
        color: AppColors.infoContainer,
        child: Row(
          children: [
            Icon(icon, color: AppColors.info),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Text(
                copy,
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
