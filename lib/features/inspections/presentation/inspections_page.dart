import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspector_assignment.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/assignment_inbox_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

/// The Inspector's entry point to MF2: the pairings an administrator opened and the Inspector has
/// not yet answered.
///
/// Accepting records that the Inspector took the job. It is not flight clearance — MF2-07 decides
/// separately, from the paperwork, whether a mission may fly. The screen says so, because an
/// "Accepted" label that reads as permission is contradicted by the server two steps later.
class InspectionsPage extends ConsumerWidget {
  const InspectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignments = ref.watch(assignmentInboxProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: AsyncValueWidget<List<InspectorAssignment>>(
        value: assignments,
        onRetry: () => ref.invalidate(assignmentInboxProvider),
        builder: (items) {
          final open = items.where((item) => item.isOpen).toList();
          return RefreshIndicator(
            onRefresh: () => ref.refresh(assignmentInboxProvider.future),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Accepting records that you took the work. It does not mean the mission may fly: '
                  'a named organization reviewer decides that from the paperwork.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                if (open.isEmpty)
                  const _EmptyInbox()
                else
                  for (final assignment in open)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AssignmentCard(assignment: assignment),
                    ),
                for (final assignment in items.where((item) => !item.isOpen))
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.history, size: 20),
                    title: Text(assignment.assetName),
                    subtitle: Text(
                      assignment.reason ??
                          assignment.assignmentResponse ??
                          assignment.status,
                    ),
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
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.inbox_outlined, size: 40),
        const SizedBox(height: 8),
        Text(
          'Nothing to answer. An organization administrator pairs you with a Drone before '
          'preparation can start.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _AssignmentCard extends ConsumerStatefulWidget {
  const _AssignmentCard({required this.assignment});

  final InspectorAssignment assignment;

  @override
  ConsumerState<_AssignmentCard> createState() => _AssignmentCardState();
}

class _AssignmentCardState extends ConsumerState<_AssignmentCard> {
  final _reasonController = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _respond(String response) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref
        .read(inspectionRepositoryProvider)
        .respondToAssignment(
          assignmentId: widget.assignment.id,
          response: response,
          rejectionReason: response == 'REJECTED'
              ? _reasonController.text.trim()
              : null,
        );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess():
        setState(() {
          _busy = false;
          _reasonController.clear();
        });
        // The server decides which rows leave the inbox: a decline suspends the pairing and both
        // outcomes change what the server would return next.
        ref.invalidate(assignmentInboxProvider);
      case ApiError(:final failure):
        setState(() {
          _busy = false;
          _error = switch (failure) {
            ServerFailure(:final detail) =>
              detail ?? 'The server refused this response.',
            UnauthorizedFailure() =>
              'You are not allowed to answer this assignment.',
            NotFoundFailure() => 'This assignment was not found, or it belongs to another organization.',
            _ => failure.toString(),
          };
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignment = widget.assignment;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.assetName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Drone ${assignment.droneSerialNumber} · valid from '
              '${_day(assignment.validFrom)} to ${_day(assignment.validUntil)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('decline-reason'),
              controller: _reasonController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Reason for declining',
                helperText: 'Required only when declining, so an administrator knows what to fix.',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: _busy ? null : () => _respond('ACCEPTED'),
                  child: Text(_busy ? 'Recording…' : 'Accept'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _busy || _reasonController.text.trim().isEmpty
                      ? null
                      : () => _respond('REJECTED'),
                  child: const Text('Decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _day(String? iso) => iso == null ? 'unspecified' : iso.substring(0, 10);
