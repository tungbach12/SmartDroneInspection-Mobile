import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
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
      appBar: AppBar(title: Text(context.l10n.assignments)),
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
                  context.l10n.acceptingDoesNotClear,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                if (open.isEmpty)
                  _EmptyInbox(message: context.l10n.nothingToAnswer)
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
                          (assignment.assignmentResponse != null
                              ? localizedAssignmentResponse(
                                  context.l10n,
                                  assignment.assignmentResponse!,
                                )
                              : localizedAssignmentStatus(
                                  context.l10n,
                                  assignment.status,
                                )),
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
  const _EmptyInbox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.inbox_outlined, size: 40),
        const SizedBox(height: 8),
        Text(
          message,
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
              detail ?? context.l10n.serverRefusedResponse,
            UnauthorizedFailure() => context.l10n.cannotAnswerAssignment,
            NotFoundFailure() => context.l10n.assignmentNotFound,
            _ => context.l10n.somethingWentWrong,
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
              context.l10n.droneValidity(
                assignment.droneSerialNumber,
                _day(context, assignment.validFrom),
                _day(context, assignment.validUntil),
              ),
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
              decoration: InputDecoration(
                labelText: context.l10n.declineReason,
                helperText: context.l10n.declineReasonHint,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: _busy ? null : () => _respond('ACCEPTED'),
                  child: Text(
                    _busy ? context.l10n.recording : context.l10n.accept,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _busy || _reasonController.text.trim().isEmpty
                      ? null
                      : () => _respond('REJECTED'),
                  child: Text(context.l10n.decline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _day(BuildContext context, String? iso) =>
    iso == null ? context.l10n.unspecified : iso.substring(0, 10);
