import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
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
  bool _uploadingPhoto = false;
  String? _photoUploadError;

  XFile? _selectedPermit;
  bool _uploadingPermit = false;
  String? _permitUploadError;
  String? _operationError;

  Future<void> _capturePhoto() async {
    setState(() {
      _photoUploadError = null;
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
        _operationError = context.l10n.cameraPermissionError;
      });
    }
  }

  Future<void> _uploadPhoto() async {
    final photo = _selectedPhoto;
    final captureTime = _captureTime;
    if (photo == null || captureTime == null) return;

    final sessionsResult = await ref
        .read(inspectionRepositoryProvider)
        .listFieldSessions(widget.inspectionId);
    if (!mounted) return;
    final completedSessionId = switch (sessionsResult) {
      ApiSuccess<List<FieldSession>>(:final data) =>
        data.where((session) => session.isCompleted).lastOrNull?.id,
      ApiError<List<FieldSession>>() => null,
    };
    if (completedSessionId == null) {
      setState(() {
        _photoUploadError = context.l10n.completeSessionBeforeEvidence;
      });
      return;
    }
    setState(() {
      _uploadingPhoto = true;
      _photoUploadError = null;
      _operationError = null;
    });
    final result = await ref
        .read(inspectionRepositoryProvider)
        .uploadEvidence(
          inspectionId: widget.inspectionId,
          photo: photo,
          captureTime: captureTime,
          fieldSessionId: completedSessionId,
        );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<InspectionEvidence>():
        ref.invalidate(inspectionEvidenceProvider(widget.inspectionId));
        setState(() {
          _selectedPhoto = null;
          _captureTime = null;
          _uploadingPhoto = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.evidenceUploaded)));
      case ApiError<InspectionEvidence>(:final failure):
        setState(() {
          _uploadingPhoto = false;
          _photoUploadError = _failureMessage(context, failure);
        });
    }
  }

  Future<void> _pickPermitFile() async {
    setState(() {
      _permitUploadError = null;
    });
    try {
      final file = await ref.read(flightPermitPickerProvider)();
      if (!mounted || file == null) return;
      setState(() {
        _selectedPermit = file;
      });
    } on Exception {
      if (!mounted) return;
      setState(() {
        _permitUploadError = 'Could not access file chooser.';
      });
    }
  }

  Future<void> _uploadPermit() async {
    final file = _selectedPermit;
    if (file == null) return;
    setState(() {
      _uploadingPermit = true;
      _permitUploadError = null;
    });
    final result = await ref
        .read(inspectionRepositoryProvider)
        .uploadFlightPermit(
          inspectionId: widget.inspectionId,
          file: file,
        );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<Inspection>():
        ref.invalidate(inspectionDetailProvider(widget.inspectionId));
        setState(() {
          _selectedPermit = null;
          _uploadingPermit = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Flight permit uploaded. Inspection ready for flight!'),
          ),
        );
      case ApiError<Inspection>(:final failure):
        setState(() {
          _uploadingPermit = false;
          _permitUploadError = _failureMessage(context, failure);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inspectionAsync = ref.watch(
      inspectionDetailProvider(widget.inspectionId),
    );
    final evidence = ref.watch(inspectionEvidenceProvider(widget.inspectionId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: context.l10n.backToAssignments,
        ),
        title: Text(context.l10n.inspectionRecord),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(inspectionDetailProvider(widget.inspectionId));
          ref.invalidate(inspectionEvidenceProvider(widget.inspectionId));
          await Future.wait([
            ref.read(inspectionDetailProvider(widget.inspectionId).future),
            ref.read(inspectionEvidenceProvider(widget.inspectionId).future),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              context.l10n.inspectionNumber(
                widget.inspectionId.length >= 8
                    ? widget.inspectionId.substring(0, 8)
                    : widget.inspectionId,
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () =>
                  context.push('/inspection/${widget.inspectionId}/session'),
              icon: const Icon(Icons.flight_takeoff_outlined),
              label: Text(context.l10n.openFieldSession),
            ),
            if (_operationError != null) ...[
              const SizedBox(height: 12),
              _InlineError(message: _operationError!),
            ],
            const SizedBox(height: 16),
            AsyncValueWidget<Inspection>(
              value: inspectionAsync,
              onRetry: () => ref.invalidate(
                inspectionDetailProvider(widget.inspectionId),
              ),
              builder: (inspection) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InspectionOverviewCard(inspection: inspection),
                  const SizedBox(height: 16),
                  _FlightPermitCard(
                    inspection: inspection,
                    selectedFile: _selectedPermit,
                    uploading: _uploadingPermit,
                    uploadError: _permitUploadError,
                    onPickFile: _pickPermitFile,
                    onUpload: _uploadPermit,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Inspection Items',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _InspectionItemsCard(items: inspection.inspectionItems),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.evidence,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _uploadingPhoto ? null : _capturePhoto,
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: Text(context.l10n.captureInspectionPhoto),
                    ),
                    if (_selectedPhoto != null) ...[
                      const SizedBox(height: 8),
                      Text(context.l10n.selectedFile(_selectedPhoto!.name)),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: _uploadingPhoto ? null : _uploadPhoto,
                        icon: const Icon(Icons.cloud_upload_outlined),
                        label: Text(
                          _uploadingPhoto
                              ? context.l10n.uploading
                              : _photoUploadError == null
                              ? context.l10n.uploadPhoto
                              : context.l10n.retryUpload,
                        ),
                      ),
                    ],
                    if (_photoUploadError != null) ...[
                      const SizedBox(height: 8),
                      _InlineError(
                        message: context.l10n.uploadFailed(_photoUploadError!),
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
                            '${item.contentType} · ${item.sizeBytes} bytes',
                          ),
                          trailing: !item.isDeleted
                              ? null
                              : const Chip(label: Text('Retired')),
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

class _InspectionOverviewCard extends StatelessWidget {
  const _InspectionOverviewCard({required this.inspection});

  final Inspection inspection;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = switch (inspection.status) {
      'ASSIGNED' => ('Assigned', Colors.orange),
      'READY_FOR_FLIGHT' => ('Ready for Flight', Colors.blue),
      'IN_PROGRESS' => ('In Progress', Colors.teal),
      'FIELD_COMPLETED' => ('Field Completed', Colors.green),
      _ => (inspection.status, Colors.grey),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    inspection.assetName ?? 'Asset #${inspection.assetId}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: statusColor.shade50,
                  side: BorderSide(color: statusColor.shade300),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Drone: ${inspection.droneModel ?? "Model N/A"} (${inspection.droneSerialNumber ?? "Serial N/A"})',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _FlightPermitCard extends StatelessWidget {
  const _FlightPermitCard({
    required this.inspection,
    required this.selectedFile,
    required this.uploading,
    required this.uploadError,
    required this.onPickFile,
    required this.onUpload,
  });

  final Inspection inspection;
  final XFile? selectedFile;
  final bool uploading;
  final String? uploadError;
  final VoidCallback onPickFile;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final hasPermit = inspection.hasFlightPermit;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasPermit ? Icons.verified : Icons.assignment_outlined,
                  color: hasPermit ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Flight Permit',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (hasPermit) ...[
              Text(
                'Permit file: ${inspection.flightPermitFileName ?? "Attached"}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (inspection.flightPermitUploadedAt != null)
                Text(
                  'Uploaded at: ${inspection.flightPermitUploadedAt!.split("T").first}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 8),
            ] else ...[
              const Text(
                'A flight permit is required before starting field flight sessions.',
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: const Key('choose-permit-file-btn'),
                onPressed: uploading ? null : onPickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(
                  selectedFile == null ? 'Select Permit File' : 'Change File',
                ),
              ),
              if (selectedFile != null) ...[
                const SizedBox(height: 8),
                Text('Selected: ${selectedFile!.name}'),
                const SizedBox(height: 8),
                FilledButton.icon(
                  key: const Key('upload-permit-btn'),
                  onPressed: uploading ? null : onUpload,
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: Text(uploading ? 'Uploading...' : 'Upload Flight Permit'),
                ),
              ],
              if (uploadError != null) ...[
                const SizedBox(height: 8),
                _InlineError(message: uploadError!),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _InspectionItemsCard extends StatelessWidget {
  const _InspectionItemsCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No inspection items specified for this asset.'),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 12,
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontSize: 11),
              ),
            ),
            title: Text(item),
          );
        },
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}

String _failureMessage(BuildContext context, ApiFailure failure) =>
    switch (failure) {
      NetworkFailure() => context.l10n.checkConnection,
      ValidationFailure(:final errors) => errors.values.join('\n'),
      UnauthorizedFailure() => context.l10n.unauthorizedInspection,
      NotFoundFailure() => context.l10n.inspectionUnavailable,
      ServerFailure(:final detail) =>
        detail ?? context.l10n.requestFailed,
      UnknownFailure(:final message) => message,
    };
