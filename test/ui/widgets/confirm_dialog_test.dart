import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/widgets/app_button.dart';
import 'package:fiado_facil/ui/widgets/confirm_dialog.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

const String _title = 'Passa do limite';
const String _message = 'Com este fiado, o saldo fica acima do limite.';
const String _confirm = 'Salvar mesmo assim';
const String _dismiss = 'Voltar e corrigir';

class _Harness {
  bool? result;
  bool completed = false;
}

Future<_Harness> _open(
  WidgetTester tester, {
  ConfirmDialogTone tone = ConfirmDialogTone.neutral,
  IconData? icon = Icons.warning_rounded,
}) async {
  final harness = _Harness();
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
  showConfirmDialog(
    hostContext,
    ConfirmDialogContent(
      title: _title,
      message: _message,
      confirmLabel: _confirm,
      dismissLabel: _dismiss,
      icon: icon,
      tone: tone,
    ),
  ).then((value) {
    harness
      ..result = value
      ..completed = true;
  });
  await tester.pumpAndSettle();
  return harness;
}

Finder get _box => find
    .ancestor(of: find.text(_title), matching: find.byType(DecoratedBox))
    .first;

BoxDecoration _boxDecoration(WidgetTester tester) =>
    tester.widget<DecoratedBox>(_box).decoration as BoxDecoration;

void main() {
  group('result', () {
    testWidgets('confirm returns true', (tester) async {
      final harness = await _open(tester);

      await tester.tap(find.text(_confirm));
      await tester.pumpAndSettle();

      expect(harness.completed, isTrue);
      expect(harness.result, isTrue);
    });

    testWidgets('dismiss returns false', (tester) async {
      final harness = await _open(tester);

      await tester.tap(find.text(_dismiss));
      await tester.pumpAndSettle();

      expect(harness.result, isFalse);
    });

    testWidgets('barrier tap returns false', (tester) async {
      final harness = await _open(tester);

      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();

      expect(harness.completed, isTrue);
      expect(harness.result, isFalse);
    });

    testWidgets('system back returns false', (tester) async {
      final harness = await _open(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(harness.completed, isTrue);
      expect(harness.result, isFalse);
    });
  });

  testWidgets('barrier uses the scrim color', (tester) async {
    await _open(tester);

    final barriers = tester.widgetList<ModalBarrier>(find.byType(ModalBarrier));
    expect(barriers.map((b) => b.color), contains(AppColors.scrim));
  });

  group('box', () {
    testWidgets('has radius 16, 2 px border and the dialog shadow', (
      tester,
    ) async {
      await _open(tester);

      final decoration = _boxDecoration(tester);
      expect(decoration.borderRadius, BorderRadius.circular(16));
      expect((decoration.border! as Border).top.width, 2);
      expect(decoration.boxShadow, const <BoxShadow>[AppShadows.dialog]);
    });

    testWidgets('has 24/20/20 padding, 12 internal gap and 8 above actions', (
      tester,
    ) async {
      await _open(tester);

      final box = tester.getRect(_box);
      final icon = tester.getRect(find.byIcon(Icons.warning_rounded));
      final title = tester.getRect(find.text(_title));
      final message = tester.getRect(find.text(_message));
      final confirm = tester.getRect(find.byType(FilledButton));
      final dismiss = tester.getRect(find.byType(OutlinedButton));

      expect(icon.top - box.top, greaterThanOrEqualTo(24));
      expect(icon.left - box.left, 20);
      expect(box.right - confirm.right, 20);
      expect(box.bottom - dismiss.bottom, 20);
      expect(message.top - icon.bottom, 12);
      expect(confirm.top - message.bottom, 20);
      expect(dismiss.top - confirm.bottom, 8);
      expect(title.left - icon.right, 8);
    });
  });

  group('head and body', () {
    testWidgets('icon is 32 and decorative; title uses the title style', (
      tester,
    ) async {
      await _open(tester);

      final icon = tester.widget<Icon>(find.byIcon(Icons.warning_rounded));
      expect(icon.size, 32);
      expect(icon.semanticLabel, isNull);
      final style = renderedTextStyle(tester, find.text(_title));
      expect(style.fontSize, 22);
      expect(style.height, AppTextStyles.title.height);
      expect(style.fontWeight, FontWeight.w700);
    });

    testWidgets('message uses body textPrimary', (tester) async {
      await _open(tester);

      final style = renderedTextStyle(tester, find.text(_message));
      expect(style.fontSize, AppTextStyles.body.fontSize);
      expect(style.height, AppTextStyles.body.height);
      expect(style.color, AppColors.textPrimary);
    });

    testWidgets('renders without an icon when none is given', (tester) async {
      await _open(tester, icon: null);

      expect(find.byType(Icon), findsNothing);
      expect(find.text(_title), findsOneWidget);
    });
  });

  group('actions', () {
    testWidgets('confirm is a primary AppButton above a secondary dismiss', (
      tester,
    ) async {
      await _open(tester);

      final buttons = tester.widgetList<AppButton>(find.byType(AppButton));
      expect(buttons.map((b) => b.label), <String>[_confirm, _dismiss]);
      expect(
        find.ancestor(
          of: find.text(_confirm),
          matching: find.byType(FilledButton),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.text(_dismiss),
          matching: find.byType(OutlinedButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets('both are full width and 56 high', (tester) async {
      await _open(tester);

      final box = tester.getRect(_box);
      for (final finder in [
        find.byType(FilledButton),
        find.byType(OutlinedButton),
      ]) {
        final rect = tester.getRect(finder);
        expect(rect.height, 56);
        expect(rect.width, box.width - 2 * 20);
      }
    });
  });

  group('tones', () {
    testWidgets('neutral: surface bg, border border, primary icon', (
      tester,
    ) async {
      await _open(tester);

      final decoration = _boxDecoration(tester);
      expect(decoration.color, AppColors.surface);
      expect((decoration.border! as Border).top.color, AppColors.border);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.warning_rounded)).color,
        AppColors.primary,
      );
      expect(
        renderedTextStyle(tester, find.text(_title)).color,
        AppColors.textPrimary,
      );
    });

    testWidgets('warning: warningContainer bg, onWarning border/icon/title', (
      tester,
    ) async {
      await _open(tester, tone: ConfirmDialogTone.warning);

      final decoration = _boxDecoration(tester);
      expect(decoration.color, AppColors.warningContainer);
      expect((decoration.border! as Border).top.color, AppColors.onWarning);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.warning_rounded)).color,
        AppColors.onWarning,
      );
      expect(
        renderedTextStyle(tester, find.text(_title)).color,
        AppColors.onWarning,
      );
    });
  });

  testWidgets('semantics scope and name the route with the title', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await _open(tester);

    final semantics = tester.widget<Semantics>(
      find
          .ancestor(
            of: find.text(_title),
            matching: find.byWidgetPredicate(
              (w) =>
                  w is Semantics &&
                  (w.properties.scopesRoute ?? false) &&
                  (w.properties.namesRoute ?? false),
            ),
          )
          .first,
    );
    expect(semantics.properties.label, _title);
    expect(
      find.semantics.byPredicate(
        (node) =>
            node.label == _title &&
            node.flagsCollection.scopesRoute &&
            node.flagsCollection.namesRoute,
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('semantics expose the dialog as an alert dialog', (tester) async {
    final handle = tester.ensureSemantics();
    await _open(tester);

    expect(
      find.semantics.byPredicate(
        (node) => node.getSemanticsData().role == SemanticsRole.alertDialog,
      ),
      findsOneWidget,
    );
    expect(
      find.semantics.byPredicate(
        (node) => node.getSemanticsData().role == SemanticsRole.dialog,
      ),
      findsNothing,
    );
    handle.dispose();
  });
}
