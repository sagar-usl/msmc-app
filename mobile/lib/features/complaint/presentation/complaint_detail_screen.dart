import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_screen.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/complaint_api_models.dart';
import '../providers/complaint_provider.dart';
import 'complaint_style_helpers.dart';

class ComplaintDetailScreen extends ConsumerWidget {
  final String id; // URL-encoded ticketId
  const ComplaintDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketId = Uri.decodeComponent(id);
    final lang = context.locale.languageCode;
    final detailAsync = ref.watch(complaintDetailProvider(ticketId));

    return Column(
      children: [
        ScreenHeader(title: 'complaint.headerDetail'.tr(), onBack: () => Navigator.of(context).maybePop()),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.navy,
            onRefresh: () => ref.read(complaintDetailProvider(ticketId).notifier).refresh(),
            child: AsyncScreen(
              value: detailAsync,
              onRetry: () => ref.read(complaintDetailProvider(ticketId).notifier).refresh(),
              builder: (detail) => _DetailBody(detail: detail, lang: lang),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailBody extends StatelessWidget {
  final ComplaintDetail detail;
  final String lang;
  const _DetailBody({required this.detail, required this.lang});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = statusColors(detail.status);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      children: [
        // Summary card
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(detail.id, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100)),
                    child: Text(statusLabel(detail.status, lang), style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: fg)),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
              _row('complaint.categoryLabel'.tr(), categoryLabel(detail.category, lang)),
              _row('complaint.submittedOn'.tr(), detail.submittedAt),
              if (detail.assignedOfficer != null) _row('complaint.officerLabel'.tr(), detail.assignedOfficer!),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
              Text('complaint.descriptionLabel'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
              const SizedBox(height: 4),
              Text(detail.description, style: const TextStyle(fontSize: 12.5, height: 1.6, color: AppColors.textBody)),
            ],
          ),
        ),

        // Rejection reason
        if (detail.status == 'REJECTED' && detail.rejectionReason != null) ...[
          const SizedBox(height: 14),
          AppCard(
            border: const Border(left: BorderSide(color: AppColors.red, width: 3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('complaint.rejectionReasonLabel'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.red)),
                const SizedBox(height: 5),
                Text(detail.rejectionReason!, style: const TextStyle(fontSize: 12.5, height: 1.6, color: AppColors.textBody)),
              ],
            ),
          ),
        ],

        // Hearings — any number of interim hearings, then one final hearing
        for (final entry in detail.hearings.asMap().entries) ...[
          const SizedBox(height: 14),
          _hearingCard(
            entry.value.isFinal
                ? 'complaint.finalHearingInfo'.tr()
                : '${'complaint.hearingLabel'.tr()} ${entry.key + 1}',
            entry.value,
          ),
        ],

        // Attached documents
        if (detail.documents.isNotEmpty) ...[
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('complaint.uploadDocs'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
                const SizedBox(height: 10),
                for (final doc in detail.documents)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => _openUrl(context, ApiClient.instance.absoluteUrl(doc.fileUrl)),
                      child: Row(
                        children: [
                          const Icon(Icons.insert_drive_file_outlined, size: 16, color: AppColors.navy),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(doc.fileName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.textBody)),
                          ),
                          const Icon(Icons.chevron_right, size: 16, color: AppColors.textFaint),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],

        // Verdict download (only when DISPOSED_OF and URL is available)
        if (detail.verdictDownloadUrl != null) ...[
          const SizedBox(height: 14),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            radius: 14,
            onTap: () => _openUrl(context, detail.verdictDownloadUrl!),
            child: Row(
              children: [
                Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0x2EFFCC00), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: const Icon(Icons.description_outlined, size: 18, color: AppColors.gold)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Final Verdict Document', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text('Tap to download PDF', style: TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
                    ],
                  ),
                ),
                const Icon(Icons.file_download_outlined, size: 18, color: AppColors.navy),
              ],
            ),
          ),
        ],

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textFaint)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    ),
  );

  Widget _hearingCard(String title, HearingInfo h) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 10),
        _row('complaint.dateLabel'.tr(), h.date),
        _row('complaint.timeLabel'.tr(), h.time),
        _row('complaint.locationLabel'.tr(), h.location),
        _row('complaint.officerLabel'.tr(), h.officer),
      ],
    ),
  );

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the verdict file.')),
        );
      }
    }
  }
}
