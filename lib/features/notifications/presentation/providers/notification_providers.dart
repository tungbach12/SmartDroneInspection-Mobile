import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/providers/contract_providers.dart';
import 'package:smart_drone_inspection/features/notifications/data/notification_repository.dart';
import 'package:smart_drone_inspection/features/notifications/domain/models/app_notification.dart';

class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() => _fetch();

  Future<List<AppNotification>> _fetch() async {
    final res = await ref.read(notificationRepositoryProvider).list();
    return switch (res) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw ApiFailureException(failure),
    };
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
    ref.invalidate(serverUnreadNotificationsProvider);
  }

  Future<void> markAsRead(String id) async {
    final res = await ref.read(notificationRepositoryProvider).markAsRead(id);
    if (res is ApiSuccess<AppNotification>) {
      final current = state.value;
      if (current != null) {
        state = AsyncData([
          for (final item in current) item.id == id ? res.data : item,
        ]);
      }
      ref.invalidate(serverUnreadNotificationsProvider);
    }
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(
      NotificationsNotifier.new,
    );

final serverUnreadNotificationsProvider = FutureProvider<int>((ref) async {
  final res = await ref.read(notificationRepositoryProvider).getUnreadCount();
  return switch (res) {
    ApiSuccess(:final data) => data,
    ApiError() => 0,
  };
});

final totalUnreadBadgeProvider = Provider<int>((ref) {
  final notifUnread = ref.watch(serverUnreadNotificationsProvider).value ?? 0;
  final chatUnread = ref.watch(unreadContractMessagesCountProvider);
  return notifUnread + chatUnread;
});
