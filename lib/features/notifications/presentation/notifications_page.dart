import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/providers/contract_providers.dart';
import 'package:smart_drone_inspection/features/notifications/domain/models/app_notification.dart';
import 'package:smart_drone_inspection/features/notifications/presentation/providers/notification_providers.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  bool _unreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notifsAsync = ref.watch(notificationsProvider);
    final requests =
        ref.watch(serviceRequestsProvider).value ?? const <ServiceRequest>[];
    final currentUserId = ref.watch(authNotifierProvider).value?.user?.id;
    final chatUnreadRequests = requests
        .where((r) => r.unreadCountForUser(currentUserId) > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        actions: [
          FilterChip(
            label: Text(l10n.unreadOnly),
            selected: _unreadOnly,
            onSelected: (v) => setState(() => _unreadOnly = v),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: AsyncValueWidget<List<AppNotification>>(
        value: notifsAsync,
        onRetry: () => ref.read(notificationsProvider.notifier).refresh(),
        builder: (items) {
          final visible = _unreadOnly
              ? items.where((n) => !n.read).toList()
              : items;

          if (visible.isEmpty && chatUnreadRequests.isEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(notificationsProvider.notifier).refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: l10n.noNotificationsYet,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (chatUnreadRequests.isNotEmpty) ...[
                  Text(
                    l10n.unreadChatSection(chatUnreadRequests.length),
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  for (final req in chatUnreadRequests) ...[
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.chat_bubble_outline_rounded),
                        title: Text(req.description),
                        trailing: StatusPill(
                          label: l10n.unreadMessagesBadge(
                            req.unreadCountForUser(currentUserId),
                          ),
                          tone: StatusTone.warning,
                        ),
                        onTap: () => context.push('/requests/${req.id}/chat'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 10),
                ],
                for (final item in visible) ...[
                  Card(
                    child: ListTile(
                      leading: Icon(
                        item.read
                            ? Icons.notifications_none_rounded
                            : Icons.notifications_active_rounded,
                        color: item.read
                            ? Theme.of(context).colorScheme.outline
                            : Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: item.read
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.body.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(item.body),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            formatDateTimeShort(item.createdAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      onTap: () async {
                        if (!item.read) {
                          await ref
                              .read(notificationsProvider.notifier)
                              .markAsRead(item.id);
                        }
                        if (!context.mounted) return;
                        final route = resolveMobileNotificationRoute(
                          item.targetPath,
                        );
                        if (route != null) {
                          context.push(route);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
