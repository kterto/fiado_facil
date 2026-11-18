import 'package:fiado_facil/app.dart';
import 'package:fiado_facil/ui/screens/home_screen.dart';
import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('FiadoFacilApp shows the placeholder home, not the counter', (
    tester,
  ) async {
    await tester.pumpWidget(const FiadoFacilApp());

    expect(find.text('Fiado Fácil'), findsOneWidget);
    expect(find.text('A caderneta do fiado'), findsOneWidget);
    expect(find.text('0'), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('body text resolves to Atkinson Hyperlegible 18', (tester) async {
    await tester.pumpWidget(const FiadoFacilApp());

    final style = renderedTextStyle(tester, find.text('A caderneta do fiado'));
    expect(style.fontFamily, 'AtkinsonHyperlegible');
    expect(style.fontSize, 18);
  });

  testWidgets('MaterialApp is configured for pt_BR, light only', (
    tester,
  ) async {
    await tester.pumpWidget(const FiadoFacilApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'Fiado Fácil');
    expect(app.locale, const Locale('pt', 'BR'));
    expect(app.supportedLocales, const <Locale>[Locale('pt', 'BR')]);
    expect(app.localizationsDelegates, GlobalMaterialLocalizations.delegates);
    expect(app.theme, isNotNull);
    expect(app.theme!.useMaterial3, isTrue);
    expect(app.theme!.colorScheme.primary, AppColors.primary);
    expect(app.theme!.scaffoldBackgroundColor, AppColors.bg);
    expect(app.darkTheme, isNull);
    expect(app.themeMode, ThemeMode.light);
    expect(app.debugShowCheckedModeBanner, isFalse);
    expect(app.home, isA<HomeScreen>());
  });

  testWidgets('localizations resolve to Portuguese through material_ui', (
    tester,
  ) async {
    await tester.pumpWidget(const FiadoFacilApp());

    final context = tester.element(find.text('A caderneta do fiado'));
    expect(Localizations.localeOf(context), const Locale('pt', 'BR'));
    expect(MaterialLocalizations.of(context).cancelButtonLabel, 'Cancelar');
  });
}
