import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text styles for the two supported locales. The UI locale only picks which
/// font leads; both fonts are always available via [fontFamilyFallback] so
/// user-entered text renders correctly regardless of script — e.g. a citizen
/// browsing in English can still type their name or complaint in Marathi
/// (Devanagari), and that text must still render (not as tofu boxes) whether
/// on their own device or the admin's. Matches the prototype's
/// `font-family:'Roboto','Noto Sans Devanagari',...` stacks.
class AppTextStyles {
  AppTextStyles._();

  static String fontFamily(String languageCode) =>
      languageCode == 'mr' ? 'NotoSansDevanagari' : 'Roboto';

  static List<String> fontFamilyFallback(String languageCode) =>
      languageCode == 'mr' ? const ['Roboto'] : const ['NotoSansDevanagari'];

  static TextStyle base(String languageCode) => TextStyle(
        fontFamily: fontFamily(languageCode),
        fontFamilyFallback: fontFamilyFallback(languageCode),
        color: AppColors.textPrimary,
      );

  static TextTheme textTheme(String languageCode) {
    final b = base(languageCode);
    return TextTheme(
      displaySmall: b.copyWith(fontSize: 28, fontWeight: FontWeight.w400),
      headlineSmall: b.copyWith(fontSize: 21, fontWeight: FontWeight.w700),
      titleLarge: b.copyWith(fontSize: 19, fontWeight: FontWeight.w800),
      titleMedium: b.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
      titleSmall: b.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
      bodyLarge: b.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textBody),
      bodyMedium: b.copyWith(fontSize: 12.5, fontWeight: FontWeight.w400, color: AppColors.textBody),
      bodySmall: b.copyWith(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textFaint),
      labelLarge: b.copyWith(fontSize: 13.5, fontWeight: FontWeight.w700),
      labelMedium: b.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
      labelSmall: b.copyWith(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textFaint),
    );
  }
}
