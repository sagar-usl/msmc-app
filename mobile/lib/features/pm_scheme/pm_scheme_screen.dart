import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/open_url.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/screen_header.dart';
import 'data/pm_scheme_content.dart';

// Uploaded via the admin Documents CMS pipeline (uploads/content-documents/),
// same serving route as Documents/Education attachments — see
// /api/v1/uploads/content-document/[filename] in msmc-admin.
const _kPmSchemeDocumentPath = '/api/v1/uploads/content-document/pm_15_point_programme.pdf';

class PmSchemeScreen extends StatefulWidget {
  const PmSchemeScreen({super.key});

  @override
  State<PmSchemeScreen> createState() => _PmSchemeScreenState();
}

class _PmSchemeScreenState extends State<PmSchemeScreen> {
  final Set<int> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    return Column(
      children: [
        ScreenHeader(title: 'pmScheme.headerTitle'.tr(), onBack: () => Navigator.of(context).maybePop()),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            children: [
              // HERO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.navy, AppColors.navyLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(9)),
                          alignment: Alignment.center,
                          child: const Icon(Icons.stars_outlined, size: 18, color: AppColors.saffron),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'pmScheme.eyebrow'.tr().toUpperCase(),
                            style: const TextStyle(color: AppColors.saffronLight, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('pmScheme.heroTitle'.tr(), style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800, height: 1.3)),
                    const SizedBox(height: 4),
                    Text('pmScheme.heroSub'.tr(), style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // ABOUT CARD
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 18, color: AppColors.navy),
                        const SizedBox(width: 8),
                        Text('pmScheme.aboutTitle'.tr().toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy, letterSpacing: 0.5)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('pmScheme.aboutText1'.tr(), style: const TextStyle(fontSize: 12.5, height: 1.7, color: AppColors.textBody)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kPmSchemeCommunities.map((c) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(100)),
                          child: Text(c.of(lang), style: const TextStyle(color: AppColors.navy, fontSize: 11.5, fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Text('pmScheme.aboutText2'.tr(), style: const TextStyle(fontSize: 12.5, height: 1.7, color: AppColors.textBody)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // ACCORDION
              Text('pmScheme.pointsHeading'.tr().toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              ...kPmSchemePoints.asMap().entries.map((entry) {
                final i = entry.key;
                final p = entry.value;
                final expanded = _expanded.contains(i);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    radius: 14,
                    shadowOpacity: 0.07,
                    shadowBlur: 10,
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => setState(() {
                            if (expanded) {
                              _expanded.remove(i);
                            } else {
                              _expanded.add(i);
                            }
                          }),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: expanded ? AppColors.navy : AppColors.navyTint(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: expanded ? Colors.white : AppColors.navy)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.title.of(lang), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.35)),
                                      if (!expanded) ...[
                                        const SizedBox(height: 3),
                                        Text(p.collapsedSummary.of(lang), style: const TextStyle(fontSize: 11, color: AppColors.textFaint, height: 1.5)),
                                      ],
                                    ],
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: expanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.navy),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (expanded)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(54, 0, 14, 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(p.detail.of(lang), style: const TextStyle(fontSize: 12, height: 1.65, color: AppColors.textBody)),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6),
              // OFFICIAL DOCUMENT
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('pmScheme.docTitle'.tr(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text('pmScheme.docDesc'.tr(), style: const TextStyle(fontSize: 12, height: 1.6, color: AppColors.textMuted)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => openExternalUrl(
                          context,
                          ApiClient.instance.absoluteUrl(_kPmSchemeDocumentPath),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.file_download_outlined, size: 17),
                        label: Text('${'pmScheme.downloadBtn'.tr()} · 2.8 MB', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // QUICK FACTS
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('pmScheme.quickFacts'.tr().toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _fact('pmScheme.beneficiaries'.tr(), 'pmScheme.beneficiariesVal'.tr())),
                        const SizedBox(width: 10),
                        Expanded(child: _fact('pmScheme.programme'.tr(), 'pmScheme.programmeVal'.tr())),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _fact('pmScheme.type'.tr(), 'pmScheme.typeVal'.tr()),
                    const SizedBox(height: 12),
                    Text('pmScheme.focusAreas'.tr().toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textFaint, letterSpacing: 0.4)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kPmSchemeFocusAreas.map((fa) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.saffronTint(0.12), borderRadius: BorderRadius.circular(100)),
                          child: Text(fa.of(lang), style: const TextStyle(color: AppColors.saffronDark, fontSize: 11, fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // NEED ASSISTANCE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.navy, AppColors.navyDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('pmScheme.needAssistance'.tr(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('pmScheme.needAssistanceSub'.tr(), style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, height: 1.6)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _assistAction(Icons.call_outlined, 'pmScheme.call'.tr())),
                        const SizedBox(width: 8),
                        Expanded(child: _assistAction(Icons.email_outlined, 'pmScheme.email'.tr())),
                        const SizedBox(width: 8),
                        Expanded(child: _assistAction(Icons.location_on_outlined, 'pmScheme.visitOffice'.tr())),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fact(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textFaint)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
        ],
      ),
    );
  }

  Widget _assistAction(IconData icon, String label) {
    return Material(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
          child: Column(
            children: [
              Icon(icon, size: 17, color: Colors.white),
              const SizedBox(height: 5),
              Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
