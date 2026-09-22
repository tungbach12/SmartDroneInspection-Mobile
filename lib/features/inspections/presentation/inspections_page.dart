import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_assignment.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_list_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

class InspectionsPage extends ConsumerWidget {
  const InspectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignments = ref.watch(inspectionListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inspections')),
      body: AsyncValueWidget<List<InspectionAssignment>>(
        value: assignments,
        onRetry: () => ref.invalidate(inspectionListProvider),
        emptyCheck: (items) => items.isEmpty,
        builder: (items) => RefreshIndicator(
          onRefresh: () => ref.refresh(inspectionListProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) => _InspectionAssignmentTile(
              assignment: items[index],
              onStart: () => ref
                  .read(inspectionListProvider.notifier)
                  .start(items[index].assignmentId),
            ),
          ),
        ),
      ),
    );
  }
}

class _InspectionAssignmentTile extends StatelessWidget {
  const _InspectionAssignmentTile({
    required this.assignment,
    required this.onStart,
  });

  final InspectionAssignment assignment;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final hasStarted = assignment.inspectionId != null;
    return ListTile(
      leading: const Icon(Icons.fact_check_outlined),
      title: Text('Asset ${assignment.assetId.substring(0, 8)}'),
      subtitle: Text(
        'Order ${assignment.serviceOrderId.substring(0, 8)}\n'
        '${assignment.deadline == null ? 'No deadline' : 'Due ${assignment.deadline}'}',
      ),
      isThreeLine: true,
      trailing: FilledButton(
        onPressed: onStart,
        child: Text(hasStarted ? 'Resume' : 'Start'),
      ),
    );
  }
}
