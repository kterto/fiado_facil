import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/widgets/app_text_field.dart';
import 'package:fiado_facil/ui/widgets/field_error.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

InputDecoration _decorationOf(WidgetTester tester) {
  return tester.widget<TextField>(find.byType(TextField)).decoration!;
}

BorderSide _sideOf(InputBorder? border) {
  return (border! as OutlineInputBorder).borderSide;
}

SemanticsData _fieldSemantics(WidgetTester tester) {
  return tester.getSemantics(find.byType(EditableText)).getSemanticsData();
}

List<SemanticsData> _announcedNodesLabelled(String text) {
  return find.semantics
      .byPredicate((node) => !node.isMergedIntoParent)
      .evaluate()
      .map((node) => node.getSemanticsData())
      .where((data) => data.label.contains(text))
      .toList();
}

void main() {
  group('label', () {
    testWidgets('sits 8 above the input in label style', (tester) async {
      await tester.pumpWidget(wrapInApp(const AppTextField(label: 'Nome')));

      final style = renderedTextStyle(tester, find.text('Nome'));
      expect(style.fontSize, AppTextStyles.label.fontSize);
      expect(style.height, AppTextStyles.label.height);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.color, AppColors.textPrimary);
      expect(
        tester.getTopLeft(find.byType(TextField)).dy -
            tester.getBottomLeft(find.text('Nome')).dy,
        8,
      );
    });

    testWidgets('renders the suffix in regular weight textSecondary', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          const AppTextField(label: 'Limite', labelSuffix: '(opcional)'),
        ),
      );

      final richText = tester.widget<RichText>(
        find.descendant(
          of: find.byType(AppTextField),
          matching: find.byWidgetPredicate(
            (w) => w is RichText && w.text.toPlainText().contains('(opcional)'),
          ),
        ),
      );
      TextSpan? suffixSpan;
      richText.text.visitChildren((span) {
        if (span is TextSpan && (span.text ?? '').contains('(opcional)')) {
          suffixSpan = span;
        }
        return true;
      });
      expect(suffixSpan, isNotNull);
      expect(suffixSpan!.style!.fontWeight, FontWeight.w400);
      expect(suffixSpan!.style!.color, AppColors.textSecondary);
    });
  });

  group('input box', () {
    testWidgets('is at least 56 high, surface-filled, radius 8, padding 12', (
      tester,
    ) async {
      await tester.pumpWidget(wrapInApp(const AppTextField(label: 'Nome')));

      expect(
        tester.getSize(find.byType(TextField)).height,
        greaterThanOrEqualTo(56),
      );
      final decoration = _decorationOf(tester);
      expect(decoration.filled, isTrue);
      expect(decoration.fillColor, AppColors.surface);
      final border = decoration.enabledBorder! as OutlineInputBorder;
      expect(border.borderRadius, BorderRadius.circular(8));
      final padding = decoration.contentPadding! as EdgeInsets;
      expect(padding.left, 12);
      expect(padding.right, 12);
    });

    testWidgets('input text uses body', (tester) async {
      await tester.pumpWidget(wrapInApp(const AppTextField(label: 'Nome')));

      final style = tester.widget<TextField>(find.byType(TextField)).style!;
      expect(style.fontSize, AppTextStyles.body.fontSize);
      expect(style.height, AppTextStyles.body.height);
      expect(style.color, AppColors.textPrimary);
    });

    testWidgets('border is 1 px border idle and 2 px primary focused', (
      tester,
    ) async {
      await tester.pumpWidget(wrapInApp(const AppTextField(label: 'Nome')));
      final decoration = _decorationOf(tester);

      expect(
        _sideOf(decoration.enabledBorder),
        const BorderSide(color: AppColors.border, width: 1),
      );
      expect(
        _sideOf(decoration.focusedBorder),
        const BorderSide(color: AppColors.primary, width: 2),
      );
    });

    testWidgets('border is 2 px error idle and focused with errorText', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(const AppTextField(label: 'Nome', errorText: 'Erro')),
      );
      final decoration = _decorationOf(tester);

      expect(
        _sideOf(decoration.enabledBorder),
        const BorderSide(color: AppColors.error, width: 2),
      );
      expect(
        _sideOf(decoration.focusedBorder),
        const BorderSide(color: AppColors.error, width: 2),
      );
    });

    testWidgets('leading icon is border-colored and decorative', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          const AppTextField(
            label: 'Buscar',
            leadingIcon: Icons.search_rounded,
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.search_rounded));
      expect(icon.color, AppColors.border);
      expect(icon.semanticLabel, isNull);
    });

    testWidgets('hint uses textSecondary', (tester) async {
      await tester.pumpWidget(
        wrapInApp(const AppTextField(label: 'Nome', hintText: 'Ex.: Maria')),
      );

      expect(find.text('Ex.: Maria'), findsOneWidget);
      expect(
        renderedTextStyle(tester, find.text('Ex.: Maria')).color,
        AppColors.textSecondary,
      );
    });

    testWidgets('maxLength shows a right-aligned n/max counter in meta', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(const AppTextField(label: 'Descrição', maxLength: 40)),
      );

      final counter = find.text('0/40');
      expect(counter, findsOneWidget);
      final style = renderedTextStyle(tester, counter);
      expect(style.fontSize, AppTextStyles.meta.fontSize);
      expect(style.height, AppTextStyles.meta.height);
      expect(style.color, AppColors.textSecondary);
      expect(
        tester.getTopRight(counter).dx,
        greaterThan(tester.getCenter(find.byType(TextField)).dx),
      );
    });

    testWidgets('passes keyboardType and textCapitalization through', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          const AppTextField(
            label: 'Telefone',
            keyboardType: TextInputType.phone,
            textCapitalization: TextCapitalization.words,
          ),
        ),
      );

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.keyboardType, TextInputType.phone);
      expect(editable.textCapitalization, TextCapitalization.words);
    });

    testWidgets('reports changes through onChanged', (tester) async {
      final values = <String>[];
      await tester.pumpWidget(
        wrapInApp(AppTextField(label: 'Nome', onChanged: values.add)),
      );

      await tester.enterText(find.byType(TextField), 'Ana');

      expect(values, <String>['Ana']);
    });
  });

  group('angle brackets', () {
    testWidgets('are stripped without caller formatters', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrapInApp(AppTextField(label: 'Nome', controller: controller)),
      );

      await tester.enterText(find.byType(TextField), 'a<b>c');

      expect(controller.text, 'abc');
    });

    testWidgets('are stripped before caller formatters run', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final seen = <String>[];
      await tester.pumpWidget(
        wrapInApp(
          AppTextField(
            label: 'Nome',
            controller: controller,
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                seen.add(newValue.text);
                return newValue;
              }),
            ],
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'a<b>c');

      expect(controller.text, 'abc');
      expect(seen, <String>['abc']);
    });
  });

  group('errorText', () {
    testWidgets('shows a FieldError with icon and text below the input', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          const AppTextField(label: 'Nome', errorText: 'Digite o nome.'),
        ),
      );

      expect(find.byType(FieldError), findsOneWidget);
      expect(find.byIcon(Icons.error_rounded), findsOneWidget);
      expect(find.text('Digite o nome.'), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(FieldError)).dy,
        greaterThanOrEqualTo(tester.getBottomLeft(find.byType(TextField)).dy),
      );
    });

    testWidgets('renders no FieldError without errorText', (tester) async {
      await tester.pumpWidget(wrapInApp(const AppTextField(label: 'Nome')));

      expect(find.byType(FieldError), findsNothing);
    });
  });

  group('semantics', () {
    testWidgets('the input is named by the label, not the placeholder', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrapInApp(const AppTextField(label: 'Nome', hintText: 'Ex.: Maria')),
      );

      final field = _fieldSemantics(tester);
      expect(field.flagsCollection.isTextField, isTrue);
      expect(field.label, contains('Nome'));
      expect(field.label, isNot('Ex.: Maria'));
      handle.dispose();
    });

    testWidgets('the input name includes the label suffix', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrapInApp(const AppTextField(label: 'Nome', labelSuffix: '(opcional)')),
      );

      final field = _fieldSemantics(tester);
      expect(field.flagsCollection.isTextField, isTrue);
      expect(field.label, contains('Nome'));
      expect(field.label, contains('(opcional)'));
      handle.dispose();
    });

    testWidgets('the label is announced once, on the input', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(wrapInApp(const AppTextField(label: 'Nome')));

      final labelled = _announcedNodesLabelled('Nome');
      expect(labelled, hasLength(1));
      expect(labelled.single.flagsCollection.isTextField, isTrue);
      handle.dispose();
    });

    testWidgets('the error stays its own live region outside the input', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrapInApp(
          const AppTextField(label: 'Nome', errorText: 'Digite o nome.'),
        ),
      );

      final error = tester
          .getSemantics(find.byType(FieldError))
          .getSemanticsData();
      expect(error.flagsCollection.isLiveRegion, isTrue);
      expect(error.flagsCollection.isTextField, isFalse);
      expect(error.label, contains('Digite o nome.'));
      expect(_fieldSemantics(tester).label, isNot(contains('Digite o nome.')));
      handle.dispose();
    });
  });
}
