import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspections_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

/// The Inspector's inspection list: displays all inspections assigned to the inspector.
/// Tapping an inspection navigates to `/inspection/:inspectionId`.
class InspectionsPage extends ConsumerWidget {
  const InspectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspections = ref.watch(inspectionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navInspections)),
      body: AsyncValueWidget<List<Inspection>>(
        value: inspections,
        onRetry: () => ref.invalidate(inspectionsProvider),
        builder: (items) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(inspectionsProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (items.isEmpty)
                  const _EmptyInbox(message: 'No inspections assigned.')
                else
                  for (final inspection in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _InspectionCard(inspection: inspection),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            const Icon(Icons.inbox_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _InspectionCard extends StatelessWidget {
  const _InspectionCard({required this.inspection});

  final Inspection inspection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final droneInfo = inspection.droneModel != null ||
            inspection.droneSerialNumber != null
        ? '${inspection.droneModel ?? ""} (${inspection.droneSerialNumber ?? ""})'.trim()
        : 'Drone not assigned';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/inspection/${inspection.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      inspection.assetName ?? 'Asset #${inspection.assetId}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  _StatusChip(status: inspection.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.flight, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      droneInfo,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              if (inspection.hasFlightPermit) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.verified_outlined, size: 16, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      inspection.flightPermitFileName ?? 'Permit attached',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'ASSIGNED' => ('Assigned', Colors.orange),
      'READY_FOR_FLIGHT' => ('Ready for Flight', Colors.blue),
      'IN_PROGRESS' => ('In Progress', Colors.teal),
      'FIELD_COMPLETED' => ('Completed', Colors.green),
      _ => (status, Colors.grey),
    };

    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text(label, style: TextStyle(fontSize: 12, color: color.shade900)),
      backgroundColor: color.shade50,
      side: BorderSide(color: color.shade300),
    );
  }
}
