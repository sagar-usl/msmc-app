import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/screen_header.dart';
import 'data/news_repository.dart';
import 'news_style_helpers.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsApiItem item;
  const NewsDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final color = tagColor(item.tag);

    return Column(
      children: [
        ScreenHeader(title: 'news.title'.tr(), onBack: () => Navigator.of(context).maybePop()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
                    child: Text(tagLabel(item.tag, lang), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
                  ),
                  const Spacer(),
                  Text(item.publishedDate, style: const TextStyle(fontSize: 11.5, color: AppColors.textFaint)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.title(lang),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.4),
              ),
              if ((item.snippet(lang) ?? '').isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(item.snippet(lang)!, style: const TextStyle(fontSize: 13.5, color: AppColors.textBody, height: 1.8)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
