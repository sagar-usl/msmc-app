import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

/// Sticky sub-header used at the top of most screens: optional back arrow
/// (returns to Home, matching the prototype's per-screen back buttons),
/// title, and an optional trailing widget (e.g. Complaint's "+ New" button).
class ScreenHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final Widget? trailing;
  final VoidCallback? onBack;

  const ScreenHeader({super.key, required this.title, this.showBack = true, this.trailing, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: AppColors.navyTint(0.08), offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          if (showBack)
            InkWell(
              customBorder: const CircleBorder(),
              onTap: onBack ?? () => context.go('/home'),
              child: const SizedBox(
                width: 34,
                height: 34,
                child: Icon(Icons.arrow_back, size: 19, color: AppColors.navy),
              ),
            ),
          if (showBack) const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
