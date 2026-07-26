import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/bi.dart';

class SchemeCategory {
  final Bi title;
  final int count;
  final IconData icon;
  final Color tint;
  const SchemeCategory({required this.title, required this.count, required this.icon, required this.tint});
}

const List<SchemeCategory> kSchemeCategories = [
  SchemeCategory(title: Bi('Financial Assistance', 'आर्थिक सहाय्य'), count: 6, icon: Icons.payments_outlined, tint: AppColors.navy),
  SchemeCategory(title: Bi('Self Employment Schemes', 'स्वयंरोजगार योजना'), count: 4, icon: Icons.work_outline, tint: AppColors.saffron),
  SchemeCategory(title: Bi('Housing Schemes', 'गृहनिर्माण योजना'), count: 3, icon: Icons.home_outlined, tint: AppColors.green),
  SchemeCategory(title: Bi('Health Schemes', 'आरोग्य योजना'), count: 5, icon: Icons.favorite_border, tint: AppColors.red),
  SchemeCategory(title: Bi('Social Security & Pension', 'सामाजिक सुरक्षा व निवृत्तीवेतन'), count: 3, icon: Icons.shield_outlined, tint: Color(0xFF6A4C93)),
  SchemeCategory(title: Bi('Other Schemes', 'इतर योजना'), count: 8, icon: Icons.more_horiz, tint: AppColors.textMuted),
];
