import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/widgets/field_error.dart';
import 'package:fiado_facil/ui/widgets/money_field.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

Future<List<int?>> _pumpField(
  WidgetTester tester, {
  int? initialCentavos,
  String? errorText,
}) async {
  final reported = <int?>[];
  await tester.pumpWidget(
    wrapInApp(
      MoneyField(
        label: 'Valor',
        initialCentavos: initialCentavos,
        errorText: errorText,
        onChanged: reported.add,
      ),
    ),
  );
  return reported;
}

TextField _textField(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField));

String _shownText(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText)).controller.text;

SemanticsData _fieldSemantics(WidgetTester tester) =>
    tester.getSemantics(find.byType(EditableText)).getSemanticsData();

void main() {
  testWidgets('input is at least 72 high', (tester) async {
    await _pumpField(tester);

    expect(
      tester.getSize(find.byType(TextField)).height,
      greaterThanOrEqualTo(72),
    );
  });

  testWidgets('shows an R\$ prefix in title textSecondary', (tester) async {
    await _pumpField(tester);

    final prefix = find.text(r'R$');
    expect(prefix, findsOneWidget);
    final style = renderedTextStyle(tester, prefix);
    expect(style.fontSize, AppTextStyles.title.fontSize);
    expect(style.fontWeight, FontWeight.w700);
    expect(style.color, AppColors.textSecondary);
  });

  testWidgets('value is right-aligned amountInput with tabular figures', (
    tester,
  ) async {
    await _pumpField(tester);

    final field = _textField(tester);
    expect(field.textAlign, TextAlign.right);
    expect(field.style!.fontSize, AppTextStyles.amountInput.fontSize);
    expect(field.style!.height, AppTextStyles.amountInput.height);
    expect(field.style!.fontWeight, FontWeight.w700);
    expect(
      field.style!.fontFeatures,
      contains(const FontFeature.tabularFigures()),
    );
  });

  testWidgets('uses the number keyboard', (tester) async {
    await _pumpField(tester);

    expect(_textField(tester).keyboardType, TextInputType.number);
  });

  testWidgets('typing 4790 shows 47,90 and reports 4790', (tester) async {
    final reported = await _pumpField(tester);

    await tester.enterText(find.byType(TextField), '4790');

    expect(_shownText(tester), '47,90');
    expect(reported.last, 4790);
  });

  testWidgets('typing 0047 shows 0,47 and reports 47', (tester) async {
    final reported = await _pumpField(tester);

    await tester.enterText(find.byType(TextField), '0047');

    expect(_shownText(tester), '0,47');
    expect(reported.last, 47);
  });

  testWidgets('drops a non-digit character', (tester) async {
    final reported = await _pumpField(tester);

    await tester.enterText(find.byType(TextField), '12a');

    expect(_shownText(tester), '0,12');
    expect(reported.last, 12);
  });

  testWidgets('clearing all digits reports null and shows the 0,00 hint', (
    tester,
  ) async {
    final reported = await _pumpField(tester, initialCentavos: 4790);
    expect(_shownText(tester), '47,90');

    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(_shownText(tester), isEmpty);
    expect(reported.last, isNull);
    final hint = find.text('0,00');
    expect(hint, findsOneWidget);
    expect(renderedTextStyle(tester, hint).color, AppColors.textSecondary);
  });

  testWidgets('typing 0 shows 0,00 and reports 0', (tester) async {
    final reported = await _pumpField(tester);

    await tester.enterText(find.byType(TextField), '0');

    expect(_shownText(tester), '0,00');
    expect(reported.last, 0);
  });

  testWidgets('initialCentavos 0 shows and announces 0,00', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpField(tester, initialCentavos: 0);

    expect(_shownText(tester), '0,00');
    expect(_fieldSemantics(tester).value, '0,00');
    handle.dispose();
  });

  testWidgets('initialCentavos null shows an empty field', (tester) async {
    await _pumpField(tester);

    expect(_shownText(tester), isEmpty);
  });

  testWidgets('backspace from 0,00 clears the field and reports null', (
    tester,
  ) async {
    final reported = await _pumpField(tester);
    await tester.enterText(find.byType(TextField), '0');
    expect(_shownText(tester), '0,00');

    await tester.enterText(find.byType(TextField), '0,0');

    expect(_shownText(tester), isEmpty);
    expect(reported.last, isNull);
  });

  testWidgets('backspace from 0,01 clears the field and reports null', (
    tester,
  ) async {
    final reported = await _pumpField(tester, initialCentavos: 1);

    await tester.enterText(find.byType(TextField), '0,0');

    expect(_shownText(tester), isEmpty);
    expect(reported.last, isNull);
  });

  testWidgets('ignores a keystroke past 99.999,99', (tester) async {
    final reported = await _pumpField(tester);
    await tester.enterText(find.byType(TextField), '9999999');
    expect(_shownText(tester), '99.999,99');
    final countBefore = reported.length;

    await tester.enterText(find.byType(TextField), '99.999,999');

    expect(_shownText(tester), '99.999,99');
    expect(reported.length, countBefore);
  });

  testWidgets('ignores a pasted digit string longer than the maximum', (
    tester,
  ) async {
    final reported = await _pumpField(tester, initialCentavos: 4790);

    await tester.enterText(find.byType(TextField), '12345678901234567890123');

    expect(_shownText(tester), '47,90');
    expect(reported, isEmpty);
  });

  testWidgets('errorText shows a FieldError', (tester) async {
    await _pumpField(tester, errorText: 'Digite o valor.');

    expect(find.byType(FieldError), findsOneWidget);
    expect(find.byIcon(Icons.error_rounded), findsOneWidget);
    expect(find.text('Digite o valor.'), findsOneWidget);
  });

  testWidgets('no FieldError without errorText', (tester) async {
    await _pumpField(tester);

    expect(find.byType(FieldError), findsNothing);
  });

  group('semantics', () {
    testWidgets('the input is named by the label with currency context', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _pumpField(tester, initialCentavos: 4790);

      final field = _fieldSemantics(tester);
      expect(field.flagsCollection.isTextField, isTrue);
      expect(field.label, contains('Valor'));
      expect(field.label, contains(r'R$'));
      expect(field.value, '47,90');
      handle.dispose();
    });

    testWidgets('the label is announced once, on the input', (tester) async {
      final handle = tester.ensureSemantics();
      await _pumpField(tester);

      final labelled = find.semantics
          .byPredicate((node) => !node.isMergedIntoParent)
          .evaluate()
          .map((node) => node.getSemanticsData())
          .where((data) => data.label.contains('Valor'))
          .toList();
      expect(labelled, hasLength(1));
      expect(labelled.single.flagsCollection.isTextField, isTrue);
      handle.dispose();
    });

    testWidgets('the error stays its own live region outside the input', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _pumpField(tester, errorText: 'Digite o valor.');

      final error = tester
          .getSemantics(find.byType(FieldError))
          .getSemanticsData();
      expect(error.flagsCollection.isLiveRegion, isTrue);
      expect(error.flagsCollection.isTextField, isFalse);
      expect(error.label, contains('Digite o valor.'));
      expect(_fieldSemantics(tester).label, isNot(contains('Digite o valor.')));
      handle.dispose();
    });
  });
}
