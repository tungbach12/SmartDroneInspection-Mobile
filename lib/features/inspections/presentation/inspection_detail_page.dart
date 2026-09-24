import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_checklist_item.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

class InspectionDetailPage extends ConsumerStatefulWidget {
  const InspectionDetailPage({required this.inspectionId, super.key});

  final String inspectionId;

  @override
  ConsumerState<InspectionDetailPage> createState() =>
      _InspectionDetailPageState();
}

class _InspectionDetailPageState extends ConsumerState<InspectionDetailPage> {
  XFile? _selectedPhoto;
  DateTime? _captureTime;
  bool _uploading = false;
  String? _uploadError;
  String? _operationError;
  String? _savingItemId;
  final Set<String> _savedItemIds = {};

  Future<void> _capturePhoto() async {
    setState(() {
      _uploadError = null;
      _operationError = null;
    });
    try {
      final photo = await ref.read(inspectionPhotoPickerProvider)();
      if (!mounted || photo == null) return;
      setState(() {
        _selectedPhoto = photo;
        _captureTime = DateTime.now().toUtc();
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        _operationError = 'Camera could not be opened. Check device permission and try again.';
      });
    }
  }

  Future<void> _uploadPhoto() async {
    final photo = _selectedPhoto;
    final captureTime = _captureTime;
    if (photo == null || captureTime == null) return;
    setState(() {
      _uploading = true;
      _uploadError = null;
      _operationError = null;
    });
    final result = await ref
        .read(inspectionRepositoryProvider)
        .uploadEvidence(
          inspectionId: widget.inspectionId,
          photo: photo,
          captureTime: captureTime,
        );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<InspectionEvidence>():
        ref.invalidate(inspectionEvidenceProvider(widget.inspectionId));
        setState(() {
          _selectedPhoto = null;
          _captureTime = null;
          _uploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evidence uploaded securely.')),
        );
      case ApiError<InspectionEvidence>(:final failure):
        setState(() {
          _uploading = false;
          _uploadError = _failureMessage(failure);
        });
    }
  }

  Future<void> _saveChecklist(
    InspectionChecklistItem item,
    Map<String, dynamic> responseValue,
    String? notes,
  ) async {
    setState(() {
      _savingItemId = item.itemId;
      _operationError = null;
    });
    final result = await ref
        .read(inspectionRepositoryProvider)
        .saveChecklistResponse(
          inspectionId: widget.inspectionId,
          itemId: item.itemId,
          responseValue: responseValue,
          notes: notes,
        );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<void>():
        ref.invalidate(inspectionChecklistProvider(widget.inspectionId));
        setState(() {
          _savingItemId = null;
          _savedItemIds.add(item.itemId);
        });
      case ApiError<void>(:final failure):
        setState(() {
          _savingItemId = null;
          _operationError =
              'Checklist was not saved: ${_failureMessage(failure)}';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final checklist = ref.watch(
      inspectionChecklistProvider(widget.inspectionId),
    );
    final evidence = ref.watch(inspectionEvidenceProvider(widget.inspectionId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to assignments',
        ),
        title: const Text('Inspection record'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(inspectionChecklistProvider(widget.inspectionId));
          ref.invalidate(inspectionEvidenceProvider(widget.inspectionId));
          await Future.wait([
            ref.read(inspectionChecklistProvider(widget.inspectionId).future),
            ref.read(inspectionEvidenceProvider(widget.inspectionId).future),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Inspection ${widget.inspectionId.substring(0, 8)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (_operationError != null) ...[
              const SizedBox(height: 12),
              _InlineError(message: _operationError!),
            ],
            const SizedBox(height: 16),
            Text('Checklist', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            AsyncValueWidget<List<InspectionChecklistItem>>(
              value: checklist,
              onRetry: () => ref.invalidate(
                inspectionChecklistProvider(widget.inspectionId),
              ),
              emptyCheck: (items) => items.isEmpty,
              builder: (items) => Column(
                children: items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ChecklistItemCard(
                          item: item,
                          isSaving: _savingItemId == item.itemId,
                          isSaved: _savedItemIds.contains(item.itemId),
                          onSave: (value, notes) =>
                              _saveChecklist(item, value, notes),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Evidence', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _uploading ? null : _capturePhoto,
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Capture inspection photo'),
                    ),
                    if (_selectedPhoto != null) ...[
                      const SizedBox(height: 8),
                      Text('Selected: ${_selectedPhoto!.name}'),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: _uploading ? null : _uploadPhoto,
                        icon: const Icon(Icons.cloud_upload_outlined),
                        label: Text(
                          _uploading
                              ? 'Uploading…'
                              : _uploadError == null
                              ? 'Upload photo'
                              : 'Retry upload',
                        ),
                      ),
                    ],
                    if (_uploadError != null) ...[
                      const SizedBox(height: 8),
                      _InlineError(
                        message:
                            'Upload failed: $_uploadError. The selected photo is kept so you can retry.',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            AsyncValueWidget<List<InspectionEvidence>>(
              value: evidence,
              onRetry: () => ref.invalidate(
                inspectionEvidenceProvider(widget.inspectionId),
              ),
              emptyCheck: (items) => items.isEmpty,
              builder: (items) => Card(
                child: Column(
                  children: items
                      .map(
                        (item) => ListTile(
                          leading: const Icon(Icons.image_outlined),
                          title: Text(item.fileName),
                          subtitle: Text(
                            '${item.contentType} · ${item.sizeBytes} bytes · ${item.source}',
                          ),
                          trailing: const Icon(Icons.verified_user_outlined),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistItemCard extends StatefulWidget {
  const _ChecklistItemCard({
    required this.item,
    required this.isSaving,
    required this.isSaved,
    required this.onSave,
  });

  final InspectionChecklistItem item;
  final bool isSaving;
  final bool isSaved;
  final Future<void> Function(Map<String, dynamic> value, String? notes) onSave;

  @override
  State<_ChecklistItemCard> createState() => _ChecklistItemCardState();
}

class _ChecklistItemCardState extends State<_ChecklistItemCard> {
  late final TextEditingController _answer;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    final initial = widget.item.responseValue?['value'];
    _answer = TextEditingController(text: initial?.toString() ?? '');
    _notes = TextEditingController(text: widget.item.notes ?? '');
  }

  @override
  void dispose() {
    _answer.dispose();
    _notes.dispose();
    super.dispose();
  }

  List<String> _choiceOptions() {
    if (widget.item.responseType == 'PASS_FAIL') return ['PASS', 'FAIL'];
    if (widget.item.responseType == 'BOOLEAN') return ['true', 'false'];
    if (widget.item.responseType != 'CHOICE' ||
        widget.item.validationConfig == null) {
      return const [];
    }
    try {
      final decoded = jsonDecode(widget.item.validationConfig!);
      final choices = decoded is Map ? decoded['choices'] : null;
      return choices is List ? choices.whereType<String>().toList() : const [];
    } on FormatException {
      return const [];
    }
  }

  Map<String, dynamic>? _value() {
    final text = _answer.text.trim();
    if (text.isEmpty) return null;
    return switch (widget.item.responseType) {
      'NUMBER' =>
        num.tryParse(text) == null ? null : {'value': num.parse(text)},
      'BOOLEAN' => {'value': text == 'true'},
      _ => {'value': text},
    };
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final choices = _choiceOptions();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.itemCode}${item.required ? ' *' : ''}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(item.prompt),
            if (item.guidance != null && item.guidance!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                item.guidance!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            if (choices.isNotEmpty)
              DropdownButtonFormField<String>(
                initialValue: _answer.text.isEmpty ? null : _answer.text,
                decoration: const InputDecoration(labelText: 'Response'),
                items: choices
                    .map(
                      (choice) => DropdownMenuItem(
                        value: choice,
                        child: Text(
                          choice == 'true'
                              ? 'Yes'
                              : choice == 'false'
                              ? 'No'
                              : choice,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: widget.isSaving
                    ? null
                    : (value) => setState(() => _answer.text = value ?? ''),
              )
            else
              TextField(
                controller: _answer,
                keyboardType: item.responseType == 'NUMBER'
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.text,
                decoration: InputDecoration(
                  labelText: item.responseType == 'NUMBER'
                      ? 'Numeric response'
                      : 'Response',
                ),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: _notes,
              maxLength: 4000,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 3,
            ),
            Row(
              children: [
                FilledButton.tonal(
                  onPressed: widget.isSaving
                      ? null
                      : () {
                          final value = _value();
                          if (item.required && value == null) return;
                          if (value != null) {
                            widget.onSave(value, _notes.text.trim());
                          }
                        },
                  child: Text(widget.isSaving ? 'Saving…' : 'Save response'),
                ),
                if (widget.isSaved) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle_outline, color: Colors.green),
                  const SizedBox(width: 4),
                  const Text('Saved'),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Text(
      message,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    ),
  );
}

String _failureMessage(ApiFailure failure) => switch (failure) {
  NetworkFailure() => 'Check your connection and try again.',
  ValidationFailure(:final errors) => errors.values.join(' '),
  UnauthorizedFailure() => 'You are not authorized to access this inspection.',
  NotFoundFailure() => 'This inspection is no longer available.',
  ServerFailure(:final detail) =>
    detail ?? 'The server could not complete this request.',
  UnknownFailure(:final message) => message,
};
