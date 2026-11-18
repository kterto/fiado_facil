import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/widgets/field_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

const String _message = 'Digite o nome do cliente.';

void main() {
  testWidgets('renders a 20 dp error icon and the message in body error', (
    tester,
  ) async {
    await tester.pumpWidget(wrapInApp(const FieldError(_message)));

    final icon = tester.widget<Icon>(find.byIcon(Icons.error_rounded));
    expect(icon.size, 20);
    expect(icon.color, AppColors.error);
    expect(icon.semanticLabel, isNull);
    final style = renderedTextStyle(tester, find.text(_message));
    expect(style.fontSize, AppTextStyles.body.fontSize);
    expect(style.height, AppTextStyles.body.height);
    expect(style.fontWeight, AppTextStyles.body.fontWeight);
    expect(style.color, AppColors.error);
  });

  testWidgets('keeps an 8 dp gap between icon and message', (tester) async {
    await tester.pumpWidget(wrapInApp(const FieldError(_message)));

    expect(
      tester.getTopLeft(find.text(_message)).dx -
          tester.getTopRight(find.byIcon(Icons.error_rounded)).dx,
      8,
    );
  });

  testWidgets('is a live region carrying the message', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(wrapInApp(const FieldError(_message)));

    expect(
      tester.getSemantics(find.byType(FieldError)),
      matchesSemantics(label: _message, isLiveRegion: true),
    );
    handle.dispose();
  });
}
