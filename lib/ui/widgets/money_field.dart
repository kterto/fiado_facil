import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/format/money_format.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'app_text_field.dart';

class MoneyField extends StatefulWidget {
  const MoneyField({
    super.key,
    required this.label,
    required this.onChanged,
    this.labelSuffix,
    this.initialCentavos,
    this.errorText,
  });

  final String label;
  final String? labelSuffix;
  final int? initialCentavos;
  final ValueChanged<int?> onChanged;
  final String? errorText;

  @override
  State<MoneyField> createState() => _MoneyFieldState();
}

class _MoneyFieldState extends State<MoneyField> {
  static const String _hint = '0,00';

  late final TextEditingController _controller = TextEditingController(
    text: _CentavosInputFormatter.textFor(widget.initialCentavos),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String text) {
    widget.onChanged(_CentavosInputFormatter.centavosOf(text));
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = AppTextStyles.amountInput.copyWith(
      color: AppColors.textPrimary,
    );
    return AppFieldLayout(
      label: widget.label,
      labelSuffix: widget.labelSuffix,
      errorText: widget.errorText,
      input: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: const <TextInputFormatter>[_CentavosInputFormatter()],
        onChanged: _handleChanged,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        style: inputStyle,
        decoration: _decoration(inputStyle),
      ),
    );
  }

  InputDecoration _decoration(TextStyle inputStyle) {
    return appFieldDecoration(
      hasError: widget.errorText != null,
      inputStyle: inputStyle,
      hintText: _hint,
      prefix: Text(
        kCurrencySymbol,
        style: AppTextStyles.title.copyWith(color: AppColors.textSecondary),
      ),
    ).copyWith(
      constraints: const BoxConstraints(minHeight: AppSizes.amountFieldHeight),
    );
  }
}

class _CentavosInputFormatter extends TextInputFormatter {
  const _CentavosInputFormatter();

  static final RegExp _nonDigit = RegExp('[^0-9]');
  static final RegExp _digit = RegExp('[0-9]');
  static final RegExp _leadingZeros = RegExp('^0+');
  static final int _maxDigits = kMaxCentavos.toString().length;

  static String _digitsOf(String text) => text.replaceAll(_nonDigit, '');

  static String textFor(int? centavos) =>
      centavos == null ? '' : formatCentavosAmount(centavos);

  static int? centavosOf(String text) =>
      text.isEmpty ? null : parseDigitsToCentavos(_digitsOf(text));

  static bool _typedDigit(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldText = oldValue.text;
    final newText = newValue.text;
    final cursor = newValue.selection.end.clamp(0, newText.length);
    var start = 0;
    while (start < cursor &&
        start < oldText.length &&
        oldText[start] == newText[start]) {
      start++;
    }
    return newText.substring(start, cursor).contains(_digit);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = _digitsOf(newValue.text).replaceFirst(_leadingZeros, '');
    if (digits.length > _maxDigits) {
      return oldValue;
    }
    final centavos = parseDigitsToCentavos(digits);
    if (centavos > kMaxCentavos) {
      return oldValue;
    }
    final isEmpty = centavos == 0 && !_typedDigit(oldValue, newValue);
    final text = textFor(isEmpty ? null : centavos);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
