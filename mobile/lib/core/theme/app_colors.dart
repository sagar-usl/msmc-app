import 'package:flutter/material.dart';

/// Colors lifted directly from the MSMC HTML prototype (see root *.dc.html files).
class AppColors {
  AppColors._();

  static const Color navy = Color(0xFF0B3D91);
  static const Color navyDark = Color(0xFF082A66);
  static const Color navyLight = Color(0xFF1A5CC4);
  static const Color saffron = Color(0xFFFF9933);
  static const Color saffronDark = Color(0xFFB9660B);
  static const Color saffronLight = Color(0xFFFFC876);
  static const Color green = Color(0xFF2E7D32);
  static const Color greenDark = Color(0xFF256428);
  static const Color red = Color(0xFFC0392B);
  static const Color redLight = Color(0xFFFDF1F0);
  static const Color gold = Color(0xFFA68B00);

  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFF0F2F5);
  static const Color border = Color(0xFFDFE3E8);
  static const Color borderDashed = Color(0xFFB7C3DD);

  static const Color textPrimary = Color(0xFF14213D);
  static const Color textPrimaryAlt = Color(0xFF1A1A2E);
  static const Color textBody = Color(0xFF3C4043);
  static const Color textMuted = Color(0xFF5F6368);
  static const Color textFaint = Color(0xFF8A8F98);

  static Color navyTint(double opacity) => navy.withValues(alpha: opacity);
  static Color saffronTint(double opacity) => saffron.withValues(alpha: opacity);
  static Color greenTint(double opacity) => green.withValues(alpha: opacity);
  static Color redTint(double opacity) => red.withValues(alpha: opacity);
}
