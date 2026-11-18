import 'package:fiado_facil/ui/screens/home_screen.dart';
import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/widgets/app_button.dart';
import 'package:fiado_facil/ui/widgets/top_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

Future<void> _pump(WidgetTester tester) {
  return tester.pumpWidget(wrapScreenInApp(const HomeScreen()));
}

Finder get _body =>
    find.descendant(of: find.byType(Scaffold), matching: find.byType(Center));

void main() {
  testWidgets('is a Scaffold on bg with the "Fiado Fácil" TopBar', (
    tester,
  ) async {
    await _pump(tester);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    final background = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(Scaffold),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(background.color, AppColors.bg);
    final topBar = scaffold.appBar! as TopBar;
    expect(topBar.title, 'Fiado Fácil');
    expect(topBar.onBack, isNull);
    expect(topBar.actions, isEmpty);
  });

  testWidgets('body shows the two S0 lines centered', (tester) async {
    await _pump(tester);

    expect(_body, findsOneWidget);
    final texts = tester.widgetList<Text>(
      find.descendant(of: _body, matching: find.byType(Text)),
    );
    expect(texts.map((t) => t.data), <String>[
      'A caderneta do fiado',
      'Mercadinho da Família',
    ]);
  });

  testWidgets('tagline uses body and shop name uses meta textSecondary', (
    tester,
  ) async {
    await _pump(tester);

    final tagline = renderedTextStyle(
      tester,
      find.text('A caderneta do fiado'),
    );
    expect(tagline.fontSize, AppTextStyles.body.fontSize);
    expect(tagline.height, AppTextStyles.body.height);
    expect(tagline.fontWeight, AppTextStyles.body.fontWeight);

    final shop = renderedTextStyle(tester, find.text('Mercadinho da Família'));
    expect(shop.fontSize, AppTextStyles.meta.fontSize);
    expect(shop.height, AppTextStyles.meta.height);
    expect(shop.color, AppColors.textSecondary);
  });

  testWidgets('has no interactive elements', (tester) async {
    await _pump(tester);

    final screen = find.byType(HomeScreen);
    for (final type in <Type>[
      AppButton,
      InkWell,
      GestureDetector,
      EditableText,
    ]) {
      expect(
        find.descendant(of: screen, matching: find.byType(type)),
        findsNothing,
        reason: '$type found',
      );
    }
    expect(
      find.descendant(
        of: screen,
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      ),
      findsNothing,
    );
  });
}
