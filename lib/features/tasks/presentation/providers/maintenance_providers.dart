import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/tasks/data/maintenance_repository.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_task_item.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_work_log.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_work_order.dart';

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  return MaintenanceRepository(ref.watch(dioProvider));
});

/// Lists work orders assigned to the current user.
final maintenanceWorkOrdersProvider =
    FutureProvider.autoDispose<List<MobileWorkOrder>>((ref) async {
  final repository = ref.watch(maintenanceRepositoryProvider);
  final result = await repository.listMyWorkOrders();
  return result.when(
    success: (data) => data,
    failure: (failure) => throw failure,
  );
});

/// Fetches a single work order header by ID.
final maintenanceWorkOrderProvider = FutureProvider.autoDispose
    .family<MobileWorkOrder, String>((ref, workOrderId) async {
  final repository = ref.watch(maintenanceRepositoryProvider);
  final result = await repository.getWorkOrder(workOrderId);
  return result.when(
    success: (data) => data,
    failure: (failure) => throw failure,
  );
});

/// Fetches the planned task list for a work order.
final maintenanceTasksProvider = FutureProvider.autoDispose
    .family<List<MobileTaskItem>, String>((ref, workOrderId) async {
  final repository = ref.watch(maintenanceRepositoryProvider);
  final result = await repository.getTasks(workOrderId);
  return result.when(
    success: (data) => data,
    failure: (failure) => throw failure,
  );
});

/// Fetches the recorded work logs for a work order.
final maintenanceLogsProvider = FutureProvider.autoDispose
    .family<List<MobileWorkLog>, String>((ref, workOrderId) async {
  final repository = ref.watch(maintenanceRepositoryProvider);
  final result = await repository.getWorkLogs(workOrderId);
  return result.when(
    success: (data) => data,
    failure: (failure) => throw failure,
  );
});
