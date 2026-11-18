import 'package:fiado_facil/app.dart';
import 'package:fiado_facil/ui/widgets/app_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

const Size _phone = Size(360, 800);

Future<void> _usePhoneSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(_phone);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = 2;
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

void main() {
  testWidgets('FiadoFacilApp lays out at 200 % text scale', (tester) async {
    await _usePhoneSurface(tester);

    await tester.pumpWidget(const FiadoFacilApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final context = tester.element(find.text('A caderneta do fiado'));
    expect(MediaQuery.textScalerOf(context).scale(18), 36);
    expect(find.text('Fiado Fácil'), findsOneWidget);
  });

  testWidgets('AppButton variants grow instead of clipping at 200 %', (
    tester,
  ) async {
    await _usePhoneSurface(tester);

    await tester.pumpWidget(
      wrapInApp(
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppButton.primary(
                label: 'Salvar fiado',
                icon: Icons.check_rounded,
                onPressed: () {},
              ),
              AppButton.secondary(label: 'Pagou tudo', onPressed: () {}),
              AppButton.text(label: 'Ver tudo', onPressed: () {}),
              const AppButton.primary(
                label: 'Salvar fiado',
                onPressed: null,
                disabledReason: 'Digite o valor para salvar.',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    for (final button in tester.widgetList(find.byType(FilledButton))) {
      expect(tester.getSize(find.byWidget(button)).height, greaterThan(56));
    }
    expect(tester.getSize(find.byType(OutlinedButton)).height, greaterThan(56));
    expect(find.byType(FilledButton), findsNWidgets(2));
  });
}
