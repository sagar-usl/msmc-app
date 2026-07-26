import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/status_pill.dart';
import '../data/complaint_models.dart';
import '../data/complaint_style.dart';
import '../providers/complaint_provider.dart';
import '../providers/timeline_builder.dart';
import 'widgets/status_timeline.dart';

class ComplaintDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const ComplaintDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends ConsumerState<ComplaintDetailScreen> {
  bool _showRejectForm = false;
  final _rejectReasonController = TextEditingController();

  final _hearingDateController = TextEditingController();
  final _hearingTimeController = TextEditingController();
  final _hearingLocationController = TextEditingController();
  final _hearingOfficerController = TextEditingController();
  bool _hearingError = false;

  final _hearing2DateController = TextEditingController();
  final _hearing2TimeController = TextEditingController();
  final _hearing2LocationController = TextEditingController();
  final _hearing2OfficerController = TextEditingController();
  bool _hearing2Error = false;

  @override
  void dispose() {
    _rejectReasonController.dispose();
    _hearingDateController.dispose();
    _hearingTimeController.dispose();
    _hearingLocationController.dispose();
    _hearingOfficerController.dispose();
    _hearing2DateController.dispose();
    _hearing2TimeController.dispose();
    _hearing2LocationController.dispose();
    _hearing2OfficerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final complaints = ref.watch(complaintListProvider);
    final isOfficer = ref.watch(isOfficerModeProvider);
    final id = Uri.decodeComponent(widget.id);
    final complaint = complaints.where((c) => c.id == id).isEmpty ? null : complaints.firstWhere((c) => c.id == id);

    if (complaint == null) {
      return Column(
        children: [
          ScreenHeader(title: 'complaint.headerDetail'.tr(), onBack: () => Navigator.of(context).maybePop()),
          const Expanded(child: SizedBox()),
        ],
      );
    }

    final style = kStatusStyles[complaint.status]!;
    final timeline = buildTimeline(
      complaint,
      lang,
      tlSubmitted: 'complaint.tlSubmitted'.tr(),
      tlUnderReview: 'complaint.tlUnderReview'.tr(),
      tlRejected: 'complaint.tlRejected'.tr(),
      tlClosed: 'complaint.tlClosed'.tr(),
      tlAccepted: 'complaint.tlAccepted'.tr(),
      tlHearingScheduled: 'complaint.tlHearingScheduled'.tr(),
      tlCaseOnboard: 'complaint.tlCaseOnboard'.tr(),
      tlFinalHearingScheduled: 'complaint.tlFinalHearingScheduled'.tr(),
      tlVerdictUploaded: 'complaint.tlVerdictUploaded'.tr(),
      tlDisposedOf: 'complaint.tlDisposedOf'.tr(),
    );

    return Column(
      children: [
        ScreenHeader(title: 'complaint.headerDetail'.tr(), onBack: () => Navigator.of(context).maybePop()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            children: [
              // Dev-only role switch, previewing the future officer/citizen split.
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => ref.read(isOfficerModeProvider.notifier).state = !isOfficer,
                  child: Text(
                    isOfficer ? 'complaint.devOfficerToggleOff'.tr() : 'complaint.devOfficerToggleOn'.tr(),
                    style: const TextStyle(fontSize: 11.5, color: AppColors.navy, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(complaint.id, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
                        StatusPill(label: statusLabel(complaint.status), background: style.background, foreground: style.foreground),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
                    _infoRow('complaint.citizenName'.tr(), complaint.name.of(lang)),
                    _infoRow('complaint.mobileNumber'.tr(), complaint.mobile),
                    _infoRow('complaint.categoryLabel'.tr(), categoryLabel(complaint.category)),
                    _infoRow('complaint.submittedOn'.tr(), complaint.date.of(lang)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
                    Text('complaint.descriptionLabel'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                    const SizedBox(height: 4),
                    Text(complaint.description.of(lang), style: const TextStyle(fontSize: 12.5, height: 1.6, color: AppColors.textBody)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(Icons.description_outlined, size: 16, color: AppColors.navy),
                          const SizedBox(width: 8),
                          Expanded(child: Text(complaint.fileName.isEmpty ? 'complaint.noDocLabel'.tr() : complaint.fileName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('complaint.timelineHeading'.tr().toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
                    const SizedBox(height: 14),
                    StatusTimeline(steps: timeline),
                  ],
                ),
              ),
              if (complaint.status == ComplaintStatus.rejected) ...[
                const SizedBox(height: 14),
                AppCard(
                  border: const Border(left: BorderSide(color: AppColors.red, width: 3)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('complaint.rejectionReasonLabel'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.red)),
                      const SizedBox(height: 5),
                      Text(complaint.rejectionReason?.of(lang) ?? '', style: const TextStyle(fontSize: 12.5, height: 1.6, color: AppColors.textBody)),
                    ],
                  ),
                ),
              ],
              if (isOfficer) ..._officerActions(complaint, lang),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _officerActions(Complaint c, String lang) {
    final notifier = ref.read(complaintListProvider.notifier);
    final widgets = <Widget>[];

    if (c.status == ComplaintStatus.underReview) {
      widgets.add(const SizedBox(height: 14));
      widgets.add(AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('complaint.officerDecision'.tr().toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
            const SizedBox(height: 12),
            if (_showRejectForm) ...[
              TextField(controller: _rejectReasonController, maxLines: 3, decoration: InputDecoration(hintText: 'complaint.rejectReasonPh'.tr())),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _showRejectForm = false),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.textMuted, side: BorderSide.none, backgroundColor: AppColors.background, padding: const EdgeInsets.symmetric(vertical: 11)),
                      child: Text('complaint.cancel'.tr(), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_rejectReasonController.text.trim().isEmpty) return;
                        notifier.reject(c.id, _rejectReasonController.text.trim());
                        setState(() => _showRejectForm = false);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 11)),
                      child: Text('complaint.confirmRejection'.tr(), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ] else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => notifier.accept(c.id),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: Text('complaint.acceptComplaint'.tr(), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _showRejectForm = true),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.red, width: 1.5), padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: Text('complaint.rejectComplaint'.tr(), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ));
    }

    if (c.status == ComplaintStatus.accepted && c.hearing == null) {
      widgets.add(const SizedBox(height: 14));
      widgets.add(_hearingForm(
        title: 'complaint.scheduleHearing'.tr(),
        dateController: _hearingDateController,
        timeController: _hearingTimeController,
        locationController: _hearingLocationController,
        officerController: _hearingOfficerController,
        showError: _hearingError,
        buttonLabel: 'complaint.saveHearing'.tr(),
        onSave: () {
          if (_hearingDateController.text.isEmpty || _hearingTimeController.text.isEmpty || _hearingLocationController.text.trim().isEmpty || _hearingOfficerController.text.trim().isEmpty) {
            setState(() => _hearingError = true);
            return;
          }
          notifier.saveHearing(
            c.id,
            date: _hearingDateController.text,
            time: _hearingTimeController.text,
            location: _hearingLocationController.text.trim(),
            officer: _hearingOfficerController.text.trim(),
          );
          setState(() => _hearingError = false);
        },
      ));
    }

    if (c.hearing != null) {
      widgets.add(const SizedBox(height: 14));
      widgets.add(_hearingInfoCard('complaint.scheduledHearing'.tr(), c.hearing!, lang));
    }

    if (c.status == ComplaintStatus.caseOnboard && c.hearing2 == null) {
      widgets.add(const SizedBox(height: 14));
      widgets.add(_hearingForm(
        title: 'complaint.scheduleFinalHearing'.tr(),
        dateController: _hearing2DateController,
        timeController: _hearing2TimeController,
        locationController: _hearing2LocationController,
        officerController: _hearing2OfficerController,
        showError: _hearing2Error,
        buttonLabel: 'complaint.saveFinalHearing'.tr(),
        onSave: () {
          if (_hearing2DateController.text.isEmpty || _hearing2TimeController.text.isEmpty || _hearing2LocationController.text.trim().isEmpty || _hearing2OfficerController.text.trim().isEmpty) {
            setState(() => _hearing2Error = true);
            return;
          }
          notifier.saveHearing2(
            c.id,
            date: _hearing2DateController.text,
            time: _hearing2TimeController.text,
            location: _hearing2LocationController.text.trim(),
            officer: _hearing2OfficerController.text.trim(),
          );
          setState(() => _hearing2Error = false);
        },
      ));
    }

    if (c.hearing2 != null) {
      widgets.add(const SizedBox(height: 14));
      widgets.add(_hearingInfoCard('complaint.finalHearingInfo'.tr(), c.hearing2!, lang, statusLabel: c.verdictFile != null ? 'complaint.completedLabel'.tr() : 'complaint.upcomingLabel'.tr()));
    }

    if (c.status == ComplaintStatus.finalHearingScheduled && c.verdictFile == null) {
      widgets.add(const SizedBox(height: 14));
      widgets.add(AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('complaint.uploadVerdictHeading'.tr().toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => notifier.uploadVerdict(c.id, 'verdict_${c.id.replaceAll('/', '')}.pdf'),
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFD), border: Border.all(color: AppColors.borderDashed, width: 1.5), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.navyTint(0.08), borderRadius: BorderRadius.circular(9)), alignment: Alignment.center, child: const Icon(Icons.upload_file_outlined, size: 17, color: AppColors.navy)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('complaint.uploadVerdictDoc'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy)),
                          Text('complaint.pdfOnly'.tr(), style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    }

    if (c.verdictFile != null) {
      widgets.add(const SizedBox(height: 14));
      widgets.add(AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        radius: 14,
        onTap: () {},
        child: Row(
          children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0x2EFFCC00), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: const Icon(Icons.description_outlined, size: 18, color: AppColors.gold)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.verdictFile!, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('complaint.finalVerdictDoc'.tr(), style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
                ],
              ),
            ),
            const Icon(Icons.file_download_outlined, size: 18, color: AppColors.navy),
          ],
        ),
      ));
    }

    return widgets;
  }

  Widget _hearingForm({
    required String title,
    required TextEditingController dateController,
    required TextEditingController timeController,
    required TextEditingController locationController,
    required TextEditingController officerController,
    required bool showError,
    required String buttonLabel,
    required VoidCallback onSave,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('complaint.hearingDateLabel'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: const InputDecoration(hintText: 'YYYY-MM-DD'),
                      onTap: () async {
                        final picked = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2030), initialDate: DateTime.now());
                        if (picked != null) dateController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('complaint.hearingTimeLabel'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: timeController,
                      readOnly: true,
                      decoration: const InputDecoration(hintText: 'HH:MM'),
                      onTap: () async {
                        final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (picked != null) timeController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('complaint.hearingLocationLabel'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 5),
          TextField(controller: locationController, decoration: InputDecoration(hintText: 'complaint.hearingLocationPh'.tr())),
          const SizedBox(height: 10),
          Text('complaint.officerNameLabel'.tr(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 5),
          TextField(controller: officerController, decoration: InputDecoration(hintText: 'complaint.officerNamePh'.tr())),
          if (showError) ...[
            const SizedBox(height: 8),
            Text('complaint.errHearing'.tr(), style: const TextStyle(fontSize: 11, color: AppColors.red)),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(onSave),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
              child: Text(buttonLabel, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hearingInfoCard(String title, Hearing hearing, String lang, {String? statusLabel}) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
              if (statusLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.saffronTint(0.15), borderRadius: BorderRadius.circular(100)),
                  child: Text(statusLabel, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.saffronDark)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _infoRow('complaint.dateLabel'.tr(), hearing.date),
          _infoRow('complaint.timeLabel'.tr(), hearing.time),
          _infoRow('complaint.locationLabel'.tr(), hearing.location.of(lang)),
          _infoRow('complaint.officerLabel'.tr(), hearing.officer.of(lang)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textFaint)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
