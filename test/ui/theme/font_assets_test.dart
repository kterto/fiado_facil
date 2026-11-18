import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const fontPaths = <String>[
    'assets/fonts/AtkinsonHyperlegible-Regular.ttf',
    'assets/fonts/AtkinsonHyperlegible-Bold.ttf',
  ];

  for (final path in fontPaths) {
    test('bundles $path', () async {
      final data = await rootBundle.load(path);

      expect(data.lengthInBytes, greaterThan(0));
    });
  }

  test('ships the OFL license next to the fonts', () {
    expect(File('assets/fonts/OFL.txt').existsSync(), isTrue);
  });
}
