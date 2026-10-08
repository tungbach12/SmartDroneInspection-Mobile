import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/maintenance_task.dart';
import 'package:smart_drone_inspection/features/tasks/presentation/providers/maintenance_task_providers.dart';
import 'package:smart_drone_inspection/features/tasks/presentation/task_detail_page.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(maintenanceTaskListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Tasks (MF5)')),
      body: AsyncValueWidget<List<MaintenanceTask>>(
        value: tasksAsync,
        onRetry: () => ref.invalidate(maintenanceTaskListProvider),
        emptyCheck: (tasks) => tasks.isEmpty,
        builder: (tasks) => ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              elevation: 1,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.build_outlined),
                ),
                title: Text('Task #${task.id.substring(0, 8)} (${task.assignmentType})'),
                subtitle: Text('Ticket: ${task.maintenanceTicketId.substring(0, 8)}\nDeadline: ${task.deadline ?? 'Not set'}'),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TaskDetailPage(task: task),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
