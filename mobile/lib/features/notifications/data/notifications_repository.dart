import '../../../core/network/api_client.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String? ticketId;
  final bool read;
  final String createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    this.ticketId,
    required this.read,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> j) => NotificationItem(
    id:        j['id'] as String,
    title:     j['title'] as String,
    body:      j['body'] as String,
    ticketId:  j['ticketId'] as String?,
    read:      j['read'] as bool,
    createdAt: j['createdAt'] as String,
  );
}

class NotificationsResult {
  final List<NotificationItem> notifications;
  final int unreadCount;
  const NotificationsResult({required this.notifications, required this.unreadCount});
}

class NotificationsRepository {
  const NotificationsRepository();

  Future<NotificationsResult> fetchNotifications(String mobile) async {
    final data = await ApiClient.instance.get<Map<String, dynamic>>(
      '/api/v1/notifications',
      queryParameters: {'mobile': mobile},
    );
    final list = (data['notifications'] as List<dynamic>)
        .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return NotificationsResult(notifications: list, unreadCount: data['unreadCount'] as int);
  }

  Future<void> markRead(String id, String mobile) async {
    await ApiClient.instance.post<Map<String, dynamic>>(
      '/api/v1/notifications/$id/read',
      data: {'mobile': mobile},
    );
  }
}
