import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/widgets/top_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

Widget _scaffoldWith(TopBar bar) {
  return wrapInApp(const SizedBox.shrink(), appBar: bar);
}

void main() {
  test('preferredSize height is 64', () {
    expect(const TopBar(title: 'Clientes').preferredSize.height, 64);
  });

  testWidgets('renders 64 high on the bg color as Scaffold.appBar', (
    tester,
  ) async {
    await tester.pumpWidget(_scaffoldWith(const TopBar(title: 'Clientes')));

    expect(tester.getSize(find.byType(TopBar)).height, 64);
    final box = tester.widget<ColoredBox>(
      find
          .descendant(
            of: find.byType(TopBar),
            matching: find.byType(ColoredBox),
          )
          .first,
    );
    expect(box.color, AppColors.bg);
  });

  testWidgets('title uses the title style in textPrimary', (tester) async {
    await tester.pumpWidget(_scaffoldWith(const TopBar(title: 'Clientes')));

    final style = renderedTextStyle(tester, find.text('Clientes'));
    expect(style.fontSize, 22);
    expect(style.height, AppTextStyles.title.height);
    expect(style.fontWeight, FontWeight.w700);
    expect(style.color, AppColors.textPrimary);
  });

  testWidgets('without onBack has no back button and 16 left padding', (
    tester,
  ) async {
    await tester.pumpWidget(_scaffoldWith(const TopBar(title: 'Clientes')));

    expect(find.text('Voltar'), findsNothing);
    expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
    expect(tester.getTopLeft(find.text('Clientes')).dx, 16);
  });

  testWidgets('with onBack shows "Voltar" that calls onBack, 4 left padding', (
    tester,
  ) async {
    var backs = 0;
    await tester.pumpWidget(
      _scaffoldWith(TopBar(title: 'Novo cliente', onBack: () => backs++)),
    );

    expect(find.text('Voltar'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    final backButton = find.byWidgetPredicate((w) => w is ButtonStyleButton);
    expect(tester.getTopLeft(backButton).dx, 4);

    await tester.tap(find.text('Voltar'));
    expect(backs, 1);
  });

  testWidgets('renders actions in the trailing area with 8 right padding', (
    tester,
  ) async {
    const actionKey = Key('action');
    await tester.pumpWidget(
      _scaffoldWith(
        const TopBar(
          title: 'Clientes',
          actions: [SizedBox(key: actionKey, width: 48, height: 48)],
        ),
      ),
    );

    final barWidth = tester.getSize(find.byType(TopBar)).width;
    expect(tester.getTopRight(find.byKey(actionKey)).dx, barWidth - 8);
    expect(
      tester.getTopLeft(find.byKey(actionKey)).dx,
      greaterThan(tester.getTopRight(find.text('Clientes')).dx),
    );
  });
}
