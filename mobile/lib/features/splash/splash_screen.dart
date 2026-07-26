import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

/// Full-bleed navy splash with the official emblem, bilingual app name and
/// tagline, auto-advancing to Home after ~2.6s — matches the prototype's
/// splash timing (`setTimeout(..., 2600)`) exactly.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.navy, AppColors.navyDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _controller,
                child: ScaleTransition(
                  scale: Tween(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
                  child: Container(
                    width: 112,
                    height: 112,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.saffronTint(0.18), spreadRadius: 6),
                        BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 40, offset: const Offset(0, 12)),
                      ],
                    ),
                    child: Image.asset('assets/images/official-logo-splash.png', fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Column(
                  children: [
                    Text(
                      '${'splash.titleLine1'.tr()}\n${'splash.titleLine2'.tr()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700, height: 1.3),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'splash.govOf'.tr(),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11, letterSpacing: 1.4, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'splash.tagline'.tr(),
                style: const TextStyle(color: AppColors.saffronLight, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 46),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: i == 0 ? 0.9 : 0.5),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
