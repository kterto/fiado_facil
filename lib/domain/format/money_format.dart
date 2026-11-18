const int kMaxCentavos = 9999999;

const String kCurrencySymbol = r'R$';

const String _currencyPrefix = '$kCurrencySymbol ';

final RegExp _asciiDigits = RegExp(r'^[0-9]*$');

String formatCentavos(int centavos) {
  final amount = formatCentavosAmount(centavos.abs());
  final sign = centavos < 0 ? '-' : '';
  return '$sign$_currencyPrefix$amount';
}

String formatCentavosAmount(int centavos) {
  final magnitude = centavos.abs();
  final sign = centavos < 0 ? '-' : '';
  final reais = _groupThousands((magnitude ~/ 100).toString());
  final cents = (magnitude % 100).toString().padLeft(2, '0');
  return '$sign$reais,$cents';
}

int parseDigitsToCentavos(String digits) {
  if (!_asciiDigits.hasMatch(digits)) {
    throw FormatException('Not an ASCII digit string', digits);
  }
  return digits.isEmpty ? 0 : int.parse(digits);
}

String _groupThousands(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final separator = i > 0 && (digits.length - i) % 3 == 0 ? '.' : '';
    buffer.write('$separator${digits[i]}');
  }
  return buffer.toString();
}
