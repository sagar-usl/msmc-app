import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/widgets/app_card.dart';
import '../complaint/providers/complaint_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileAsync = ref.watch(citizenMobileProvider);
    final nameAsync = ref.watch(citizenNameProvider);

    final menu = <_MenuEntry>[
      _MenuEntry(Icons.description_outlined, 'documents.title'.tr(), () => context.go('/documents')),
      _MenuEntry(Icons.flag_outlined, 'complaint.headerList'.tr(), () => context.go('/complaint')),
      _MenuEntry(Icons.bookmark_border, 'schemes.title'.tr(), () => context.go('/schemes')),
      _MenuEntry(Icons.help_outline, 'feedback.headerTitle'.tr(), () => context.go('/feedback')),
    ];

    final mobile = mobileAsync.value;
    final name = nameAsync.value;
    final isOnboarded = mobile != null && mobile.isNotEmpty;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [BoxShadow(color: AppColors.navyTint(0.08), offset: const Offset(0, 1))],
          ),
          child: Text('profile.title'.tr(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.navy, AppColors.navyLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: isOnboarded
                    ? Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.saffron, width: 2.5),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))],
                              image: const DecorationImage(image: AssetImage('assets/images/profile-avatar.png'), fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (name != null && name.isNotEmpty) ? name : 'profile.citizenFallback'.tr(),
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text('+91 $mobile', style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.15)),
                            alignment: Alignment.center,
                            child: const Icon(Icons.person_outline, size: 28, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('profile.setupTitle'.tr(), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 3),
                                Text('profile.setupSubtitle'.tr(), style: const TextStyle(color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => _showOnboardingSheet(context, ref, initialName: name, initialMobile: mobile),
                            style: TextButton.styleFrom(backgroundColor: AppColors.saffron, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
                            child: Text('profile.setupAction'.tr(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: menu.asMap().entries.map((entry) {
                    final isLast = entry.key == menu.length - 1;
                    final m = entry.value;
                    return InkWell(
                      onTap: m.onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.divider))),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(color: AppColors.navyTint(0.07), borderRadius: BorderRadius.circular(9)),
                              alignment: Alignment.center,
                              child: Icon(m.icon, size: 17, color: AppColors.navy),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Text(m.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimaryAlt))),
                            const Icon(Icons.chevron_right, size: 16, color: AppColors.textFaint),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (isOnboarded) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _logout(context, ref),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, size: 16, color: AppColors.red),
                        const SizedBox(width: 8),
                        Text('profile.logout'.tr(), style: const TextStyle(color: AppColors.red, fontSize: 13, fontWeight: FontWeight.w600)),
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

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await SecureStorage.instance.clear();
    ref.invalidate(citizenMobileProvider);
    ref.invalidate(citizenNameProvider);
    ref.invalidate(complaintListProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('profile.loggedOut'.tr())));
    }
  }

  void _showOnboardingSheet(BuildContext context, WidgetRef ref, {String? initialName, String? initialMobile}) {
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

    setState(() => _isSaving = true);
    await SecureStorage.instance.saveCitizen(mobile: mobile, name: name);
    widget.ref.invalidate(citizenMobileProvider);
    widget.ref.invalidate(citizenNameProvider);
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

class _MenuEntry {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  _MenuEntry(this.icon, this.label, this.onTap);
}
