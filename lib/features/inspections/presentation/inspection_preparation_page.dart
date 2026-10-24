import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_preparation.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/field_session_provider.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_preparation_provider.dart';

class InspectionPreparationPage extends ConsumerStatefulWidget {
  const InspectionPreparationPage({required this.inspectionId, super.key});

  final String inspectionId;

  @override
  ConsumerState<InspectionPreparationPage> createState() =>
      _InspectionPreparationPageState();
}

class _InspectionPreparationPageState
    extends ConsumerState<InspectionPreparationPage> {
  final _shotList = TextEditingController();
  final _evidenceTypes = TextEditingController();
  final _accessConstraints = TextEditingController();
  final _safetyObservations = TextEditingController();
  final _plannedStart = TextEditingController();
  final _plannedEnd = TextEditingController();
  final _acknowledgment = TextEditingController();
  final _additionalSessionReason = TextEditingController();
  String? _initializedFor;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _shotList.dispose();
    _evidenceTypes.dispose();
    _accessConstraints.dispose();
    _safetyObservations.dispose();
    _plannedStart.dispose();
    _plannedEnd.dispose();
    _acknowledgment.dispose();
    _additionalSessionReason.dispose();
    super.dispose();
  }

  void _seed(InspectionPreparation? current) {
    if (current == null || _initializedFor == current.id) return;
    _initializedFor = current.id;
    _shotList.text = current.shotList;
    _evidenceTypes.text = current.evidenceTypes ?? '';
    _accessConstraints.text = current.accessConstraints ?? '';
    _safetyObservations.text = current.safetyObservations ?? '';
    _plannedStart.text = _localDateTime(current.plannedStartAt);
    _plannedEnd.text = _localDateTime(current.plannedEndAt);
  }

  String _localDateTime(DateTime? value) {
    if (value == null) return '';
    final local = value.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}T${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  DateTime? _parseDateTime(String value) =>
      value.trim().isEmpty ? null : DateTime.tryParse(value.trim());

  Future<void> _save() async {
    final preparations = ref.read(
      inspectionPreparationsProvider(widget.inspectionId),
    );
    final current = preparations.asData?.value.firstOrNull;
    setState(() {
      _busy = true;
      _error = null;
    });
    final isAdditionalSession = (current?.preparationVersion ?? 1) > 1;
    final start = _parseDateTime(_plannedStart.text);
    final end = _parseDateTime(_plannedEnd.text);
    if (isAdditionalSession && (start == null || end == null)) {
      setState(() {
        _busy = false;
        _error = context.l10n.bothPlannedTimes;
      });
      return;
    }
    final result = await ref
        .read(inspectionRepositoryProvider)
        .savePreparation(
          inspectionId: widget.inspectionId,
          shotList: _shotList.text.trim(),
          evidenceTypes: _evidenceTypes.text.trim().isEmpty
              ? null
              : _evidenceTypes.text.trim(),
          accessConstraints: _accessConstraints.text.trim().isEmpty
              ? null
              : _accessConstraints.text.trim(),
          safetyObservations: _safetyObservations.text.trim().isEmpty
              ? null
              : _safetyObservations.text.trim(),
          plannedStartAt: isAdditionalSession ? start : null,
          plannedEndAt: isAdditionalSession ? end : null,
        );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<InspectionPreparation>(:final data):
        setState(() {
          _busy = false;
          _initializedFor = null;
          _error = null;
        });
        ref.invalidate(inspectionPreparationsProvider(widget.inspectionId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.preparationVersionSaved(
                data.preparationVersion.toString(),
              ),
            ),
          ),
        );
      case ApiError<InspectionPreparation>(:final failure):
        setState(() {
          _busy = false;
          _error = _failureText(failure);
        });
    }
  }

  Future<void> _requestAdditionalSession() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref
        .read(inspectionRepositoryProvider)
        .requestAdditionalSession(
          inspectionId: widget.inspectionId,
          reason: _additionalSessionReason.text.trim(),
        );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<InspectionPreparation>(:final data):
        setState(() {
          _busy = false;
          _initializedFor = null;
          _additionalSessionReason.clear();
        });
        ref.invalidate(inspectionPreparationsProvider(widget.inspectionId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Additional field session requested. Preparation version ${data.preparationVersion} is ready to update.',
            ),
          ),
        );
      case ApiError<InspectionPreparation>(:final failure):
        setState(() {
          _busy = false;
          _error = _failureText(failure);
        });
    }
  }

  Future<void> _submit(InspectionPreparation preparation) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref
        .read(inspectionRepositoryProvider)
        .submitPreparation(
          inspectionId: widget.inspectionId,
          preparationId: preparation.id,
          acknowledgment: _acknowledgment.text.trim(),
        );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<InspectionPreparation>():
        setState(() => _busy = false);
        ref.invalidate(inspectionPreparationsProvider(widget.inspectionId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.preparationSubmitted)),
        );
      case ApiError<InspectionPreparation>(:final failure):
        setState(() {
          _busy = false;
          _error = _failureText(failure);
        });
    }
  }

  String _failureText(ApiFailure failure) => switch (failure) {
    ValidationFailure(:final errors) => errors.values.join('\n'),
    ServerFailure(:final detail) =>
      detail ?? context.l10n.preparationServerRefused,
    NetworkFailure() => context.l10n.networkRetry,
    UnauthorizedFailure() => context.l10n.cannotEditPreparation,
    NotFoundFailure() => context.l10n.inspectionNotInOrganization,
    UnknownFailure(:final message) => message,
  };

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(
      inspectionPreparationsProvider(widget.inspectionId),
    );
    final current = query.asData?.value.firstOrNull;
    final sessions = ref.watch(fieldSessionsProvider(widget.inspectionId));
    final evidence = ref.watch(inspectionEvidenceProvider(widget.inspectionId));
    _seed(current);
    final isAdditionalSession = (current?.preparationVersion ?? 1) > 1;
    final latestCompletedSession = sessions.asData?.value
        .where((session) => session.isCompleted)
        .lastOrNull;
    final hasActiveEvidence =
        evidence.asData?.value.any(
          (item) =>
              item.fieldSessionId == latestCompletedSession?.id &&
              !item.isDeleted,
        ) ??
        false;
    final canRequestAdditionalSession =
        current?.status == 'READY' &&
        latestCompletedSession != null &&
        hasActiveEvidence;
    final editable = current?.status == 'DRAFT' || current == null;
    final submitted = current?.status == 'SUBMITTED';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(context.l10n.preparation),
      ),
      body: AsyncValueWidget<List<InspectionPreparation>>(
        value: query,
        onRetry: () =>
            ref.invalidate(inspectionPreparationsProvider(widget.inspectionId)),
        builder: (_) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (isAdditionalSession)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(context.l10n.additionalSessionRequested),
                ),
              ),
            if (current != null)
              Text(
                context.l10n.preparationVersionStatus(
                  current.preparationVersion.toString(),
                  localizedWorkflowStatus(
                    context.l10n,
                    current.status ?? 'DRAFT',
                  ),
                ),
              ),
            if (sessions.isLoading || evidence.isLoading)
              const Text('Checking completed session and active evidence…'),
            if (sessions.hasError || evidence.hasError) ...[
              const Text(
                'Could not verify field-session evidence. Refresh before requesting another session.',
              ),
              TextButton(
                onPressed: () {
                  ref.invalidate(fieldSessionsProvider(widget.inspectionId));
                  ref.invalidate(
                    inspectionEvidenceProvider(widget.inspectionId),
                  );
                },
                child: const Text('Refresh session and evidence'),
              ),
            ],
            if (canRequestAdditionalSession) ...[
              const SizedBox(height: 12),
              TextField(
                key: const Key('additional-session-reason'),
                controller: _additionalSessionReason,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Why is another field session needed?',
                  helperText: 'Use this after the completed field session when its active evidence does not cover the required scope.',
                ),
                maxLines: 2,
              ),
              FilledButton.tonal(
                onPressed: _busy || _additionalSessionReason.text.trim().isEmpty
                    ? null
                    : _requestAdditionalSession,
                child: Text(
                  _busy ? 'Requesting…' : 'Request additional field session',
                ),
              ),
            ],
            TextField(
              controller: _shotList,
              decoration: InputDecoration(
                labelText: context.l10n.componentShotListJson,
              ),
              maxLines: 4,
              enabled: editable,
            ),
            TextField(
              controller: _evidenceTypes,
              decoration: InputDecoration(
                labelText: context.l10n.evidenceTypesJson,
              ),
              enabled: editable,
            ),
            TextField(
              controller: _accessConstraints,
              decoration: InputDecoration(
                labelText: context.l10n.accessConstraints,
              ),
              maxLines: 2,
              enabled: editable,
            ),
            if (isAdditionalSession) ...[
              TextField(
                controller: _plannedStart,
                decoration: InputDecoration(
                  labelText: context.l10n.plannedSessionStart,
                ),
                keyboardType: TextInputType.datetime,
                enabled: editable,
              ),
              TextField(
                controller: _plannedEnd,
                decoration: InputDecoration(
                  labelText: context.l10n.plannedSessionEnd,
                ),
                keyboardType: TextInputType.datetime,
                enabled: editable,
              ),
            ],
            TextField(
              controller: _safetyObservations,
              decoration: InputDecoration(
                labelText: context.l10n.safetyObservations,
              ),
              maxLines: 2,
              enabled: editable,
            ),
            if (editable)
              FilledButton(
                onPressed: _busy ? null : _save,
                child: Text(
                  _busy ? context.l10n.saving : context.l10n.saveDraft,
                ),
              ),
            if (submitted) ...[
              TextField(
                controller: _acknowledgment,
                decoration: InputDecoration(
                  labelText: context.l10n.safetyAcknowledgment,
                ),
              ),
              FilledButton(
                onPressed: _busy ? null : () => _submit(current!),
                child: Text(
                  _busy
                      ? context.l10n.submitting
                      : context.l10n.submitPreparation,
                ),
              ),
            ],
            if (current?.status == 'READY')
              Text(context.l10n.preparationApproved),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
