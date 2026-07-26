import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The persistent top bar shown above the content area on every screen except
/// splash: compact CM photo+name on the left, department emblem+name in the
/// centre, and search/notification/language/hamburger icons on the right.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;

  const AppHeader({super.key, required this.onMenuTap});

  /// Generous enough to cover a real status bar inset (via the inner
  /// SafeArea) plus the ~68px of actual header content beneath it. Any
  /// leftover space collapses harmlessly since the Row is top-aligned.
  @override
  Size get preferredSize => const Size.fromHeight(136);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: AppColors.navyTint(0.08), offset: const Offset(0, 1))],
      ),
      // The status bar is a separate system window that owns touch input in
      // its own region even though our content renders edge-to-edge behind
      // it — without this, the header's icon buttons render visually fine
      // but are untappable because they sit under that system-owned strip.
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              // LEFT: CM compact
              SizedBox(
                width: 58,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.saffron, width: 1.5),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/cm-avatar.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'app.cmNameShort'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 7.8, fontWeight: FontWeight.w700, color: AppColors.navy, height: 1.15),
                    ),
                    Text(
                      'app.cmTitleShort'.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 7, color: AppColors.textFaint, height: 1.1),
                    ),
                  ],
                ),
              ),
              // CENTER: department identity
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/official-logo.png', width: 32, fit: BoxFit.contain),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${'app.appNameLine1'.tr()}\n${'app.appNameLine2'.tr()}',
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.navy, height: 1.18),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'app.govOf'.tr().toUpperCase(),
                            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textFaint, letterSpacing: 0.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // RIGHT: icons
              _HeaderIconButton(icon: Icons.search, onTap: () {}),
              _HeaderIconButton(
                label: 'app.langBtn'.tr(),
                onTap: () {
                  final next = context.locale.languageCode == 'mr' ? const Locale('en') : const Locale('mr');
                  context.setLocale(next);
                },
              ),
              _HeaderIconButton(icon: Icons.notifications_outlined, showDot: true, onTap: () {}),
              _HeaderIconButton(icon: Icons.menu, onTap: onMenuTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final bool showDot;
  final VoidCallback onTap;

  const _HeaderIconButton({this.icon, this.label, this.showDot = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (icon != null) Icon(icon, size: 16, color: AppColors.navy),
              if (label != null)
                Text(label!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navy)),
              if (showDot)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.saffron,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
