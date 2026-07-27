import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/secure_storage.dart';
import '../providers/complaint_provider.dart';
import 'complaint_style_helpers.dart';

class NewComplaintScreen extends ConsumerStatefulWidget {
  const NewComplaintScreen({super.key});

  @override
  ConsumerState<NewComplaintScreen> createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends ConsumerState<NewComplaintScreen> {
  final _nameController   = TextEditingController();
  final _mobileController = TextEditingController();
  final _descController   = TextEditingController();

  String _categoryKey = 'DOCUMENTS';
  bool _nameError   = false;
  bool _mobileError = false;
  bool _descError   = false;
  bool _isLoading   = false;
  String? _serverError;
  String? _lastTicketId;

  @override
  void initState() {
    super.initState();
    // Pre-fill mobile/name from storage if the citizen already onboarded
    SecureStorage.instance.getMobile().then((m) {
      if (m != null && mounted) _mobileController.text = m;
    });
    SecureStorage.instance.getName().then((n) {
      if (n != null && mounted) _nameController.text = n;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name   = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final desc   = _descController.text.trim();

    setState(() {
      _nameError   = name.isEmpty;
      _mobileError = !RegExp(r'^[0-9]{10}$').hasMatch(mobile);
      _descError   = desc.length < 10;
      _serverError = null;
    });
    if (_nameError || _mobileError || _descError) return;

    setState(() => _isLoading = true);
    try {
      // Save citizen identity for future sessions
      await SecureStorage.instance.saveCitizen(mobile: mobile, name: name);

      final ticketId = await ref.read(complaintListProvider.notifier).submit(
        fullName: name,
        mobile: mobile,
        category: _categoryKey,
        description: desc,
      );

      setState(() {
        _lastTicketId = ticketId;
        _isLoading = false;
      });

      // Auto-dismiss after showing success
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) Navigator.of(context).maybePop();
      });
    } on ApiException catch (e) {
      setState(() { _serverError = e.userMessage; _isLoading = false; });
    } catch (e) {
      setState(() { _serverError = 'An unexpected error occurred.'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenHeader(title: 'complaint.headerForm'.tr(), onBack: () => Navigator.of(context).maybePop()),
        Expanded(child: _lastTicketId != null ? _buildSuccess() : _buildForm()),
      ],
    );
  }

  Widget _buildSuccess() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(color: AppColors.greenTint(0.12), shape: BoxShape.circle), child: const Icon(Icons.check, size: 30, color: AppColors.green)),
          const SizedBox(height: 14),
          Text('complaint.registeredTitle'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('complaint.registeredSub'.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted, height: 1.6)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
            child: Text(_lastTicketId!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
          ),
        ],
      ),
    ),
  );

  Widget _buildForm() => ListView(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    children: [
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('complaint.formTitle'.tr(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            _label('complaint.fullName'.tr()),
            TextField(controller: _nameController, onChanged: (_) => setState(() => _nameError = false),
              decoration: InputDecoration(hintText: 'complaint.fullNamePh'.tr(), errorText: _nameError ? 'complaint.errName'.tr() : null)),
            const SizedBox(height: 12),
            _label('complaint.mobileNumber'.tr()),
            TextField(controller: _mobileController, keyboardType: TextInputType.phone, maxLength: 10,
              onChanged: (_) => setState(() => _mobileError = false),
              decoration: InputDecoration(hintText: 'complaint.mobilePh'.tr(), errorText: _mobileError ? 'complaint.errMobile'.tr() : null, counterText: '')),
            const SizedBox(height: 12),
            _label('complaint.categoryLabel'.tr()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: kCategoryApiValues.entries.map((e) {
                final active = e.value == _categoryKey;
                return GestureDetector(
                  onTap: () => setState(() => _categoryKey = e.value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.navy : Colors.white,
                      border: Border.all(color: active ? AppColors.navy : AppColors.border, width: 1.5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(e.key, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textMuted)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            _label('complaint.complaintDetails'.tr()),
            TextField(controller: _descController, maxLines: 4, onChanged: (_) => setState(() => _descError = false),
              decoration: InputDecoration(hintText: 'complaint.complaintDetailsPh'.tr(), errorText: _descError ? 'complaint.errDescription'.tr() : null)),
            const SizedBox(height: 14),
            if (_serverError != null) ...[
              Text(_serverError!, style: const TextStyle(fontSize: 12, color: AppColors.red)),
              const SizedBox(height: 10),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.saffron, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isLoading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('complaint.submitBtn'.tr(), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
  );
}
