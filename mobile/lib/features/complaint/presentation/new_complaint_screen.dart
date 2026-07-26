import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/complaint_models.dart';
import '../data/complaint_style.dart';
import '../providers/complaint_provider.dart';

class NewComplaintScreen extends ConsumerStatefulWidget {
  const NewComplaintScreen({super.key});

  @override
  ConsumerState<NewComplaintScreen> createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends ConsumerState<NewComplaintScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _descController = TextEditingController();
  ComplaintCategory _category = ComplaintCategory.documents;
  String? _fileName;
  bool _nameError = false;
  bool _mobileError = false;
  bool _descError = false;
  bool _submitted = false;
  String _lastTicketId = '';

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final desc = _descController.text.trim();
    setState(() {
      _nameError = name.isEmpty;
      _mobileError = !RegExp(r'^[0-9]{10}$').hasMatch(mobile);
      _descError = desc.length < 10;
    });
    if (_nameError || _mobileError || _descError) return;

    final ticketId = ref.read(complaintListProvider.notifier).submit(
          name: name,
          mobile: mobile,
          category: _category,
          description: desc,
          fileName: _fileName,
        );
    setState(() {
      _submitted = true;
      _lastTicketId = ticketId;
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) Navigator.of(context).maybePop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenHeader(title: 'complaint.headerForm'.tr(), onBack: () => Navigator.of(context).maybePop()),
        Expanded(child: _submitted ? _buildSuccess() : _buildForm()),
      ],
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.greenTint(0.12), shape: BoxShape.circle),
              child: const Icon(Icons.check, size: 30, color: AppColors.green),
            ),
            const SizedBox(height: 14),
            Text('complaint.registeredTitle'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('complaint.registeredSub'.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted, height: 1.6)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
              child: Text(_lastTicketId, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('complaint.formTitle'.tr(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 14),
              Text('complaint.fullName'.tr(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                onChanged: (_) => setState(() => _nameError = false),
                decoration: InputDecoration(hintText: 'complaint.fullNamePh'.tr(), errorText: _nameError ? 'complaint.errName'.tr() : null),
              ),
              const SizedBox(height: 12),
              Text('complaint.mobileNumber'.tr(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
              const SizedBox(height: 6),
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (_) => setState(() => _mobileError = false),
                decoration: InputDecoration(hintText: 'complaint.mobilePh'.tr(), errorText: _mobileError ? 'complaint.errMobile'.tr() : null, counterText: ''),
              ),
              const SizedBox(height: 12),
              Text('complaint.categoryLabel'.tr(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ComplaintCategory.values.map((cat) {
                  final active = cat == _category;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? AppColors.navy : Colors.white,
                        border: Border.all(color: active ? AppColors.navy : AppColors.border, width: 1.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(categoryLabel(cat), style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textMuted)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Text('complaint.complaintDetails'.tr(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
              const SizedBox(height: 6),
              TextField(
                controller: _descController,
                maxLines: 4,
                onChanged: (_) => setState(() => _descError = false),
                decoration: InputDecoration(hintText: 'complaint.complaintDetailsPh'.tr(), errorText: _descError ? 'complaint.errDescription'.tr() : null),
              ),
              const SizedBox(height: 12),
              Text('complaint.uploadDocs'.tr(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => setState(() => _fileName = 'document_${DateTime.now().millisecondsSinceEpoch}.pdf'),
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFD),
                    border: Border.all(color: AppColors.borderDashed, width: 1.5, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(color: AppColors.navyTint(0.08), borderRadius: BorderRadius.circular(9)),
                        alignment: Alignment.center,
                        child: const Icon(Icons.upload_file_outlined, size: 17, color: AppColors.navy),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_fileName ?? 'complaint.fileDefault'.tr(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy)),
                            const SizedBox(height: 1),
                            Text('complaint.fileTypes'.tr(), style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('complaint.submitBtn'.tr(), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
