import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  final theme = buildAppTheme();
  final scheme = theme.colorScheme;

  test('is a light Material 3 theme', () {
    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.light);
    expect(scheme.brightness, Brightness.light);
  });

  test('defaults to the bundled font family', () {
    expect(theme.textTheme.bodyMedium?.fontFamily, AppTextStyles.fontFamily);
    expect(
      theme.primaryTextTheme.bodyMedium?.fontFamily,
      AppTextStyles.fontFamily,
    );
  });

  test('scaffold background is bg', () {
    expect(theme.scaffoldBackgroundColor, AppColors.bg);
  });

  group('ColorScheme mapping', () {
    final mappings = <String, (Color, Color)>{
      'primary': (scheme.primary, AppColors.primary),
      'onPrimary': (scheme.onPrimary, AppColors.onPrimary),
      'primaryContainer': (scheme.primaryContainer, AppColors.primaryContainer),
      'onPrimaryContainer': (scheme.onPrimaryContainer, AppColors.textPrimary),
      'surface': (scheme.surface, AppColors.surface),
      'onSurface': (scheme.onSurface, AppColors.textPrimary),
      'onSurfaceVariant': (scheme.onSurfaceVariant, AppColors.textSecondary),
      'outline': (scheme.outline, AppColors.border),
      'outlineVariant': (scheme.outlineVariant, AppColors.divider),
      'error': (scheme.error, AppColors.error),
      'onError': (scheme.onError, AppColors.onPrimary),
      'errorContainer': (scheme.errorContainer, AppColors.errorContainer),
      'onErrorContainer': (scheme.onErrorContainer, AppColors.error),
      'scrim': (scheme.scrim, AppColors.scrim),
    };

    test('covers the 14 specified slots', () {
      expect(mappings, hasLength(14));
    });

    mappings.forEach((slot, pair) {
      test(slot, () {
        expect(pair.$1, pair.$2);
      });
    });
  });

  group('TextTheme', () {
    final textTheme = theme.textTheme;

    test('bodyLarge and bodyMedium equal body 18/26', () {
      for (final style in <TextStyle?>[
        textTheme.bodyLarge,
        textTheme.bodyMedium,
      ]) {
        expect(style?.fontFamily, AppTextStyles.body.fontFamily);
        expect(style?.fontSize, AppTextStyles.body.fontSize);
        expect(style?.height, AppTextStyles.body.height);
        expect(style?.fontWeight, AppTextStyles.body.fontWeight);
      }
    });

    final slots = <String, TextStyle?>{
      'displayLarge': textTheme.displayLarge,
      'displayMedium': textTheme.displayMedium,
      'displaySmall': textTheme.displaySmall,
      'headlineLarge': textTheme.headlineLarge,
      'headlineMedium': textTheme.headlineMedium,
      'headlineSmall': textTheme.headlineSmall,
      'titleLarge': textTheme.titleLarge,
      'titleMedium': textTheme.titleMedium,
      'titleSmall': textTheme.titleSmall,
      'bodyLarge': textTheme.bodyLarge,
      'bodyMedium': textTheme.bodyMedium,
      'bodySmall': textTheme.bodySmall,
      'labelLarge': textTheme.labelLarge,
      'labelMedium': textTheme.labelMedium,
      'labelSmall': textTheme.labelSmall,
    };

    test('has 15 slots', () {
      expect(slots, hasLength(15));
    });

    slots.forEach((slot, style) {
      test('$slot is >= 16 sp in the bundled family', () {
        expect(style?.fontSize, greaterThanOrEqualTo(16));
        expect(style?.fontFamily, AppTextStyles.fontFamily);
      });
    });
  });
}
