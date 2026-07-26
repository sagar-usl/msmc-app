import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/screen_header.dart';
import 'data/documents_content.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  DocCategory _active = DocCategory.all;

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final filtered = _active == DocCategory.all ? kDocuments : kDocuments.where((d) => d.category == _active).toList();

    return Column(
      children: [
        ScreenHeader(title: 'documents.title'.tr(), trailing: const Icon(Icons.search, size: 19, color: AppColors.navy)),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: DocCategory.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = DocCategory.values[i];
                final active = cat == _active;
                return GestureDetector(
                  onTap: () => setState(() => _active = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.navy : AppColors.background,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      kDocCategoryLabels[cat]!.of(lang),
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textMuted),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final doc = filtered[i];
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
                      decoration: BoxDecoration(color: doc.tint, borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.description_outlined, size: 19, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doc.title.of(lang), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimaryAlt)),
                          const SizedBox(height: 2),
                          Text(doc.meta.of(lang), style: const TextStyle(fontSize: 11, color: AppColors.textFaint)),
                        ],
                      ),
                    ),
                    const Icon(Icons.file_download_outlined, size: 18, color: AppColors.navy),
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
