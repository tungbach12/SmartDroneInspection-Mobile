import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/mobile_task_item.dart';
import 'package:smart_drone_inspection/features/tasks/presentation/providers/maintenance_providers.dart';

class RecordWorkLogSheet extends ConsumerStatefulWidget {
  const RecordWorkLogSheet({
    super.key,
    required this.workOrderId,
    required this.tasks,
  });

  final String workOrderId;
  final List<MobileTaskItem> tasks;

  static Future<void> show(
    BuildContext context, {
    required String workOrderId,
    required List<MobileTaskItem> tasks,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RecordWorkLogSheet(
        workOrderId: workOrderId,
        tasks: tasks,
      ),
    );
  }

  @override
  ConsumerState<RecordWorkLogSheet> createState() => _RecordWorkLogSheetState();
}

class _RecordWorkLogSheetState extends ConsumerState<RecordWorkLogSheet> {
  late String _selectedTaskId;
  final _hoursController = TextEditingController(text: '1.0');
  final _conditionController = TextEditingController();
  final _readingsController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedTaskId = widget.tasks.isNotEmpty ? widget.tasks.first.id : '';
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _conditionController.dispose();
    _readingsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final hours = double.tryParse(_hoursController.text);
    if (hours == null || hours <= 0) {
      setState(() => _error = 'Please enter a valid positive number of hours');
      return;
    }
    if (_selectedTaskId.isEmpty) {
      setState(() => _error = 'Please select a task');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    final repo = ref.read(maintenanceRepositoryProvider);
    final result = await repo.recordWorkLog(
      workOrderId: widget.workOrderId,
      taskId: _selectedTaskId,
      hours: hours,
      asLeftCondition: _conditionController.text.trim(),
      testReadings: _readingsController.text.trim(),
    );

    if (!mounted) return;

    result.when(
      success: (_) {
        ref.invalidate(maintenanceLogsProvider(widget.workOrderId));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Work log submitted for verification')),
        );
      },
      failure: (failure) {
        setState(() {
          _isSubmitting = false;
          _error = failure.message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Record Work Log',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (widget.tasks.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              value: _selectedTaskId,
              decoration: const InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
              ),
              items: widget.tasks.map((t) {
                return DropdownMenuItem(
                  value: t.id,
                  child: Text('#${t.taskNumber} ${t.name}', overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedTaskId = val);
              },
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _hoursController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Hours Worked',
              border: OutlineInputBorder(),
              hintText: 'e.g. 2.5',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _conditionController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'As-Left Condition',
              border: OutlineInputBorder(),
              hintText: 'e.g. Welded and protective primer applied',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _readingsController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Test Readings / Measurements',
              border: OutlineInputBorder(),
              hintText: 'e.g. Torque checked at 85 Nm, ultrasonic bond pass',
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Submit Work Log'),
          ),
        ],
      ),
    );
  }
}
