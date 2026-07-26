import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DrawerItemData {
  final IconData icon;
  final String labelKey;
  final String route;
  const DrawerItemData({required this.icon, required this.labelKey, required this.route});
}

const List<DrawerItemData> kDrawerItems = [
  DrawerItemData(icon: Icons.info_outline, labelKey: 'app.drawerAbout', route: '/about'),
  DrawerItemData(icon: Icons.stars_outlined, labelKey: 'app.drawerPmScheme', route: '/pm-scheme'),
  DrawerItemData(icon: Icons.description_outlined, labelKey: 'app.drawerDocuments', route: '/documents'),
  DrawerItemData(icon: Icons.diversity_3_outlined, labelKey: 'app.drawerInitiatives', route: '/initiatives'),
  DrawerItemData(icon: Icons.grid_view_outlined, labelKey: 'app.drawerSchemes', route: '/schemes'),
  DrawerItemData(icon: Icons.school_outlined, labelKey: 'app.drawerEducation', route: '/education'),
  DrawerItemData(icon: Icons.flag_outlined, labelKey: 'app.drawerComplaint', route: '/complaint'),
  DrawerItemData(icon: Icons.forum_outlined, labelKey: 'app.drawerFeedback', route: '/feedback'),
  DrawerItemData(icon: Icons.person_outline, labelKey: 'app.drawerProfile', route: '/profile'),
];

/// Slide-out drawer: gradient header with app identity, list of section
/// links, and a helpline footer — matches the prototype's drawer overlay.
class AppDrawer extends StatelessWidget {
  final ValueChanged<String> onSelect;

  const AppDrawer({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.navy, AppColors.navyDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(color: AppColors.saffron, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Text('MC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 19)),
                  ),
                  const SizedBox(height: 10),
                  Text('app.drawerAppName'.tr(), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('app.drawerAppSub'.tr(), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              children: kDrawerItems.map((item) {
                return ListTile(
                  onTap: () => onSelect(item.route),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(color: AppColors.navyTint(0.07), borderRadius: BorderRadius.circular(10)),
                    child: Icon(item.icon, size: 19, color: AppColors.navy),
                  ),
                  title: Text(item.labelKey.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimaryAlt)),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.divider))),
            child: Row(
              children: [
                const Icon(Icons.call_outlined, size: 17, color: AppColors.green),
                const SizedBox(width: 10),
                Text('app.helpline'.tr(), style: const TextStyle(fontSize: 12, color: AppColors.green, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
