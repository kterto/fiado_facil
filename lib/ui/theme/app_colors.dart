import 'package:material_ui/material_ui.dart';

abstract final class AppColors {
  static const int _textPrimaryRgb = 0x1C1B1A;
  static const int _opaque = 0xFF000000;

  static const Color bg = Color(0xFFF7F5F1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(_opaque | _textPrimaryRgb);
  static const Color textSecondary = Color(0xFF4F4B45);
  static const Color border = Color(0xFF7A746B);
  static const Color divider = Color(0xFFE3DFD8);
  static const Color primary = Color(0xFF1E6B43);
  static const Color primaryPressed = Color(0xFF17573A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE6F2EA);
  static const Color warningContainer = Color(0xFFFFF3D6);
  static const Color onWarning = Color(0xFF6B4500);
  static const Color error = Color(0xFFB3261E);
  static const Color errorContainer = Color(0xFFFDECEA);
  static const Color info = Color(0xFF1E4E8C);
  static const Color infoContainer = Color(0xFFE8F0FB);
  static const Color focus = Color(0xFF1E6B43);
  static const Color disabledBg = Color(0xFFD9D5CE);
  static const Color scrim = Color(0x66000000 | _textPrimaryRgb);
}

abstract final class AppShadows {
  static const int _dialogShadowAlpha = 0x2E000000;

  static const BoxShadow dialog = BoxShadow(
    color: Color(_dialogShadowAlpha | AppColors._textPrimaryRgb),
    offset: Offset(0, 4),
    blurRadius: 16,
  );
}
