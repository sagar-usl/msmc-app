import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_screen.dart';
import '../data/complaint_api_models.dart';
import '../providers/complaint_provider.dart';
import 'complaint_style_helpers.dart';

class ComplaintListScreen extends ConsumerWidget {
  const ComplaintListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = context.locale.languageCode;
    final listAsync = ref.watch(complaintListProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [BoxShadow(color: AppColors.navyTint(0.08), offset: const Offset(0, 1))],
          ),
          child: Row(
            children: [
              Expanded(child: Text('complaint.headerList'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
              ElevatedButton.icon(
                onPressed: () => context.push('/complaint/new'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
                icon: const Icon(Icons.add, size: 14),
                label: Text('complaint.newBtn'.tr()),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.navy,
            onRefresh: () => ref.read(complaintListProvider.notifier).refresh(),
            child: AsyncScreen(
              value: listAsync,
              onRetry: () => ref.read(complaintListProvider.notifier).refresh(),
              builder: (complaints) => complaints.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 80),
                        Center(
                          child: Column(
                            children: [
                              const Icon(Icons.inbox_outlined, size: 44, color: AppColors.textFaint),
                              const SizedBox(height: 12),
                              Text('complaint.empty'.tr(), style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                      itemCount: complaints.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _ComplaintTile(c: complaints[i], lang: lang),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ComplaintTile extends ConsumerWidget {
  final ComplaintSummary c;
  final String lang;
  const _ComplaintTile({required this.c, required this.lang});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (bg, fg) = statusColors(c.status);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      radius: 14,
      shadowOpacity: 0.09,
      shadowBlur: 14,
      onTap: () async {
        // context.push() resolves when the detail screen is popped — the
        // officer may have changed this complaint's status in the meantime
        // (admin dashboard, or another device), so refetch on return instead
        // of showing whatever was cached when this list first loaded.
        await context.push('/complaint/${Uri.encodeComponent(c.id)}');
        ref.read(complaintListProvider.notifier).refresh();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(c.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text(statusLabel(c.status, lang), style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: fg)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(categoryLabel(c.category, lang), style: const TextStyle(fontSize: 12, color: AppColors.textBody, fontWeight: FontWeight.w500)),
              Text(c.submittedAt, style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('complaint.viewDetails'.tr(), style: const TextStyle(fontSize: 11, color: AppColors.navy, fontWeight: FontWeight.w600)),
              const Icon(Icons.chevron_right, size: 14, color: AppColors.navy),
            ],
          ),
        ],
      ),
    );
  }
}
