import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_work_order.dart';
import 'package:smart_drone_inspection/features/tasks/presentation/providers/maintenance_providers.dart';
import 'package:smart_drone_inspection/features/tasks/presentation/widgets/record_work_log_sheet.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

class WorkOrderDetailPage extends ConsumerWidget {
  const WorkOrderDetailPage({
    super.key,
    required this.workOrderId,
  });

  final String workOrderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(maintenanceWorkOrderProvider(workOrderId));
    final tasksAsync = ref.watch(maintenanceTasksProvider(workOrderId));
    final logsAsync = ref.watch(maintenanceLogsProvider(workOrderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.workOrderTitle(workOrderId.substring(0, 8))),
      ),
      body: AsyncValueWidget<MobileWorkOrder>(
        value: orderAsync,
        onRetry: () =>
            ref.invalidate(maintenanceWorkOrderProvider(workOrderId)),
        builder: (order) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(maintenanceWorkOrderProvider(workOrderId));
              ref.invalidate(maintenanceTasksProvider(workOrderId));
              ref.invalidate(maintenanceLogsProvider(workOrderId));
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header status card
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.orderPriority(order.priority),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Chip(
                              label: Text(
                                order.status,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.correctiveScope,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(order.correctiveScope),
                        if (order.acceptanceCriteria != null &&
                            order.acceptanceCriteria!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.acceptanceCriteria,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(order.acceptanceCriteria!),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Status execution action buttons
                if (order.isApproved) ...[
                  FilledButton.icon(
                    icon: const Icon(Icons.task_alt),
                    label: const Text('Release work order (Mark Ready)'),
                    onPressed: () async {
                      final repo = ref.read(maintenanceRepositoryProvider);
                      final res = await repo.releaseWork(workOrderId);
                      res.when(
                        success: (_) {
                          ref.invalidate(
                              maintenanceWorkOrderProvider(workOrderId));
                          ref.invalidate(maintenanceWorkOrdersProvider);
                        },
                        failure: (err) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${err.message}')),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                if (order.isReady) ...[
                  FilledButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: Text(context.l10n.startExecutionOnSite),
                    onPressed: () async {
                      final repo = ref.read(maintenanceRepositoryProvider);
                      final res = await repo.startWork(workOrderId);
                      res.when(
                        success: (_) {
                          ref.invalidate(
                              maintenanceWorkOrderProvider(workOrderId));
                          ref.invalidate(maintenanceWorkOrdersProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(context.l10n.executionStarted)),
                          );
                        },
                        failure: (err) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${err.message}')),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                if (order.isReworkRequired) ...[
                  FilledButton.icon(
                    icon: const Icon(Icons.replay),
                    label: const Text('Resume execution'),
                    onPressed: () async {
                      final repo = ref.read(maintenanceRepositoryProvider);
                      final res = await repo.resumeAfterRework(workOrderId);
                      res.when(
                        success: (_) {
                          ref.invalidate(
                              maintenanceWorkOrderProvider(workOrderId));
                          ref.invalidate(maintenanceWorkOrdersProvider);
                        },
                        failure: (err) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${err.message}')),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                if (order.isInProgress) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.edit_note),
                          label: Text(context.l10n.recordLog),
                          onPressed: () {
                            final tasks = tasksAsync.value ?? [];
                            RecordWorkLogSheet.show(
                              context,
                              workOrderId: workOrderId,
                              tasks: tasks,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.check_circle_outline),
                          label: Text(context.l10n.declareComplete),
                          onPressed: () async {
                            final repo =
                                ref.read(maintenanceRepositoryProvider);
                            final res = await repo.declareComplete(workOrderId);
                            res.when(
                              success: (_) {
                                ref.invalidate(
                                    maintenanceWorkOrderProvider(workOrderId));
                                ref.invalidate(maintenanceWorkOrdersProvider);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          context.l10n.workDeclaredCompleted)),
                                );
                              },
                              failure: (err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Error: ${err.message}')),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Tasks Section
                Text(
                  context.l10n.plannedTasks,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                tasksAsync.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(context.l10n.noTasksPlanned),
                      );
                    }
                    return Column(
                      children: tasks.map((task) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${task.taskNumber}'),
                            ),
                            title: Text(task.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle:
                                task.method != null ? Text(task.method!) : null,
                            trailing: Chip(
                              label: Text(task.status,
                                  style: const TextStyle(fontSize: 11)),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text('Failed to load tasks: $e'),
                ),

                const SizedBox(height: 16),

                // Work Logs Section
                Text(
                  context.l10n.workLogs,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                logsAsync.when(
                  data: (logs) {
                    if (logs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(context.l10n.noWorkLogs),
                      );
                    }
                    return Column(
                      children: logs.map((log) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.timer_outlined),
                            title: Text(
                                context.l10n.hoursWorkedLabel(log.workHours)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (log.asLeftCondition != null &&
                                    log.asLeftCondition!.isNotEmpty)
                                  Text(context.l10n
                                      .asLeftLabel(log.asLeftCondition!)),
                                if (log.testReadings != null &&
                                    log.testReadings!.isNotEmpty)
                                  Text(context.l10n
                                      .testReadingsLabel(log.testReadings!)),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (log.status == 'SUBMITTED')
                                  TextButton(
                                    onPressed: () async {
                                      final repo = ref
                                          .read(maintenanceRepositoryProvider);
                                      final res = await repo.verifyWorkLog(
                                          workOrderId, log.id);
                                      res.when(
                                        success: (_) {
                                          ref.invalidate(
                                              maintenanceLogsProvider(
                                                  workOrderId));
                                        },
                                        failure: (err) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error: ${err.message}')),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Verify'),
                                  ),
                                Chip(
                                  label: Text(log.status,
                                      style: const TextStyle(fontSize: 11)),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: log.status == 'VERIFIED'
                                      ? Colors.green.withValues(alpha: 0.15)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text('Failed to load logs: $e'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
