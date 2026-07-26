import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:msmc_app/app.dart';

void main() {
  testWidgets('App boots to splash screen', (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();
    await tester.pumpWidget(
      ProviderScope(
        child: EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('mr')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          startLocale: const Locale('en'),
          child: const MsmcApp(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(MsmcApp), findsOneWidget);
  });
}
