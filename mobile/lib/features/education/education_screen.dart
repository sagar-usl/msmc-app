import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/screen_header.dart';
import 'data/education_content.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Column(
      children: [
        ScreenHeader(title: 'education.title'.tr()),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            itemCount: kEducationItems.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final it = kEducationItems[i];
              return AppCard(
                padding: const EdgeInsets.all(14),
                radius: 14,
                shadowOpacity: 0.06,
                shadowBlur: 8,
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: AppColors.navyTint(0.08), borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.school_outlined, size: 19, color: AppColors.navy),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it.title.of(lang), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimaryAlt)),
                          const SizedBox(height: 2),
                          Text(it.desc.of(lang), style: const TextStyle(fontSize: 11, color: AppColors.textFaint)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 16, color: AppColors.textFaint),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
