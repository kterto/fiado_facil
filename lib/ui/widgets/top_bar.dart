import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const <Widget>[],
  });

  static const String _backLabel = 'Voltar';

  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.topBarHeight);

  @override
  Widget build(BuildContext context) {
    final back = onBack;
    return ColoredBox(
      color: AppColors.bg,
      child: SafeArea(
        bottom: false,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSizes.topBarHeight),
          padding: EdgeInsets.only(
            left: back == null ? AppSpacing.space4 : AppSpacing.space1,
            right: AppSpacing.space2,
          ),
          child: Row(
            children: [
              if (back != null) ...[
                _buildBackButton(back),
                const SizedBox(width: AppSpacing.space1),
              ],
              Expanded(child: _buildTitle()),
              for (final action in actions) ...[
                const SizedBox(width: AppSpacing.space1),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(VoidCallback back) {
    return AppButton.text(
      label: _backLabel,
      icon: Icons.arrow_back_rounded,
      onPressed: back,
    );
  }

  Widget _buildTitle() {
    return Semantics(
      header: true,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
