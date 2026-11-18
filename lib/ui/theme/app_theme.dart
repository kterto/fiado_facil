import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTextStyles.fontFamily,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: _colorScheme,
    textTheme: _textTheme,
  );
}

const ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primaryContainer,
  onPrimaryContainer: AppColors.textPrimary,
  secondary: AppColors.primary,
  onSecondary: AppColors.onPrimary,
  surface: AppColors.surface,
  onSurface: AppColors.textPrimary,
  onSurfaceVariant: AppColors.textSecondary,
  outline: AppColors.border,
  outlineVariant: AppColors.divider,
  error: AppColors.error,
  onError: AppColors.onPrimary,
  errorContainer: AppColors.errorContainer,
  onErrorContainer: AppColors.error,
  scrim: AppColors.scrim,
);

const TextTheme _textTheme = TextTheme(
  displayLarge: AppTextStyles.balance,
  displayMedium: AppTextStyles.balance,
  displaySmall: AppTextStyles.amountInput,
  headlineLarge: AppTextStyles.amountInput,
  headlineMedium: AppTextStyles.title,
  headlineSmall: AppTextStyles.title,
  titleLarge: AppTextStyles.title,
  titleMedium: AppTextStyles.label,
  titleSmall: AppTextStyles.label,
  bodyLarge: AppTextStyles.body,
  bodyMedium: AppTextStyles.body,
  bodySmall: AppTextStyles.meta,
  labelLarge: AppTextStyles.label,
  labelMedium: AppTextStyles.meta,
  labelSmall: AppTextStyles.meta,
);
