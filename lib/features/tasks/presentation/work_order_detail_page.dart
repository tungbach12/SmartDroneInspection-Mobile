import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        title: Text('Order #${workOrderId.substring(0, 8)}'),
      ),
      body: AsyncValueWidget<MobileWorkOrder>(
        value: orderAsync,
        onRetry: () => ref.invalidate(maintenanceWorkOrderProvider(workOrderId)),
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
                              'Priority: ${order.priority}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Chip(
                              label: Text(
                                order.status,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Corrective Scope:',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(order.correctiveScope),
                        if (order.acceptanceCriteria != null &&
                            order.acceptanceCriteria!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Acceptance Criteria:',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
                if (order.isReady) ...[
                  FilledButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Execution on Site'),
                    onPressed: () async {
                      final repo = ref.read(maintenanceRepositoryProvider);
                      final res = await repo.startWork(workOrderId);
                      res.when(
                        success: (_) {
                          ref.invalidate(maintenanceWorkOrderProvider(workOrderId));
                          ref.invalidate(maintenanceWorkOrdersProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Execution started')),
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

                if (order.isInProgress) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.edit_note),
                          label: const Text('Record Log'),
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
                          label: const Text('Declare Complete'),
                          onPressed: () async {
                            final repo = ref.read(maintenanceRepositoryProvider);
                            final res = await repo.declareComplete(workOrderId);
                            res.when(
                              success: (_) {
                                ref.invalidate(maintenanceWorkOrderProvider(workOrderId));
                                ref.invalidate(maintenanceWorkOrdersProvider);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Work declared completed')),
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Tasks Section
                Text(
                  'Planned Tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                tasksAsync.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('No tasks planned yet for this order.'),
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
                            title: Text(task.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: task.method != null ? Text(task.method!) : null,
                            trailing: Chip(
                              label: Text(task.status, style: const TextStyle(fontSize: 11)),
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
                  'Work Logs',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                logsAsync.when(
                  data: (logs) {
                    if (logs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('No work logs recorded yet.'),
                      );
                    }
                    return Column(
                      children: logs.map((log) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.timer_outlined),
                            title: Text('${log.workHours} hours worked'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (log.asLeftCondition != null)
                                  Text('As-left: ${log.asLeftCondition}'),
                                if (log.testReadings != null)
                                  Text('Test: ${log.testReadings}'),
                              ],
                            ),
                            trailing: Chip(
                              label: Text(log.status, style: const TextStyle(fontSize: 11)),
                              visualDensity: VisualDensity.compact,
                              backgroundColor: log.status == 'VERIFIED'
                                  ? Colors.green.withOpacity(0.15)
                                  : null,
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
