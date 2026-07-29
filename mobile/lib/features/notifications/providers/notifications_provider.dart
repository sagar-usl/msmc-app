import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/notifications_repository.dart';

final _repo = const NotificationsRepository();

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, NotificationsResult>(NotificationsNotifier.new);

class NotificationsNotifier extends AsyncNotifier<NotificationsResult> {
  Future<NotificationsResult> _fetch() async {
    final mobile = await SecureStorage.instance.getMobile();
    if (mobile == null) return const NotificationsResult(notifications: [], unreadCount: 0);
    return _repo.fetchNotifications(mobile);
  }

  @override
  Future<NotificationsResult> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> markRead(String id) async {
    final current = state.value;
    if (current == null) return;

    final mobile = await SecureStorage.instance.getMobile();
    if (mobile == null) return;

    // Optimistic local update so the dot/badge disappears immediately;
    // refresh() on next open will reconcile with the server either way.
    state = AsyncData(
      NotificationsResult(
        notifications: [
          for (final n in current.notifications)
            if (n.id == id) NotificationItem(id: n.id, title: n.title, body: n.body, ticketId: n.ticketId, read: true, createdAt: n.createdAt)
            else n,
        ],
        unreadCount: current.notifications.any((n) => n.id == id && !n.read)
            ? (current.unreadCount > 0 ? current.unreadCount - 1 : 0)
            : current.unreadCount,
      ),
    );

    await _repo.markRead(id, mobile);
  }
}
