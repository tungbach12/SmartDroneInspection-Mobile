import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_work_order.dart';
import 'package:smart_drone_inspection/features/tasks/presentation/providers/maintenance_providers.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workOrdersAsync = ref.watch(maintenanceWorkOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.tasks),
      ),
      body: AsyncValueWidget<List<MobileWorkOrder>>(
        value: workOrdersAsync,
        onRetry: () => ref.invalidate(maintenanceWorkOrdersProvider),
        builder: (orders) {
          if (orders.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(maintenanceWorkOrdersProvider.future),
              child: ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.build_circle_outlined, size: 56, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.noAssignedTasks,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.assignedWorkOrdersDescription,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(maintenanceWorkOrdersProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      context.push('/tasks/${order.id}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.workOrderTitle(order.id.substring(0, 8)),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  order.status,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            order.correctiveScope,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.flag_outlined, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    order.priority,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: order.priority == 'CRITICAL' || order.priority == 'HIGH'
                                          ? Theme.of(context).colorScheme.error
                                          : Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
