import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../storage/secure_storage.dart';
import 'notification_repository.dart';

const _defaultChannel = AndroidNotificationChannel(
  'msmc_default_channel',
  'General notifications',
  description: 'Complaint status updates, hearing dates and announcements',
  importance: Importance.high,
);

/// Called by the OS in a separate isolate when a push arrives while the app
/// is backgrounded/terminated. Must be a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

/// Wires up FCM: permission request, token retrieval/refresh, and showing a
/// heads-up notification for messages that arrive while the app is open
/// (background/terminated pushes are shown automatically by the OS from the
/// FCM notification payload).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _repository = const NotificationRepository();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await FirebaseMessaging.instance.requestPermission();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_defaultChannel);
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.instance.onTokenRefresh.listen((_) => syncTokenForCurrentCitizen());

    await syncTokenForCurrentCitizen();
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _defaultChannel.id,
          _defaultChannel.name,
          channelDescription: _defaultChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// Sends the current FCM token to the backend for whichever citizen is
  /// currently identified on this device. No-ops if no mobile is saved yet
  /// (e.g. first launch, before the citizen has filed a complaint).
  Future<void> syncTokenForCurrentCitizen() async {
    try {
      final mobile = await SecureStorage.instance.getMobile();
      if (mobile == null) return;
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _repository.registerToken(mobile: mobile, token: token);
    } catch (e) {
      debugPrint('NotificationService.syncTokenForCurrentCitizen failed: $e');
    }
  }
}
