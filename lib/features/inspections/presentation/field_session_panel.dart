import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/field_session_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

/// The session statuses the server can return, as the Inspector reads them.
///
/// The wire vocabulary is uppercase; showing it raw is fine but inconsistent with the rest of the
/// app, which capitalises statuses for display.
String _label(String status) => switch (status) {
  'IN_PROGRESS' => 'In progress',
  'POSTPONED' => 'Postponed',
  'ABORTED' => 'Aborted',
  'PLANNED' => 'Planned',
  'FIELD_COMPLETED' => 'Field completed',
  _ => status,
};

/// MF2-09 to MF2-11 on site: start, postpone or abort the field session.
///
/// The pre-flight note is typed rather than ticked. MF2-09 has the Inspector identify the assigned
/// Drone and complete the current pre-flight checklist before asking to start, and a checkbox a
/// client can set without reading anything would attest to nothing.
///
/// An abort asks for confirmation before it fires. A mistaken tap on a phone in the field ends a
/// session that cannot resume, so the extra tap is cheaper than the mistake.
///
/// Nothing here arms a Drone. Starting records that the software agreed the paperwork and the
/// pre-flight checklist were in order; the session start time is not hardware flight time.
class FieldSessionPanel extends ConsumerStatefulWidget {
  const FieldSessionPanel({required this.inspectionId, super.key});

  final String inspectionId;

  @override
  ConsumerState<FieldSessionPanel> createState() => _FieldSessionPanelState();
}

class _FieldSessionPanelState extends ConsumerState<FieldSessionPanel> {
  final _noteController = TextEditingController();
  final _postponeController = TextEditingController();
  final _abortController = TextEditingController();

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _noteController.dispose();
    _postponeController.dispose();
    _abortController.dispose();
    super.dispose();
  }

  void _setError(ApiFailure failure) {
    setState(() {
      _busy = false;
      _error = switch (failure) {
        ValidationFailure(:final errors) => errors.values.join('\n'),
        UnauthorizedFailure() =>
          'You are not allowed to manage this field session.',
        NotFoundFailure() => 'This inspection was not found, or it belongs to another organization.',
        ServerFailure(:final detail) =>
          detail ?? 'The server refused this request.',
        NetworkFailure() => 'The network is unavailable. The note you typed is kept, so try again.',
        UnknownFailure(:final message) => message,
      };
    });
  }

  Future<void> _run(Future<ApiResult<FieldSession>> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await action();
    if (!mounted) return;
    switch (result) {
      case ApiSuccess():
        setState(() {
          _busy = false;
          _noteController.clear();
          _postponeController.clear();
          _abortController.clear();
        });
        ref.invalidate(fieldSessionsProvider(widget.inspectionId));
      case ApiError(:final failure):
        _setError(failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(fieldSessionsProvider(widget.inspectionId));
    final repository = ref.read(inspectionRepositoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Field session',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Starting a session is not flight clearance. It records that the paperwork and the '
              'pre-flight checklist were in order.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            AsyncValueWidget<List<FieldSession>>(
              value: sessions,
              onRetry: () =>
                  ref.invalidate(fieldSessionsProvider(widget.inspectionId)),
              builder: (data) {
                final open = data.where((s) => s.isOpen).firstOrNull;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (open != null)
                      _OpenSession(
                        session: open,
                        busy: _busy,
                        postponeController: _postponeController,
                        abortController: _abortController,
                        onChanged: () => setState(() {}),
                        onPostpone: () => _run(
                          () => repository.postponeFieldSession(
                            inspectionId: widget.inspectionId,
                            sessionId: open.id,
                            reason: _postponeController.text.trim(),
                          ),
                        ),
                        onAbort: () => _run(
                          () => repository.abortFieldSession(
                            inspectionId: widget.inspectionId,
                            sessionId: open.id,
                            reason: _abortController.text.trim(),
                          ),
                        ),
                      )
                    else
                      _PreFlightForm(
                        controller: _noteController,
                        busy: _busy,
                        onChanged: () => setState(() {}),
                        onStart: () => _run(
                          () => repository.startFieldSession(
                            inspectionId: widget.inspectionId,
                            checklistTemplateId: null,
                            preFlightChecklistNote: _noteController.text.trim(),
                          ),
                        ),
                      ),
                    for (final session in data.where((s) => !s.isOpen))
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Chip(label: Text(_label(session.status))),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                session.postponementReason ??
                                    session.abortReason ??
                                    session.status,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PreFlightForm extends StatelessWidget {
  const _PreFlightForm({
    required this.controller,
    required this.busy,
    required this.onChanged,
    required this.onStart,
  });

  final TextEditingController controller;
  final bool busy;
  final VoidCallback onChanged;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('pre-flight-note'),
          controller: controller,
          maxLines: 3,
          // The start button depends on this field having content, so typing has to rebuild it.
          onChanged: (_) => onChanged(),
          decoration: const InputDecoration(
            labelText: 'Pre-flight checklist note',
            helperText: 'Identify the assigned Drone and record what you checked on site.',
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: busy || controller.text.trim().isEmpty ? null : onStart,
          child: Text(busy ? 'Starting…' : 'Start field session'),
        ),
      ],
    );
  }
}

class _OpenSession extends StatelessWidget {
  const _OpenSession({
    required this.session,
    required this.busy,
    required this.postponeController,
    required this.abortController,
    required this.onChanged,
    required this.onPostpone,
    required this.onAbort,
  });

  final FieldSession session;
  final bool busy;
  final TextEditingController postponeController;
  final TextEditingController abortController;
  final VoidCallback onChanged;
  final VoidCallback onPostpone;
  final VoidCallback onAbort;

  /// A mistaken tap on a phone in the field would end a session that cannot resume, so aborting
  /// asks once more. A postponement needs no confirmation because it hands the inspection back.
  Future<void> _confirmAbort(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Abort this session?'),
        content: const Text(
          'The session ends and will not resume under this record. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep going'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Abort'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      onAbort();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Chip(label: Text(_label(session.status))),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Started ${session.startedAt ?? 'just now'} against readiness decision '
                '${session.readinessDecisionId ?? 'unknown'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('postpone-reason'),
          controller: postponeController,
          onChanged: (_) => onChanged(),
          decoration: const InputDecoration(
            labelText: 'Reason for postponing',
            helperText:
                'Weather or site safety. The mission can be attempted again.',
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: busy || postponeController.text.trim().isEmpty
              ? null
              : onPostpone,
          child: const Text('Postpone'),
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('abort-reason'),
          controller: abortController,
          onChanged: (_) => onChanged(),
          decoration: const InputDecoration(
            labelText: 'Reason for aborting',
            helperText:
                'This session ends and will not resume under this record.',
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: busy || abortController.text.trim().isEmpty
              ? null
              : () => _confirmAbort(context),
          child: const Text('Abort session'),
        ),
      ],
    );
  }
}
