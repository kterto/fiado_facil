import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_dimens.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('AppColors', () {
    const expected = <String, (Color, int)>{
      'bg': (AppColors.bg, 0xFFF7F5F1),
      'surface': (AppColors.surface, 0xFFFFFFFF),
      'textPrimary': (AppColors.textPrimary, 0xFF1C1B1A),
      'textSecondary': (AppColors.textSecondary, 0xFF4F4B45),
      'border': (AppColors.border, 0xFF7A746B),
      'divider': (AppColors.divider, 0xFFE3DFD8),
      'primary': (AppColors.primary, 0xFF1E6B43),
      'primaryPressed': (AppColors.primaryPressed, 0xFF17573A),
      'onPrimary': (AppColors.onPrimary, 0xFFFFFFFF),
      'primaryContainer': (AppColors.primaryContainer, 0xFFE6F2EA),
      'warningContainer': (AppColors.warningContainer, 0xFFFFF3D6),
      'onWarning': (AppColors.onWarning, 0xFF6B4500),
      'error': (AppColors.error, 0xFFB3261E),
      'errorContainer': (AppColors.errorContainer, 0xFFFDECEA),
      'info': (AppColors.info, 0xFF1E4E8C),
      'infoContainer': (AppColors.infoContainer, 0xFFE8F0FB),
      'focus': (AppColors.focus, 0xFF1E6B43),
      'disabledBg': (AppColors.disabledBg, 0xFFD9D5CE),
      'scrim': (AppColors.scrim, 0x661C1B1A),
    };

    test('defines all 19 design tokens', () {
      expect(expected, hasLength(19));
    });

    expected.forEach((name, pair) {
      test('$name is 0x${pair.$2.toRadixString(16).toUpperCase()}', () {
        expect(pair.$1.toARGB32(), pair.$2);
      });
    });
  });

  group('AppSpacing', () {
    test('space1..space8 follow the 4..40 scale', () {
      expect(
        <double>[
          AppSpacing.space1,
          AppSpacing.space2,
          AppSpacing.space3,
          AppSpacing.space4,
          AppSpacing.space5,
          AppSpacing.space6,
          AppSpacing.space7,
          AppSpacing.space8,
        ],
        <double>[4, 8, 12, 16, 20, 24, 32, 40],
      );
    });
  });

  group('AppRadii', () {
    test('sm/md/lg are 8/12/16', () {
      expect(AppRadii.sm, 8);
      expect(AppRadii.md, 12);
      expect(AppRadii.lg, 16);
    });
  });

  group('AppSizes', () {
    test('matches the design size tokens', () {
      expect(AppSizes.touchMin, 48);
      expect(AppSizes.buttonHeight, 56);
      expect(AppSizes.fieldHeight, 56);
      expect(AppSizes.amountFieldHeight, 72);
      expect(AppSizes.listItemMin, 64);
      expect(AppSizes.topBarHeight, 64);
    });
  });

  group('AppShadows.dialog', () {
    const shadow = AppShadows.dialog;

    test('is offset 0,4 with blur 16 and no spread', () {
      expect(shadow.offset, const Offset(0, 4));
      expect(shadow.blurRadius, 16);
      expect(shadow.spreadRadius, 0);
    });

    test('uses the textPrimary RGB at alpha 0x2E', () {
      expect(
        shadow.color.toARGB32() & 0x00FFFFFF,
        AppColors.textPrimary.toARGB32() & 0x00FFFFFF,
      );
      expect(shadow.color.toARGB32() >> 24, 0x2E);
    });
  });
}
