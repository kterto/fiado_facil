import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/widgets/app_snackbar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

Future<BuildContext> _pumpHost(WidgetTester tester) async {
  late BuildContext hostContext;
  await tester.pumpWidget(
    wrapInApp(
      Builder(
        builder: (context) {
          hostContext = context;
          return const SizedBox.expand();
        },
      ),
    ),
  );
  return hostContext;
}

void main() {
  testWidgets('shows a floating snackbar for exactly 4 seconds', (
    tester,
  ) async {
    final context = await _pumpHost(tester);

    showAppSnackbar(context, 'Fiado salvo.');
    await tester.pumpAndSettle();

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.behavior, SnackBarBehavior.floating);
    expect(snackBar.duration, const Duration(seconds: 4));
    expect(find.text('Fiado salvo.'), findsOneWidget);
  });

  testWidgets('content is a primaryContainer box with the token styling', (
    tester,
  ) async {
    final context = await _pumpHost(tester);

    showAppSnackbar(context, 'Fiado salvo.');
    await tester.pumpAndSettle();

    final box = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.text('Fiado salvo.'),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = box.decoration as BoxDecoration;
    expect(decoration.color, AppColors.primaryContainer);
    expect(decoration.borderRadius, BorderRadius.circular(12));
    expect(decoration.boxShadow, const <BoxShadow>[AppShadows.dialog]);

    final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle_rounded));
    expect(icon.color, AppColors.primary);
    expect(icon.semanticLabel, isNull);

    final style = renderedTextStyle(tester, find.text('Fiado salvo.'));
    expect(style.fontSize, AppTextStyles.body.fontSize);
    expect(style.height, AppTextStyles.body.height);
    expect(style.color, AppColors.textPrimary);

    final boxRect = tester.getRect(
      find
          .ancestor(
            of: find.text('Fiado salvo.'),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final iconRect = tester.getRect(find.byIcon(Icons.check_circle_rounded));
    final textRect = tester.getRect(find.text('Fiado salvo.'));
    expect(iconRect.left - boxRect.left, 16);
    expect(iconRect.top - boxRect.top, 12);
    expect(textRect.left - iconRect.right, 12);
  });

  testWidgets('a second call replaces the first message', (tester) async {
    final context = await _pumpHost(tester);

    showAppSnackbar(context, 'Primeira');
    await tester.pump();
    showAppSnackbar(context, 'Segunda');
    await tester.pumpAndSettle();

    expect(find.text('Primeira'), findsNothing);
    expect(find.text('Segunda'), findsOneWidget);
  });

  testWidgets('disappears after 4 seconds', (tester) async {
    final context = await _pumpHost(tester);

    showAppSnackbar(context, 'Fiado salvo.');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('Fiado salvo.'), findsNothing);
  });
}
