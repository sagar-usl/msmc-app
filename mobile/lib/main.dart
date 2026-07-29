import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/notifications/notification_service.dart';

// A regular ProviderScope creates its own internal container that's only
// reachable from widgets. NotificationService needs to invalidate
// notificationsProvider from outside the widget tree (FCM listeners fire
// independent of any BuildContext), so we create the container ourselves
// and hand it an UncontrolledProviderScope instead.
final _providerContainer = ProviderContainer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.instance.init(_providerContainer);
  runApp(
    UncontrolledProviderScope(
      container: _providerContainer,
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('mr')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        child: const MsmcApp(),
      ),
    ),
  );
}
