import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/screen_header.dart';
import 'data/initiatives_content.dart';

class InitiativesScreen extends StatelessWidget {
  const InitiativesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Column(
      children: [
        ScreenHeader(title: 'initiatives.title'.tr()),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            itemCount: kInitiatives.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final it = kInitiatives[i];
              return AppCard(
                padding: EdgeInsets.zero,
                radius: 16,
                shadowOpacity: 0.14,
                shadowBlur: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(it.image, fit: BoxFit.cover),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.55, 1.0],
                                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.32)],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it.title.of(lang), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 12, color: AppColors.navy),
                              const SizedBox(width: 4),
                              Text(it.district.of(lang), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(it.desc.of(lang), style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.5)),
                        ],
                      ),
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
