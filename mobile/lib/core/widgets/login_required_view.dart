import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/onboarding_sheet.dart';
import '../theme/app_colors.dart';

/// Shown in place of a login-gated page's content (filing a complaint,
/// giving feedback) when the citizen isn't logged in — no auto-redirect,
/// just a clear message and a button that opens the same identity/OTP flow
/// used elsewhere in the app.
class LoginRequiredView extends ConsumerWidget {
  final String message;
  const LoginRequiredView({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.navyTint(0.08), shape: BoxShape.circle),
              child: const Icon(Icons.lock_outline, size: 28, color: AppColors.navy),
            ),
            const SizedBox(height: 14),
            Text(
              'auth.loginRequiredTitle'.tr(),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted, height: 1.5),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => showOnboardingSheet(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('auth.loginNow'.tr(), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
