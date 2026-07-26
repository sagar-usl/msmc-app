import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MsmcApp extends StatelessWidget {
  const MsmcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Maharashtra State Minority Commission',
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: AppTheme.light(context.locale.languageCode),
      routerConfig: appRouter,
    );
  }
}
