import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = <_MenuEntry>[
      _MenuEntry(Icons.description_outlined, 'documents.title'.tr(), () => context.go('/documents')),
      _MenuEntry(Icons.flag_outlined, 'complaint.headerList'.tr(), () => context.go('/complaint')),
      _MenuEntry(Icons.bookmark_border, 'schemes.title'.tr(), () => context.go('/schemes')),
      _MenuEntry(Icons.settings_outlined, 'Settings', null),
      _MenuEntry(Icons.help_outline, 'feedback.headerTitle'.tr(), () => context.go('/feedback')),
    ];

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
                child: Row(
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sagar Doshi', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                        SizedBox(height: 2),
                        Text('+91 98xxxxxx45', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                      ],
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
              const SizedBox(height: 16),
              InkWell(
                onTap: () {},
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
          ),
        ),
      ],
    );
  }
}

class _MenuEntry {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  _MenuEntry(this.icon, this.label, this.onTap);
}
