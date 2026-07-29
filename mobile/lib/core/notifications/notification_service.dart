import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/notifications/providers/notifications_provider.dart';
import '../router/app_router.dart';
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
class NotificationService with WidgetsBindingObserver {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _repository = const NotificationRepository();
  bool _initialized = false;
  ProviderContainer? _container;

  Future<void> init(ProviderContainer container) async {
    if (_initialized) return;
    _initialized = true;
    _container = container;

    await FirebaseMessaging.instance.requestPermission();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_defaultChannel);
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) => _openTicket(response.payload),
    );

    FirebaseMessaging.onMessage.listen((message) {
      _showForegroundNotification(message);
      _refreshNotificationsList();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _openTicket(message.data['ticketId']);
      _refreshNotificationsList();
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((_) => syncTokenForCurrentCitizen());

    // The notification list is a cached provider — it only fetches once,
    // so it goes stale the moment a push arrives without this. Backgrounded
    // pushes can't reach this (separate isolate, no widget tree), so we
    // also refresh whenever the app comes back to the foreground.
    WidgetsBinding.instance.addObserver(this);

    // App was fully closed and got launched by tapping a notification.
    final initialTicketId = (await FirebaseMessaging.instance.getInitialMessage())?.data['ticketId'];
    if (initialTicketId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openTicket(initialTicketId));
    }

    await syncTokenForCurrentCitizen();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNotificationsList();
    }
  }

  void _refreshNotificationsList() {
    _container?.read(notificationsProvider.notifier).refresh();
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
      payload: message.data['ticketId'],
    );
  }

  /// Navigates to the complaint referenced by a tapped notification —
  /// covers all three cases: tapped while foregrounded (local notification
  /// payload), tapped from the system tray while backgrounded
  /// (onMessageOpenedApp), and tapped while the app was fully closed
  /// (getInitialMessage, called once from init()).
  void _openTicket(String? ticketId) {
    if (ticketId == null || ticketId.isEmpty) return;
    appRouter.go('/complaint/${Uri.encodeComponent(ticketId)}');
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
