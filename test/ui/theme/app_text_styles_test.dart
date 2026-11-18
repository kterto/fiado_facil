import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

typedef _Spec = ({
  TextStyle style,
  double size,
  double lineHeight,
  FontWeight weight,
  bool tabular,
});

void main() {
  test('font family is the bundled Atkinson Hyperlegible', () {
    expect(AppTextStyles.fontFamily, 'AtkinsonHyperlegible');
  });

  final specs = <String, _Spec>{
    'balance': (
      style: AppTextStyles.balance,
      size: 32,
      lineHeight: 40,
      weight: FontWeight.w700,
      tabular: true,
    ),
    'amountInput': (
      style: AppTextStyles.amountInput,
      size: 28,
      lineHeight: 36,
      weight: FontWeight.w700,
      tabular: true,
    ),
    'title': (
      style: AppTextStyles.title,
      size: 22,
      lineHeight: 28,
      weight: FontWeight.w700,
      tabular: false,
    ),
    'label': (
      style: AppTextStyles.label,
      size: 18,
      lineHeight: 24,
      weight: FontWeight.w700,
      tabular: false,
    ),
    'body': (
      style: AppTextStyles.body,
      size: 18,
      lineHeight: 26,
      weight: FontWeight.w400,
      tabular: false,
    ),
    'meta': (
      style: AppTextStyles.meta,
      size: 16,
      lineHeight: 22,
      weight: FontWeight.w400,
      tabular: false,
    ),
  };

  specs.forEach((name, spec) {
    group(name, () {
      test('uses the bundled family', () {
        expect(spec.style.fontFamily, AppTextStyles.fontFamily);
      });

      test('is ${spec.size}/${spec.lineHeight} ${spec.weight}', () {
        expect(spec.style.fontSize, spec.size);
        expect(spec.style.fontWeight, spec.weight);
        expect(spec.style.height, closeTo(spec.lineHeight / spec.size, 1e-9));
      });

      test(spec.tabular ? 'uses tabular figures' : 'has no font features', () {
        final features = spec.style.fontFeatures ?? const <FontFeature>[];
        expect(
          features.contains(const FontFeature.tabularFigures()),
          spec.tabular,
        );
      });

      test('is at least 16 sp', () {
        expect(spec.style.fontSize, greaterThanOrEqualTo(16));
      });
    });
  });
}
