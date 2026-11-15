import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';
import 'package:smart_drone_inspection/features/assets/presentation/providers/asset_list_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/contracts/data/contract_repository.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/providers/contract_providers.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

class ServiceRequestDetailPage extends ConsumerStatefulWidget {
  const ServiceRequestDetailPage({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<ServiceRequestDetailPage> createState() =>
      _ServiceRequestDetailPageState();
}

class _ServiceRequestDetailPageState
    extends ConsumerState<ServiceRequestDetailPage> {
  bool _busy = false;

  Future<void> _acceptQuote(ServiceRequest request) async {
    final quote = request.currentQuote;
    if (quote == null) return;
    final l10n = context.l10n;
    final amountText = quote.pricePerOccurrenceVnd != null
        ? formatVnd(quote.pricePerOccurrenceVnd)
        : '\$${quote.pricePerOccurrenceUsd.toStringAsFixed(2)}';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.acceptQuote),
        content: Text(l10n.acceptQuoteConfirm(amountText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    final res = await ref
        .read(contractRepositoryProvider)
        .acceptQuote(requestId: request.id, quoteRowVersion: quote.rowVersion);
    if (!mounted) return;
    setState(() => _busy = false);

    switch (res) {
      case ApiSuccess():
        ref.invalidate(serviceRequestDetailProvider(widget.requestId));
        ref.read(serviceRequestsProvider.notifier).refresh();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.quoteAcceptedSuccess)));
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _downloadSignedContract(ServiceRequest request) async {
    setState(() => _busy = true);
    final res = await ref
        .read(contractRepositoryProvider)
        .downloadSignedContractBytes(request.id);
    if (!mounted) return;
    setState(() => _busy = false);

    switch (res) {
      case ApiSuccess(:final data):
        final fileName = request.contractFileName ?? 'signed-contract.pdf';
        final saved = await FilePicker.saveFile(
          dialogTitle: fileName,
          fileName: fileName,
          bytes: data,
        );
        if (!mounted || saved == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.documentSavedTo(fileName))),
        );
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reqAsync = ref.watch(serviceRequestDetailProvider(widget.requestId));
    final assets = ref.watch(assetListProvider).value ?? const <Asset>[];
    final assetById = {for (final a in assets) a.id: a};
    final currentUserId = ref.watch(authNotifierProvider).value?.user?.id;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.requestDetailsTitle)),
      body: AsyncValueWidget<ServiceRequest>(
        value: reqAsync,
        onRetry: () =>
            ref.invalidate(serviceRequestDetailProvider(widget.requestId)),
        builder: (req) {
          final asset = assetById[req.assetId];
          final effectiveStatus = req.effectiveStatus;
          final unreadCount = req.unreadCountForUser(currentUserId);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(serviceRequestDetailProvider(widget.requestId));
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                asset != null
                                    ? '${asset.name} (${asset.code})'
                                    : '#${req.id.substring(0, 8)}',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            StatusPill(
                              label: localizedServiceRequestStatus(
                                l10n,
                                effectiveStatus,
                              ),
                              tone: statusToneForCode(effectiveStatus),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (req.description.isNotEmpty) Text(req.description),
                        const SizedBox(height: 10),
                        Text(
                          '${formatDateShort(req.requestedFrom)} · ${req.windowStart}–${req.windowEnd} (${req.timezone})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 14),
                        _RequestStageStrip(status: effectiveStatus),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Quote Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.quoteSectionTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        if (req.currentQuote == null)
                          Text(
                            l10n.noQuoteYet,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        else ...[
                          Text(
                            req.currentQuote!.scopeSnapshot,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n.firstWindowLabel}: ${formatDateTimeShort(req.currentQuote!.firstOccurrenceStartAt)} → ${formatDateTimeShort(req.currentQuote!.firstOccurrenceEndAt)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.quoteAmountLabel),
                              Text(
                                req.currentQuote!.pricePerOccurrenceVnd != null
                                    ? formatVnd(
                                        req.currentQuote!.pricePerOccurrenceVnd,
                                      )
                                    : '\$${req.currentQuote!.pricePerOccurrenceUsd.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                              ),
                            ],
                          ),
                          if (effectiveStatus == 'QUOTED') ...[
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                key: const Key('accept-quote-btn'),
                                onPressed: _busy
                                    ? null
                                    : () => _acceptQuote(req),
                                icon: const Icon(Icons.check_circle_outline),
                                label: Text(l10n.acceptQuote),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Order Chat Card
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.chat_outlined),
                    title: Text(l10n.orderChatTitle),
                    subtitle: Text('${req.messages.length} messages'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (unreadCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: StatusPill(
                              label: l10n.unreadMessagesBadge(unreadCount),
                              tone: StatusTone.warning,
                            ),
                          ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                    onTap: () => context.push('/requests/${req.id}/chat'),
                  ),
                ),
                const SizedBox(height: 12),

                // Signed Contract Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.signedContractTitle,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            TextButton(
                              onPressed: () => showDialog<void>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(l10n.contractLegalBasisButton),
                                  content: Text(l10n.contractLegalBasisText),
                                  actions: [
                                    FilledButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: Text(l10n.close),
                                    ),
                                  ],
                                ),
                              ),
                              child: Text(l10n.contractLegalBasisButton),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (req.contractFileName != null &&
                            req.contractFileName!.isNotEmpty) ...[
                          Text(
                            '${req.contractFileName} · ${formatBytes(req.contractSizeBytes)}',
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _busy
                                ? null
                                : () => _downloadSignedContract(req),
                            icon: const Icon(Icons.download_rounded),
                            label: Text(l10n.downloadContract),
                          ),
                        ] else
                          Text(
                            l10n.contractNotUploadedYet,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ),

                if (req.occurrences.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.occurrencesTitle,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          for (final occ in req.occurrences)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                l10n.occurrenceNumber(occ.occurrenceIndex),
                              ),
                              subtitle: Text(
                                '${formatDateTimeShort(occ.plannedStartAt)} · ${occ.totalPrice != null ? formatVnd(occ.totalPrice) : l10n.pendingAssignment}',
                              ),
                              trailing: occ.inspectionId != null
                                  ? FilledButton.tonal(
                                      onPressed: () => context.push(
                                        '/inspections/${occ.inspectionId}',
                                      ),
                                      child: Text(l10n.openInspection),
                                    )
                                  : StatusPill(
                                      label: occ.status == 'PENDING_ASSIGNMENT'
                                          ? l10n.pendingAssignment
                                          : occ.status,
                                      tone: statusToneForCode(occ.status),
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RequestStageStrip extends StatelessWidget {
  const _RequestStageStrip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const stages = [
      'OPEN',
      'QUOTED',
      'ACCEPTED',
      'CONTRACT_SIGNED',
      'ASSIGNED',
    ];
    final activeIdx = stages.indexOf(status);

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var i = 0; i < stages.length; i++)
          StatusPill(
            label: localizedServiceRequestStatus(l10n, stages[i]),
            tone: status == 'CANCELLED'
                ? StatusTone.danger
                : (i <= activeIdx ? StatusTone.primary : StatusTone.neutral),
            icon: i <= activeIdx && status != 'CANCELLED'
                ? Icons.check_rounded
                : null,
          ),
      ],
    );
  }
}
