import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../notifications/notification_service.dart';
import '../storage/secure_storage.dart';
import '../../features/complaint/providers/complaint_provider.dart';
import 'auth_state_provider.dart';
import 'otp_verification_sheet.dart';

/// Shows the "enter name + mobile, verify OTP" identity flow — used from
/// Profile's "Set Up" action, and from [LoginRequiredView] wherever a
/// citizen hits a login-gated page (filing a complaint, giving feedback).
/// Saves the identity and refreshes every provider that depends on it once
/// verification succeeds; callers don't need to do anything further.
void showOnboardingSheet(
  BuildContext context,
  WidgetRef ref, {
  String? initialName,
  String? initialMobile,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (sheetContext) => _OnboardingSheet(
      ref: ref,
      initialName: initialName,
      initialMobile: initialMobile,
    ),
  );
}

class _OnboardingSheet extends StatefulWidget {
  final WidgetRef ref;
  final String? initialName;
  final String? initialMobile;
  const _OnboardingSheet({required this.ref, this.initialName, this.initialMobile});

  @override
  State<_OnboardingSheet> createState() => _OnboardingSheetState();
}

class _OnboardingSheetState extends State<_OnboardingSheet> {
  late final _nameController = TextEditingController(text: widget.initialName);
  late final _mobileController = TextEditingController(text: widget.initialMobile);
  bool _nameError = false;
  bool _mobileError = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    setState(() {
      _nameError = name.isEmpty;
      _mobileError = !RegExp(r'^[0-9]{10}$').hasMatch(mobile);
    });
    if (_nameError || _mobileError) return;

    final verified = await verifyMobileOtp(context, mobile);
    if (!verified || !mounted) return;

    setState(() => _isSaving = true);
    await SecureStorage.instance.saveCitizen(mobile: mobile, name: name);
    unawaited(NotificationService.instance.syncTokenForCurrentCitizen());
    widget.ref.invalidate(citizenMobileProvider);
    widget.ref.invalidate(citizenNameProvider);
    widget.ref.invalidate(isLoggedInProvider);
    widget.ref.invalidate(complaintListProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('profile.setupTitle'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('profile.setupSubtitle'.tr(), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 16),
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
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isSaving
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text('profile.setupAction'.tr(), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
