import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:msmc_app/app.dart';

void main() {
  // easy_localization reads/writes the selected locale via SharedPreferences.
  // Without a platform handler, SharedPreferences.getInstance() hangs forever
  // in the test environment instead of failing fast — mock it in-memory.
  SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();

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
