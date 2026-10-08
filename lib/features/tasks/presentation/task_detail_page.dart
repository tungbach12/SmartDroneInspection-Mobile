import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/tasks/data/maintenance_task_repository.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/maintenance_task.dart';
import 'package:smart_drone_inspection/features/tasks/presentation/providers/maintenance_task_providers.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  const TaskDetailPage({required this.task, super.key});

  final MaintenanceTask task;

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  String? _beforeEvidenceId;
  String? _afterEvidenceId;
  bool _uploadingBefore = false;
  bool _uploadingAfter = false;
  bool _submitting = false;

  final _summaryController = TextEditingController();
  final _materialsController = TextEditingController();
  final _hoursController = TextEditingController(text: '4.0');

  @override
  void dispose() {
    _summaryController.dispose();
    _materialsController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto(String kind) async {
    final photo = await ref.read(maintenancePhotoPickerProvider)();
    if (photo == null || !mounted) return;

    final orderId = widget.task.maintenanceOrderId ?? widget.task.id;

    setState(() {
      if (kind == 'BEFORE_MAINTENANCE') {
        _uploadingBefore = true;
      } else {
        _uploadingAfter = true;
      }
    });

    final result = await ref.read(maintenanceTaskRepositoryProvider).uploadEvidence(
          orderId: orderId,
          kind: kind,
          photo: photo,
        );

    if (!mounted) return;

    setState(() {
      if (kind == 'BEFORE_MAINTENANCE') {
        _uploadingBefore = false;
        if (result is ApiSuccess<String>) {
          _beforeEvidenceId = result.data;
        }
      } else {
        _uploadingAfter = false;
        if (result is ApiSuccess<String>) {
          _afterEvidenceId = result.data;
        }
      }
    });

    if (result is ApiError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload $kind photo: ${(result as ApiError).failure}')),
      );
    }
  }

  Future<void> _submitWorkLog() async {
    if (_beforeEvidenceId == null || _afterEvidenceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both Before and After photos are strictly required.')),
      );
      return;
    }

    if (_beforeEvidenceId == _afterEvidenceId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Before and After photos must be distinct.')),
      );
      return;
    }

    setState(() => _submitting = true);

    final orderId = widget.task.maintenanceOrderId ?? widget.task.id;
    final hours = double.tryParse(_hoursController.text) ?? 4.0;

    final result = await ref.read(maintenanceTaskRepositoryProvider).submitWorkLog(
          orderId: orderId,
          assignmentId: widget.task.id,
          workSummary: _summaryController.text.trim().isEmpty
              ? 'Repair completed per specifications'
              : _summaryController.text.trim(),
          materialsUsed: _materialsController.text.trim().isEmpty
              ? '{"materials": "Standard patch mortar"}'
              : _materialsController.text.trim(),
          laborHours: hours,
          progressPercent: 100.0,
          beforeEvidenceId: _beforeEvidenceId!,
          afterEvidenceId: _afterEvidenceId!,
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case ApiSuccess():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maintenance work log submitted with Before/After evidence.')),
        );
        ref.invalidate(maintenanceTaskListProvider);
        context.pop();
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit work log: $failure')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(title: Text('Task #${task.id.substring(0, 8)}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: ${task.assignmentType}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('Status: ${task.status}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    if (task.deadline != null) ...[
                      const SizedBox(height: 4),
                      Text('Deadline: ${task.deadline}'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Mandatory Photographic Verification', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: _beforeEvidenceId != null ? Colors.green.shade50 : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Icon(Icons.camera_alt, size: 36),
                          const SizedBox(height: 8),
                          Text(_beforeEvidenceId != null ? 'Before Photo Uploaded' : 'Before Photo'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _uploadingBefore ? null : () => _capturePhoto('BEFORE_MAINTENANCE'),
                            child: _uploadingBefore
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Capture Before'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: _afterEvidenceId != null ? Colors.green.shade50 : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_outline, size: 36),
                          const SizedBox(height: 8),
                          Text(_afterEvidenceId != null ? 'After Photo Uploaded' : 'After Photo'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _uploadingAfter ? null : () => _capturePhoto('AFTER_MAINTENANCE'),
                            child: _uploadingAfter
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Capture After'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _summaryController,
              decoration: const InputDecoration(
                labelText: 'Work Summary',
                hintText: 'Describe physical repairs executed',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _materialsController,
              decoration: const InputDecoration(
                labelText: 'Materials Used',
                hintText: 'e.g. Epoxy Sikadur 731, Polymer mortar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hoursController,
              decoration: const InputDecoration(
                labelText: 'Labor Hours',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: (_submitting || _beforeEvidenceId == null || _afterEvidenceId == null)
                  ? null
                  : _submitWorkLog,
              child: _submitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Completion Work Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
