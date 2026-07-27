import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/async_screen.dart';
import '../../core/widgets/screen_header.dart';
import 'providers/news_provider.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = context.locale.languageCode;
    final newsAsync = ref.watch(newsProvider);

    return Column(
      children: [
        ScreenHeader(title: 'news.title'.tr()),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.navy,
            onRefresh: () => ref.read(newsProvider.notifier).refresh(),
            child: AsyncScreen(
              value: newsAsync,
              onRetry: () => ref.read(newsProvider.notifier).refresh(),
              builder: (items) => items.isEmpty
                  ? const Center(child: Text('No news available.', style: TextStyle(color: AppColors.textMuted)))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final item = items[i];
                        final tagColor = _tagColor(item.tag);
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: AppColors.navyTint(0.07), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                    decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
                                    child: Text(_tagLabel(item.tag, lang), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: tagColor)),
                                  ),
                                  const Spacer(),
                                  Text(item.publishedDate, style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(item.title(lang), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              if ((item.snippet(lang) ?? '').isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(item.snippet(lang)!, style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.5)),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Color _tagColor(String tag) => switch (tag) {
    'SCHEME_UPDATE' => AppColors.navy,
    'NOTICE'        => AppColors.saffronDark,
    'EVENT'         => AppColors.green,
    _               => AppColors.navy,
  };

  String _tagLabel(String tag, String lang) => switch (tag) {
    'SCHEME_UPDATE' => lang == 'mr' ? 'योजना अद्यतन' : 'Scheme Update',
    'NOTICE'        => lang == 'mr' ? 'सूचना'         : 'Notice',
    'EVENT'         => lang == 'mr' ? 'कार्यक्रम'      : 'Event',
    _               => tag,
  };
}
