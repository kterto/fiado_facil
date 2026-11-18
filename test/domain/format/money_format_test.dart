import 'package:fiado_facil/domain/format/money_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatCentavos', () {
    const cases = <int, String>{
      0: r'R$ 0,00',
      5: r'R$ 0,05',
      123456: r'R$ 1.234,56',
      9999999: r'R$ 99.999,99',
      100000000: r'R$ 1.000.000,00',
      -2210: r'-R$ 22,10',
    };

    cases.forEach((centavos, expected) {
      test('$centavos -> $expected', () {
        expect(formatCentavos(centavos), expected);
      });
    });

    test('separates R\$ from the amount with a plain U+0020 space', () {
      expect(formatCentavos(123456).codeUnitAt(2), 0x20);
    });

    test('puts a U+002D hyphen-minus before R\$ for negatives', () {
      expect(formatCentavos(-2210).codeUnitAt(0), 0x2D);
    });
  });

  group('formatCentavosAmount', () {
    test('123456 -> 1.234,56', () {
      expect(formatCentavosAmount(123456), '1.234,56');
    });

    test('0 -> 0,00', () {
      expect(formatCentavosAmount(0), '0,00');
    });

    const negatives = <int, String>{
      -2210: '-22,10',
      -5: '-0,05',
      -123456: '-1.234,56',
    };
    negatives.forEach((centavos, expected) {
      test('$centavos -> $expected', () {
        expect(formatCentavosAmount(centavos), expected);
      });
    });
  });

  group('parseDigitsToCentavos', () {
    const cases = <String, int>{
      '': 0,
      '5': 5,
      '4790': 4790,
      '0047': 47,
      '100000000': 100000000,
    };

    cases.forEach((digits, expected) {
      test('"$digits" -> $expected', () {
        expect(parseDigitsToCentavos(digits), expected);
      });
    });

    for (final invalid in <String>['4a', '-1', ' 1', '1,0', '١']) {
      test('throws FormatException for "$invalid"', () {
        expect(
          () => parseDigitsToCentavos(invalid),
          throwsA(isA<FormatException>()),
        );
      });
    }
  });

  group('kMaxCentavos', () {
    test('is 9999999', () {
      expect(kMaxCentavos, 9999999);
    });

    test('formats as R\$ 99.999,99', () {
      expect(formatCentavos(kMaxCentavos), r'R$ 99.999,99');
    });
  });
}
