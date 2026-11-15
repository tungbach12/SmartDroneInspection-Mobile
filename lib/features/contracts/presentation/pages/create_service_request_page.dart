import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';
import 'package:smart_drone_inspection/features/assets/presentation/providers/asset_list_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/providers/contract_providers.dart';

class CreateServiceRequestPage extends ConsumerStatefulWidget {
  const CreateServiceRequestPage({super.key});

  @override
  ConsumerState<CreateServiceRequestPage> createState() =>
      _CreateServiceRequestPageState();
}

class _CreateServiceRequestPageState
    extends ConsumerState<CreateServiceRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _occurrenceCount = TextEditingController(text: '3');

  String? _selectedAssetId;
  String _requestType = 'ONE_TIME';
  int _recurrenceMonths = 3;
  String _windowStart = '08:00';
  String _windowEnd = '17:00';
  late DateTime _selectedDate = earliestAllowedRequestDate();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _description.dispose();
    _occurrenceCount.dispose();
    super.dispose();
  }

  String _isoDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickDate() async {
    final minDate = earliestAllowedRequestDate();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(minDate) ? minDate : _selectedDate,
      firstDate: minDate,
      lastDate: minDate.add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedAssetId == null) {
      return;
    }
    final minDate = earliestAllowedRequestDate();
    if (_selectedDate.isBefore(minDate)) {
      setState(() => _error = context.l10n.leadTime20DaysError);
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final count = _requestType == 'RECURRING'
        ? int.tryParse(_occurrenceCount.text.trim()) ?? 2
        : null;

    final res = await ref
        .read(serviceRequestsProvider.notifier)
        .createRequest(
          CreateServiceRequestInput(
            assetId: _selectedAssetId!,
            description: _description.text.trim(),
            requestedFrom: _isoDate(_selectedDate),
            requestedUntil: _isoDate(_selectedDate),
            windowStart: _windowStart,
            windowEnd: _windowEnd,
            requestType: _requestType,
            recurrenceUnit: _requestType == 'RECURRING' ? 'MONTH' : null,
            recurrenceInterval: _requestType == 'RECURRING'
                ? _recurrenceMonths
                : null,
            occurrenceCount: count,
          ),
        );
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (res) {
      case ApiSuccess(:final data):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.requestCreatedSuccess)),
        );
        context.go('/requests/${data.id}');
      case ApiError(:final failure):
        setState(() => _error = describeApiFailure(context, failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final assets = (ref.watch(assetListProvider).value ?? const <Asset>[])
        .where((a) => a.isActive)
        .toList();
    _selectedAssetId ??= assets.isNotEmpty ? assets.first.id : null;
    final earliestStr = _isoDate(earliestAllowedRequestDate());

    return Scaffold(
      appBar: AppBar(title: Text(l10n.newServiceRequest)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: assets.isEmpty
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(l10n.noActiveAssetsForRequest),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => context.go('/assets'),
                          child: Text(l10n.registerAsset),
                        ),
                      ],
                    ),
                  ),
                )
              : Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_error != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _error!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                          DropdownButtonFormField<String>(
                            initialValue: _selectedAssetId,
                            decoration: InputDecoration(
                              labelText: l10n.selectAsset,
                            ),
                            items: [
                              for (final asset in assets)
                                DropdownMenuItem(
                                  value: asset.id,
                                  child: Text('${asset.name} (${asset.code})'),
                                ),
                            ],
                            onChanged: (v) =>
                                setState(() => _selectedAssetId = v),
                            validator: (v) => v == null ? l10n.required : null,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            l10n.requestTypeLabel,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: [
                              ButtonSegment(
                                value: 'ONE_TIME',
                                label: Text(l10n.requestTypeOneTime),
                              ),
                              ButtonSegment(
                                value: 'RECURRING',
                                label: Text(l10n.requestTypeRecurring),
                              ),
                            ],
                            selected: {_requestType},
                            onSelectionChanged: (set) {
                              setState(() => _requestType = set.first);
                            },
                          ),
                          const SizedBox(height: 14),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.preferredStartDate),
                            subtitle: Text(
                              '${_isoDate(_selectedDate)} · ${l10n.leadTime20DaysNotice(minimumInspectionLeadDays, earliestStr)}',
                            ),
                            trailing: const Icon(Icons.calendar_month_rounded),
                            onTap: _pickDate,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _windowStart,
                                  decoration: InputDecoration(
                                    labelText: '${l10n.timeWindowLabel} (From)',
                                  ),
                                  items:
                                      const [
                                            '07:00',
                                            '08:00',
                                            '09:00',
                                            '13:00',
                                            '14:00',
                                          ]
                                          .map(
                                            (h) => DropdownMenuItem(
                                              value: h,
                                              child: Text(h),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(() => _windowStart = v);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _windowEnd,
                                  decoration: InputDecoration(
                                    labelText: '${l10n.timeWindowLabel} (To)',
                                  ),
                                  items:
                                      const [
                                            '11:00',
                                            '12:00',
                                            '16:00',
                                            '17:00',
                                            '18:00',
                                          ]
                                          .map(
                                            (h) => DropdownMenuItem(
                                              value: h,
                                              child: Text(h),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(() => _windowEnd = v);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (_requestType == 'RECURRING') ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    initialValue: _recurrenceMonths,
                                    decoration: InputDecoration(
                                      labelText: l10n.recurrenceMonthsLabel,
                                    ),
                                    items: const [1, 3, 6, 9, 12]
                                        .map(
                                          (m) => DropdownMenuItem(
                                            value: m,
                                            child: Text('$m'),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() => _recurrenceMonths = v);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _occurrenceCount,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: l10n.occurrenceCountLabel,
                                    ),
                                    validator: (v) {
                                      final n = int.tryParse(v ?? '');
                                      if (n == null || n < 2 || n > 100) {
                                        return '2 - 100';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _description,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: l10n.scopeDescriptionLabel,
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? l10n.required
                                : null,
                          ),
                          const SizedBox(height: 18),
                          FilledButton(
                            key: const Key('submit-service-request-btn'),
                            onPressed: _submitting ? null : _submit,
                            child: Text(
                              _submitting ? l10n.submitting : l10n.confirm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
