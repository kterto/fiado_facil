import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/widgets/app_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

const double _parentWidth = 300;

Widget _inParent(Widget button) {
  return wrapInApp(
    Center(
      child: SizedBox(
        width: _parentWidth,
        child: Column(mainAxisSize: MainAxisSize.min, children: [button]),
      ),
    ),
  );
}

final Finder _anyButton = find.byWidgetPredicate(
  (widget) => widget is ButtonStyleButton,
);

ButtonStyle _styleOf(WidgetTester tester) {
  return tester.widget<ButtonStyleButton>(_anyButton).style!;
}

void main() {
  group('sizes', () {
    testWidgets('primary is 56 high and as wide as its parent', (tester) async {
      await tester.pumpWidget(
        _inParent(AppButton.primary(label: 'Salvar', onPressed: () {})),
      );

      expect(
        tester.getSize(find.byType(FilledButton)),
        const Size(_parentWidth, 56),
      );
    });

    testWidgets('secondary is 56 high and as wide as its parent', (
      tester,
    ) async {
      await tester.pumpWidget(
        _inParent(AppButton.secondary(label: 'Voltar', onPressed: () {})),
      );

      expect(
        tester.getSize(find.byType(OutlinedButton)),
        const Size(_parentWidth, 56),
      );
    });

    testWidgets('text is at least 48 high and narrower than its parent', (
      tester,
    ) async {
      await tester.pumpWidget(
        _inParent(AppButton.text(label: 'Ver', onPressed: () {})),
      );

      final size = tester.getSize(find.byType(TextButton));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.width, lessThan(_parentWidth));
    });

    testWidgets('every variant has a tappable area of at least 48x48', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapInApp(
          Column(
            children: [
              AppButton.primary(label: 'A', onPressed: () {}),
              AppButton.secondary(label: 'B', onPressed: () {}),
              AppButton.text(label: 'C', onPressed: () {}),
            ],
          ),
        ),
      );

      expect(_anyButton, findsNWidgets(3));
      for (final button in tester.widgetList(_anyButton)) {
        final size = tester.getSize(find.byWidget(button));
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      }
    });
  });

  group('primary style', () {
    testWidgets('resolves idle, pressed, padding and radius', (tester) async {
      await tester.pumpWidget(
        _inParent(AppButton.primary(label: 'Salvar', onPressed: () {})),
      );
      final style = _styleOf(tester);

      expect(
        style.backgroundColor!.resolve(<WidgetState>{}),
        AppColors.primary,
      );
      expect(
        style.backgroundColor!.resolve(<WidgetState>{WidgetState.pressed}),
        AppColors.primaryPressed,
      );
      expect(
        style.foregroundColor!.resolve(<WidgetState>{}),
        AppColors.onPrimary,
      );
      final padding = style.padding!.resolve(<WidgetState>{})! as EdgeInsets;
      expect(padding.left, 16);
      expect(padding.right, 16);
      expect(
        style.shape!.resolve(<WidgetState>{}),
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );
    });
  });

  group('secondary style', () {
    testWidgets('resolves surface bg, primary fg and 1 px primary side', (
      tester,
    ) async {
      await tester.pumpWidget(
        _inParent(AppButton.secondary(label: 'Voltar', onPressed: () {})),
      );
      final style = _styleOf(tester);

      expect(
        style.backgroundColor!.resolve(<WidgetState>{}),
        AppColors.surface,
      );
      expect(
        style.foregroundColor!.resolve(<WidgetState>{}),
        AppColors.primary,
      );
      expect(
        style.side!.resolve(<WidgetState>{}),
        const BorderSide(color: AppColors.primary, width: 1),
      );
      final padding = style.padding!.resolve(<WidgetState>{})! as EdgeInsets;
      expect(padding.left, 16);
      expect(padding.right, 16);
      expect(
        style.shape!.resolve(<WidgetState>{}),
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );
    });
  });

  group('text style', () {
    testWidgets('resolves transparent bg, primary fg and 8 px padding', (
      tester,
    ) async {
      await tester.pumpWidget(
        _inParent(AppButton.text(label: 'Ver', onPressed: () {})),
      );
      final style = _styleOf(tester);

      expect(style.backgroundColor!.resolve(<WidgetState>{})!.a, 0);
      expect(
        style.foregroundColor!.resolve(<WidgetState>{}),
        AppColors.primary,
      );
      final padding = style.padding!.resolve(<WidgetState>{})! as EdgeInsets;
      expect(padding.left, 8);
      expect(padding.right, 8);
    });
  });

  group('shared states', () {
    final variants = <String, AppButton Function(VoidCallback?)>{
      'primary': (onPressed) =>
          AppButton.primary(label: 'Salvar', onPressed: onPressed),
      'secondary': (onPressed) =>
          AppButton.secondary(label: 'Salvar', onPressed: onPressed),
      'text': (onPressed) =>
          AppButton.text(label: 'Salvar', onPressed: onPressed),
    };

    variants.forEach((name, build) {
      testWidgets('$name resolves disabled colors', (tester) async {
        await tester.pumpWidget(_inParent(build(null)));
        final style = _styleOf(tester);
        const disabled = <WidgetState>{WidgetState.disabled};

        expect(style.backgroundColor!.resolve(disabled), AppColors.disabledBg);
        expect(
          style.foregroundColor!.resolve(disabled),
          AppColors.textSecondary,
        );
        expect(style.side!.resolve(disabled)!.color, AppColors.disabledBg);
      });

      testWidgets('$name resolves a 2 px focus side', (tester) async {
        await tester.pumpWidget(_inParent(build(() {})));
        final style = _styleOf(tester);

        expect(
          style.side!.resolve(<WidgetState>{WidgetState.focused}),
          const BorderSide(color: AppColors.focus, width: 2),
        );
      });

      testWidgets('$name label uses the label style', (tester) async {
        await tester.pumpWidget(_inParent(build(() {})));
        final rendered = renderedTextStyle(tester, find.text('Salvar'));

        expect(rendered.fontSize, AppTextStyles.label.fontSize);
        expect(rendered.height, AppTextStyles.label.height);
        expect(rendered.fontWeight, FontWeight.w700);
        expect(rendered.fontFamily, AppTextStyles.fontFamily);
      });
    });
  });

  testWidgets('calls onPressed when tapped', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _inParent(AppButton.primary(label: 'Salvar', onPressed: () => taps++)),
    );

    await tester.tap(find.text('Salvar'));

    expect(taps, 1);
  });

  group('icon', () {
    testWidgets('renders at 24 with an 8 dp gap before the label', (
      tester,
    ) async {
      await tester.pumpWidget(
        _inParent(
          AppButton.primary(
            label: 'Salvar',
            icon: Icons.check_rounded,
            onPressed: () {},
          ),
        ),
      );

      final icon = find.byIcon(Icons.check_rounded);
      expect(tester.widget<Icon>(icon).size, 24);
      expect(
        tester.getTopLeft(find.text('Salvar')).dx - tester.getTopRight(icon).dx,
        8,
      );
    });
  });

  group('disabledReason', () {
    const reason = 'Digite o valor para salvar';

    testWidgets('shows below a disabled button in meta textSecondary', (
      tester,
    ) async {
      await tester.pumpWidget(
        _inParent(
          const AppButton.primary(
            label: 'Salvar',
            onPressed: null,
            disabledReason: reason,
          ),
        ),
      );

      final reasonFinder = find.text(reason);
      expect(reasonFinder, findsOneWidget);
      expect(
        tester.getTopLeft(reasonFinder).dy,
        greaterThan(tester.getBottomLeft(find.byType(FilledButton)).dy),
      );
      final rendered = renderedTextStyle(tester, reasonFinder);
      expect(rendered.fontSize, AppTextStyles.meta.fontSize);
      expect(rendered.height, AppTextStyles.meta.height);
      expect(rendered.color, AppColors.textSecondary);
    });

    testWidgets('is absent when the button is enabled', (tester) async {
      await tester.pumpWidget(
        _inParent(
          AppButton.primary(
            label: 'Salvar',
            onPressed: () {},
            disabledReason: reason,
          ),
        ),
      );

      expect(find.text(reason), findsNothing);
    });
  });
}
