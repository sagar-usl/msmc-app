import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_screen.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/notifications_repository.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // The provider is cached app-wide, so it can be stale by the time this
    // screen is opened even with the FCM-triggered refreshes in
    // NotificationService — this is the guaranteed-fresh fallback.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultAsync = ref.watch(notificationsProvider);

    return Column(
      children: [
        ScreenHeader(title: 'Notifications', onBack: () => Navigator.of(context).maybePop()),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.navy,
            onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
            child: AsyncScreen(
              value: resultAsync,
              onRetry: () => ref.read(notificationsProvider.notifier).refresh(),
              builder: (result) {
                final items = result.notifications;
                if (items.isEmpty) {
                  return ListView(
                    children: const [
                      SizedBox(height: 80),
                      Center(child: Text('No notifications yet.', style: TextStyle(color: AppColors.textMuted))),
                    ],
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _NotificationRow(item: items[i]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationRow extends ConsumerWidget {
  final NotificationItem item;
  const _NotificationRow({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      radius: 14,
      shadowOpacity: 0.06,
      shadowBlur: 8,
      onTap: () {
        if (!item.read) ref.read(notificationsProvider.notifier).markRead(item.id);
        if (item.ticketId != null) context.push('/complaint/${Uri.encodeComponent(item.ticketId!)}');
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!item.read)
            const Padding(
              padding: EdgeInsets.only(top: 5, right: 8),
              child: CircleAvatar(radius: 4, backgroundColor: AppColors.saffron),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: item.read ? FontWeight.w600 : FontWeight.w700,
                    color: AppColors.textPrimaryAlt,
                  ),
                ),
                const SizedBox(height: 3),
                Text(item.body, style: const TextStyle(fontSize: 12, color: AppColors.textFaint), maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(_timeAgo(item.createdAt), style: const TextStyle(fontSize: 10.5, color: AppColors.textFaint)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    final seconds = DateTime.now().difference(date).inSeconds.clamp(0, 1 << 31);
    if (seconds < 60) return 'just now';
    final minutes = seconds ~/ 60;
    if (minutes < 60) return '${minutes}m ago';
    final hours = minutes ~/ 60;
    if (hours < 24) return '${hours}h ago';
    return '${hours ~/ 24}d ago';
  }
}
