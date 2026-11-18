import 'package:material_ui/material_ui.dart';

import 'ui/screens/home_screen.dart';
import 'ui/theme/app_theme.dart';

class FiadoFacilApp extends StatelessWidget {
  const FiadoFacilApp({super.key});

  static const Locale _ptBr = Locale('pt', 'BR');
  static final ThemeData _theme = buildAppTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiado Fácil',
      locale: _ptBr,
      supportedLocales: const <Locale>[_ptBr],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: _theme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
