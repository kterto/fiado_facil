import 'package:fiado_facil/ui/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget wrapInApp(Widget child, {PreferredSizeWidget? appBar}) {
  return wrapScreenInApp(Scaffold(appBar: appBar, body: child));
}

Widget wrapScreenInApp(Widget screen) {
  return MaterialApp(
    theme: buildAppTheme(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: const <Locale>[Locale('pt', 'BR')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: screen,
  );
}

TextStyle renderedTextStyle(WidgetTester tester, Finder textFinder) {
  final richText = tester.widget<RichText>(
    find.descendant(of: textFinder, matching: find.byType(RichText)).first,
  );
  return richText.text.style!;
}
