import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
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
String _label(BuildContext context, String status) =>
    localizedFieldSessionStatus(context.l10n, status);

/// MF2-09 to MF2-12 on site: start, postpone, abort or normally complete the field session.
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
  final _outcomeController = TextEditingController();

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _noteController.dispose();
    _postponeController.dispose();
    _abortController.dispose();
    _outcomeController.dispose();
    super.dispose();
  }

  void _setError(ApiFailure failure) {
    setState(() {
      _busy = false;
      _error = switch (failure) {
        ValidationFailure(:final errors) => errors.values.join('\n'),
        UnauthorizedFailure() => context.l10n.cannotManageSession,
        NotFoundFailure() => context.l10n.inspectionUnavailable,
        ServerFailure(:final detail) =>
          detail ?? context.l10n.preparationServerRefused,
        NetworkFailure() => context.l10n.networkUnavailable,
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
          _outcomeController.clear();
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.fieldSession,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.startingNotClearance,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              AsyncValueWidget<List<FieldSession>>(
                value: sessions,
                onRetry: () =>
                    ref.invalidate(fieldSessionsProvider(widget.inspectionId)),
                builder: (data) {
                  final open = data.where((s) => s.isOpen).firstOrNull;
                  final latest = data.isEmpty ? null : data.last;
                  final sessionToClose = open;
                  // A session can start if there is no open session and either this is the first session,
                  // or the previous session was postponed or completed (allowing additional visits).
                  final canOfferStart = sessionToClose == null &&
                      (data.isEmpty ||
                          latest?.isPostponed == true ||
                          latest?.isCompleted == true);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (sessionToClose != null)
                        _OpenSession(
                          session: sessionToClose,
                          busy: _busy,
                          postponeController: _postponeController,
                          abortController: _abortController,
                          outcomeController: _outcomeController,
                          onChanged: () => setState(() {}),
                          onPostpone: () => _run(
                            () => repository.postponeFieldSession(
                              inspectionId: widget.inspectionId,
                              sessionId: sessionToClose.id,
                              reason: _postponeController.text.trim(),
                            ),
                          ),
                          onAbort: () => _run(
                            () => repository.abortFieldSession(
                              inspectionId: widget.inspectionId,
                              sessionId: sessionToClose.id,
                              reason: _abortController.text.trim(),
                            ),
                          ),
                          onComplete: () => _run(
                            () => repository.completeFieldSession(
                              inspectionId: widget.inspectionId,
                              sessionId: sessionToClose.id,
                              outcomeNotes: _outcomeController.text.trim(),
                            ),
                          ),
                        )
                      else if (canOfferStart)
                        _PreFlightForm(
                          controller: _noteController,
                          busy: _busy,
                          onChanged: () => setState(() {}),
                          onStart: () => _run(
                            () => repository.startFieldSession(
                              inspectionId: widget.inspectionId,
                              preFlightChecklistNote: _noteController.text
                                  .trim(),
                            ),
                          ),
                        ),
                      if (!canOfferStart && sessionToClose == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(context.l10n.notStartable),
                        ),
                      for (final session in data.where(
                        (s) => !s.isOpen && s.id != sessionToClose?.id,
                      ))
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Chip(
                                label: Text(_label(context, session.status)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  session.postponementReason ??
                                      session.abortReason ??
                                      session.outcomeNotes ??
                                      '',
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
          decoration: InputDecoration(
            labelText: context.l10n.preFlightChecklistNote,
            helperText: context.l10n.preFlightChecklistHint,
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: busy || controller.text.trim().isEmpty ? null : onStart,
          child: Text(
            busy ? context.l10n.starting : context.l10n.startFieldSession,
          ),
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
    required this.outcomeController,
    required this.onChanged,
    required this.onPostpone,
    required this.onAbort,
    required this.onComplete,
  });

  final FieldSession session;
  final bool busy;
  final TextEditingController postponeController;
  final TextEditingController abortController;
  final TextEditingController outcomeController;
  final VoidCallback onChanged;
  final VoidCallback onPostpone;
  final VoidCallback onAbort;
  final VoidCallback onComplete;

  /// An aborted session is already closed, so only the completion outcome can still be recorded.
  bool get isOpen => session.isOpen;

  /// A mistaken tap on a phone in the field would end a session that cannot resume, so aborting
  /// asks once more. A postponement needs no confirmation because it hands the inspection back.
  Future<void> _confirmAbort(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.abortSessionQuestion),
        content: Text(context.l10n.abortIrreversible),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.keepGoing),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.abort),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(label: Text(_label(context, session.status))),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  session.startedAt != null
                      ? 'Started: ${session.startedAt}'
                      : context.l10n.justNow,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          if (isOpen) ...[
            const SizedBox(height: 16),
            TextField(
              key: const Key('postpone-reason'),
              controller: postponeController,
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                labelText: context.l10n.reasonPostponing,
                helperText: context.l10n.postponeHint,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: busy || postponeController.text.trim().isEmpty
                  ? null
                  : onPostpone,
              child: Text(context.l10n.postpone),
            ),
          ],
          const SizedBox(height: 16),
          // Normal completion ends the visit and hands the inspection back to MF3, so it is
          // offered before the abort control: aborting ends the session without a completed
          // coverage outcome.
          TextField(
            key: const Key('session-outcome'),
            controller: outcomeController,
            maxLines: 3,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              labelText: context.l10n.fieldSessionOutcome,
              helperText: context.l10n.fieldSessionOutcomeHint,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: busy || outcomeController.text.trim().isEmpty
                ? null
                : onComplete,
            child: Text(
              busy ? context.l10n.saving : context.l10n.endFieldSession,
            ),
          ),
          if (isOpen) ...[
            const SizedBox(height: 16),
            TextField(
              key: const Key('abort-reason'),
              controller: abortController,
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                labelText: context.l10n.reasonAborting,
                helperText: context.l10n.abortIrreversibleShort,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: busy || abortController.text.trim().isEmpty
                  ? null
                  : () => _confirmAbort(context),
              child: Text(context.l10n.abortSession),
            ),
          ],
        ],
      ),
    );
  }
}
