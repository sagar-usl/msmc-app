import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_pill.dart';
import '../data/complaint_style.dart';
import '../providers/complaint_provider.dart';

class ComplaintListScreen extends ConsumerWidget {
  const ComplaintListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = context.locale.languageCode;
    final complaints = ref.watch(complaintListProvider);

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
          child: complaints.isEmpty
              ? const SizedBox()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  itemCount: complaints.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final c = complaints[i];
                    final style = kStatusStyles[c.status]!;
                    return AppCard(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                      radius: 14,
                      shadowOpacity: 0.09,
                      shadowBlur: 14,
                      onTap: () => context.push('/complaint/${Uri.encodeComponent(c.id)}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(c.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
                              StatusPill(label: statusLabel(c.status), background: style.background, foreground: style.foreground, showDot: true),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(categoryLabel(c.category), style: const TextStyle(fontSize: 12, color: AppColors.textBody, fontWeight: FontWeight.w500)),
                              Text(c.date.of(lang), style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
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
                  },
                ),
        ),
      ],
    );
  }
}
