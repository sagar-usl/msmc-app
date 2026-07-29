import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/async_screen.dart';
import '../../core/widgets/screen_header.dart';
import 'providers/education_provider.dart';

class EducationScreen extends ConsumerWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = context.locale.languageCode;
    final edAsync = ref.watch(educationProvider);

    return Column(
      children: [
        ScreenHeader(title: 'education.title'.tr()),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.navy,
            onRefresh: () => ref.read(educationProvider.notifier).refresh(),
            child: AsyncScreen(
              value: edAsync,
              onRetry: () => ref.read(educationProvider.notifier).refresh(),
              builder: (items) => items.isEmpty
                  ? const Center(child: Text('No education items.', style: TextStyle(color: AppColors.textMuted)))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final it = items[i];
                        return AppCard(
                          padding: const EdgeInsets.all(14),
                          radius: 14,
                          shadowOpacity: 0.06,
                          shadowBlur: 8,
                          onTap: () => context.push('/education/${Uri.encodeComponent(it.id)}', extra: it),
                          child: Row(
                            children: [
                              Container(
                                width: 42, height: 42,
                                decoration: BoxDecoration(color: AppColors.navyTint(0.08), borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                child: const Icon(Icons.school_outlined, size: 19, color: AppColors.navy),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(it.title(lang), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimaryAlt)),
                                    const SizedBox(height: 2),
                                    Text(
                                      it.desc(lang),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11, color: AppColors.textFaint),
                                    ),
                                  ],
                                ),
                              ),
                              // Always a chevron now — tapping always opens
                              // the detail screen (previously this showed a
                              // download icon with no way to actually reach
                              // it when there was no file, or a chevron that
                              // led nowhere since the card had no tap handler
                              // at all in that case).
                              const Icon(Icons.chevron_right, size: 16, color: AppColors.textFaint),
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
}
