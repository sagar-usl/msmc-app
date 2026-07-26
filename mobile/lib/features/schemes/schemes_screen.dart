import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/screen_header.dart';
import 'data/schemes_content.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Column(
      children: [
        ScreenHeader(title: 'schemes.title'.tr()),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: kSchemeCategories.length,
            itemBuilder: (context, i) {
              final cat = kSchemeCategories[i];
              return AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(color: cat.tint, borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: Icon(cat.icon, size: 19, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(cat.title.of(lang), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3)),
                    const Spacer(),
                    Text('${cat.count} ${'schemes.schemesWord'.tr()}', style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
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
