import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BottomNavTab {
  final IconData icon;
  final String labelKey;
  final String route;
  const BottomNavTab({required this.icon, required this.labelKey, required this.route});
}

const List<BottomNavTab> kBottomNavTabs = [
  BottomNavTab(icon: Icons.home_outlined, labelKey: 'app.navHome', route: '/home'),
  BottomNavTab(icon: Icons.diversity_3_outlined, labelKey: 'app.navInitiatives', route: '/initiatives'),
  BottomNavTab(icon: Icons.article_outlined, labelKey: 'app.navNews', route: '/news'),
  BottomNavTab(icon: Icons.flag_outlined, labelKey: 'app.navComplaint', route: '/complaint'),
  BottomNavTab(icon: Icons.grid_view_outlined, labelKey: 'app.navSchemes', route: '/schemes'),
];

/// Persistent 5-tab bottom bar (Home / Initiatives / News / Complaint /
/// Schemes) matching the prototype's always-visible bottom nav.
class AppBottomNavBar extends StatelessWidget {
  final String currentLocation;
  final ValueChanged<String> onSelect;

  const AppBottomNavBar({super.key, required this.currentLocation, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 6, 2, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: AppColors.navyTint(0.08), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: kBottomNavTabs.map((tab) {
            final active = currentLocation.startsWith(tab.route);
            final color = active ? AppColors.navy : AppColors.textFaint;
            return Expanded(
              child: InkWell(
                onTap: () => onSelect(tab.route),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(tab.icon, size: 22, color: color),
                      const SizedBox(height: 3),
                      Text(
                        tab.labelKey.tr(),
                        style: TextStyle(fontSize: 10, color: color, fontWeight: active ? FontWeight.w700 : FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
