import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/open_url.dart';
import '../../core/widgets/screen_header.dart';
import 'data/education_repository.dart';

class EducationDetailScreen extends StatelessWidget {
  final EducationApiItem item;
  const EducationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final fileUrl = item.absoluteFileUrl();

    return Column(
      children: [
        ScreenHeader(title: item.title(lang), onBack: () => Navigator.of(context).maybePop()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: AppColors.navyTint(0.08), borderRadius: BorderRadius.circular(16)),
                alignment: Alignment.center,
                child: const Icon(Icons.school_outlined, size: 26, color: AppColors.navy),
              ),
              const SizedBox(height: 14),
              Text(item.title(lang), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              if (item.desc(lang).isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(item.desc(lang), style: const TextStyle(fontSize: 13, color: AppColors.textBody, height: 1.7)),
              ],
              if (fileUrl != null) ...[
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => openExternalUrl(context, fileUrl),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.navyTint(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: const Icon(Icons.file_download_outlined, size: 18, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'education.openDocument'.tr(),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: AppColors.navy),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
