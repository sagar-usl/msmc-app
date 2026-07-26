import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_header.dart';
import 'data/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  Timer? _timer;
  int _slideIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 4200), (_) {
      final next = (_slideIndex + 1) % kCarouselSlides.length;
      _goToSlide(next);
    });
  }

  void _goToSlide(int index) {
    if (!mounted) return;
    setState(() => _slideIndex = index);
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      children: [
        _Carousel(pageController: _pageController, index: _slideIndex, onDotTap: _goToSlide, lang: lang),
        const SizedBox(height: 16),
        _ChairmanCard(),
        const SizedBox(height: 16),
        _AboutCard(),
        const SizedBox(height: 16),
        _Footer(lang: lang),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _Carousel extends StatelessWidget {
  final PageController pageController;
  final int index;
  final ValueChanged<int> onDotTap;
  final String lang;

  const _Carousel({required this.pageController, required this.index, required this.onDotTap, required this.lang});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: AppColors.navyTint(0.15), blurRadius: 24, offset: const Offset(0, 8))],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: pageController,
              onPageChanged: onDotTap,
              itemCount: kCarouselSlides.length,
              itemBuilder: (context, i) {
                final s = kCarouselSlides[i];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(s.image, fit: BoxFit.cover),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.4, 1.0],
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.55)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 60,
                      right: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.title.of(lang), style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700, height: 1.25)),
                            const SizedBox(height: 2),
                            Text(s.desc.of(lang), style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10.5)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(kCarouselSlides.length, (i) {
                  final active = i == index;
                  return GestureDetector(
                    onTap: () => onDotTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: active ? AppColors.saffron : Colors.white.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChairmanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(label: 'home.chairmanLabel'.tr(), color: AppColors.saffron),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.saffron, width: 2),
                  boxShadow: [BoxShadow(color: AppColors.navyTint(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                  image: const DecorationImage(image: AssetImage('assets/images/chairman-avatar.png'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('home.chairmanName'.tr(), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 1),
                    Text('home.chairmanTitle'.tr(), style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(border: Border(left: BorderSide(color: AppColors.saffron, width: 3))),
            child: Text(
              'home.chairmanMsg'.tr(),
              style: const TextStyle(fontSize: 12.5, height: 1.6, color: AppColors.textBody, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(label: 'home.aboutLabel'.tr(), color: AppColors.navy),
          const SizedBox(height: 10),
          Text('home.aboutText'.tr(), style: const TextStyle(fontSize: 12.5, height: 1.65, color: AppColors.textBody)),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/about'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: const BorderSide(color: AppColors.navy, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              ),
              icon: Text('home.knowMore'.tr(), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
              label: const Icon(Icons.arrow_forward, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final String lang;
  const _Footer({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            children: ['DIGITAL INDIA', 'NIC', 'MYGOV'].map((label) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w600)),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: kFooterLinks.map((l) => Text(l.of(lang), style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11))).toList(),
          ),
          const SizedBox(height: 14),
          Text('home.footerCopyright'.tr(), style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 10, height: 1.5)),
        ],
      ),
    );
  }
}
