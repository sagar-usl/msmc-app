import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/screen_header.dart';
import 'data/about_content.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Column(
      children: [
        ScreenHeader(title: 'about.pageTitle'.tr()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('assets/images/about-building.jpg', fit: BoxFit.cover),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.55, 1.0],
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.45)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('about.pageTitle'.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text('about.aboutText'.tr(), style: const TextStyle(fontSize: 12.5, height: 1.7, color: AppColors.textBody)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _visionMissionTile('about.visionTitle'.tr(), 'about.visionText'.tr(), AppColors.saffron, showBorder: true),
                    _visionMissionTile('about.missionTitle'.tr(), 'about.missionText'.tr(), AppColors.green, showBorder: false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: kAboutFunctions.asMap().entries.map((entry) {
                    final isLast = entry.key == kAboutFunctions.length - 1;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                      decoration: BoxDecoration(
                        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.divider)),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(entry.value.of(lang), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimaryAlt))),
                          const Icon(Icons.chevron_right, size: 16, color: AppColors.textFaint),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Text('about.membersHeading'.tr().toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
              const SizedBox(height: 10),
              ...kLeadership.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LeadershipCard(member: m, lang: lang),
                  )),
              ...kMembers.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _MemberCard(member: m, lang: lang),
                  )),
              const SizedBox(height: 6),
              Text('about.structureHeading'.tr().toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.6)),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: kHierarchy.asMap().entries.map((entry) {
                    final isLast = entry.key == kHierarchy.length - 1;
                    final level = entry.value;
                    return Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: level.nodes.map((node) {
                            final color = node.saffron ? AppColors.saffronDark : AppColors.navy;
                            final bg = node.saffron ? AppColors.saffronTint(0.1) : AppColors.navyTint(0.06);
                            final border = node.saffron ? AppColors.saffronTint(0.4) : AppColors.navyTint(0.25);
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: bg,
                                border: Border.all(color: border, width: 1.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(node.label.of(lang), textAlign: TextAlign.center, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
                            );
                          }).toList(),
                        ),
                        if (!isLast) Container(width: 2, height: 18, color: const Color(0xFFC7D0DD)),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _visionMissionTile(String title, String body, Color color, {required bool showBorder}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(border: showBorder ? const Border(bottom: BorderSide(color: AppColors.divider)) : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(fontSize: 12.5, height: 1.6, color: AppColors.textBody)),
        ],
      ),
    );
  }
}

class _LeadershipCard extends StatelessWidget {
  final CommissionMember member;
  final String lang;
  const _LeadershipCard({required this.member, required this.lang});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      border: Border.all(color: AppColors.saffron, width: 1.5),
      shadowOpacity: 0.12,
      shadowBlur: 16,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [AppColors.navy, AppColors.navyLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            alignment: Alignment.center,
            child: Text(member.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(member.name.of(lang), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.saffron, borderRadius: BorderRadius.circular(100)),
                      child: Text('about.leadershipBadge'.tr().toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.stars_outlined, size: 13, color: AppColors.navy),
                    const SizedBox(width: 5),
                    Text(member.designation.of(lang), style: const TextStyle(fontSize: 11.5, color: AppColors.navy, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final CommissionMember member;
  final String lang;
  const _MemberCard({required this.member, required this.lang});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      radius: 14,
      shadowOpacity: 0.07,
      shadowBlur: 10,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.navyTint(0.08), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(member.initials, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700, fontSize: 12.5)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name.of(lang), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 11, color: AppColors.textFaint),
                    const SizedBox(width: 5),
                    Text(member.designation.of(lang), style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
