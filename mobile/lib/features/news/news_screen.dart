import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_pill.dart';
import 'data/news_content.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [BoxShadow(color: AppColors.navyTint(0.08), offset: const Offset(0, 1))],
          ),
          child: Text('news.title'.tr(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            itemCount: kNewsItems.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final it = kNewsItems[i];
              final color = kNewsTagColors[it.tag]!;
              return AppCard(
                padding: const EdgeInsets.all(14),
                radius: 14,
                shadowOpacity: 0.06,
                shadowBlur: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StatusPill(label: kNewsTagLabels[it.tag]!.of(lang), background: color.withValues(alpha: 0.12), foreground: color, uppercase: true),
                        const SizedBox(width: 8),
                        Text(it.date.of(lang), style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(it.title.of(lang), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.35)),
                    const SizedBox(height: 4),
                    Text(it.snippet.of(lang), style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.5)),
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
