import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';
import 'package:smart_drone_inspection/features/inspections/domain/verdict_expiry.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/inspection_chat_page.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/widgets/customer_inspector_rating_card.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/widgets/knowledge_references_strip.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/widgets/sepay_qr_dialog.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspections_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class InspectionDetailPage extends ConsumerStatefulWidget {
  const InspectionDetailPage({
    super.key,
    required this.inspectionId,
    this.initialTab = 0,
  });

  final String inspectionId;
  final int initialTab;

  @override
  ConsumerState<InspectionDetailPage> createState() =>
      _InspectionDetailPageState();
}

class _InspectionDetailPageState extends ConsumerState<InspectionDetailPage> {
  String? _selectedVersionId;
  bool _actionBusy = false;

  void _refreshBundle() {
    ref.invalidate(inspectionBundleProvider(widget.inspectionId));
    ref.invalidate(inspectorRatingProvider(widget.inspectionId));
    ref.read(inspectionsNotifierProvider.notifier).refresh();
  }

  Future<void> _openEvidence(InspectionEvidence item) async {
    setState(() => _actionBusy = true);
    final res = await ref
        .read(inspectionRepositoryProvider)
        .downloadEvidenceBytes(
          inspectionId: widget.inspectionId,
          evidenceId: item.id,
        );
    if (!mounted) return;
    setState(() => _actionBusy = false);

    switch (res) {
      case ApiSuccess(:final data):
        if (item.isImage) {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(item.fileName),
              content: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(data, fit: BoxFit.contain),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final saved = await FilePicker.saveFile(
                      dialogTitle: item.fileName,
                      fileName: item.fileName,
                      bytes: data,
                    );
                    if (ctx.mounted && saved != null) {
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text(context.l10n.download),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(context.l10n.close),
                ),
              ],
            ),
          );
        } else {
          final saved = await FilePicker.saveFile(
            dialogTitle: item.fileName,
            fileName: item.fileName,
            bytes: data,
          );
          if (mounted && saved != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.documentSavedTo(item.fileName)),
              ),
            );
          }
        }
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _downloadReportPdf(InspectionReportVersion version) async {
    setState(() => _actionBusy = true);
    final res = await ref
        .read(inspectionRepositoryProvider)
        .downloadOfficialReportPdf(
          inspectionId: widget.inspectionId,
          versionId: version.id,
        );
    if (!mounted) return;
    setState(() => _actionBusy = false);

    switch (res) {
      case ApiSuccess(:final data):
        final fileName = 'inspection-report-v${version.versionNo}.pdf';
        final saved = await FilePicker.saveFile(
          dialogTitle: fileName,
          fileName: fileName,
          bytes: data,
        );
        if (mounted && saved != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.documentSavedTo(fileName))),
          );
        }
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _downloadPaymentDocument(bool paid) async {
    setState(() => _actionBusy = true);
    final res = await ref
        .read(inspectionRepositoryProvider)
        .downloadPaymentDocument(widget.inspectionId);
    if (!mounted) return;
    setState(() => _actionBusy = false);

    switch (res) {
      case ApiSuccess(:final data):
        final fileName = paid ? 'payment-receipt.pdf' : 'payment-notice.pdf';
        final saved = await FilePicker.saveFile(
          dialogTitle: fileName,
          fileName: fileName,
          bytes: data,
        );
        if (mounted && saved != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.documentSavedTo(fileName))),
          );
        }
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _acceptReport(InspectionReportVersion version) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.acceptReport),
        content: Text(l10n.acceptReportConfirm(version.versionNo)),
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

    setState(() => _actionBusy = true);
    final res = await ref
        .read(inspectionRepositoryProvider)
        .acceptReport(inspectionId: widget.inspectionId, versionId: version.id);
    if (!mounted) return;
    setState(() => _actionBusy = false);

    switch (res) {
      case ApiSuccess():
        _refreshBundle();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.reportAcceptedSuccess)));
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _requestClarification(
    InspectionReportVersion version,
    int priorCount,
  ) async {
    final l10n = context.l10n;
    if (priorCount >= 2) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.clarificationTitle),
          content: Text(l10n.clarificationLimitReached),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close),
            ),
          ],
        ),
      );
      return;
    }

    final reasonCtrl = TextEditingController();
    final submitted = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clarificationTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.clarificationPolicyNote(priorCount + 1),
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.clarificationReasonHint,
              ),
            ),
          ],
        ),
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
    final reason = reasonCtrl.text.trim();
    reasonCtrl.dispose();
    if (submitted != true || reason.isEmpty || !mounted) return;

    setState(() => _actionBusy = true);
    final res = await ref
        .read(inspectionRepositoryProvider)
        .requestReportClarification(
          inspectionId: widget.inspectionId,
          versionId: version.id,
          reason: reason,
        );
    if (!mounted) return;
    setState(() => _actionBusy = false);

    switch (res) {
      case ApiSuccess():
        _refreshBundle();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.clarificationSubmitted)));
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _payWithSepay() async {
    setState(() => _actionBusy = true);
    final repo = ref.read(inspectionRepositoryProvider);
    final res = await repo.createSepayPaymentLink(widget.inspectionId);
    if (!mounted) return;
    setState(() => _actionBusy = false);

    switch (res) {
      case ApiSuccess(:final data):
        _refreshBundle();
        await showDialog<bool>(
          context: context,
          builder: (_) => SepayQrDialog(
            details: data,
            checkPaymentStatus: () =>
                repo.getReportPaymentStatus(widget.inspectionId),
            onMockPay: () => repo.mockConfirmSepayPayment(widget.inspectionId),
            onSettled: () {
              if (!mounted) return;
              _refreshBundle();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.paymentPaidBanner)),
              );
            },
          ),
        );
        if (mounted) {
          _refreshBundle();
        }
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _payWithVnpay() async {
    setState(() => _actionBusy = true);
    final res = await ref
        .read(inspectionRepositoryProvider)
        .createVnpayPaymentUrl(widget.inspectionId);
    if (!mounted) return;
    setState(() => _actionBusy = false);

    switch (res) {
      case ApiSuccess(:final data):
        final uri = Uri.tryParse(data.checkoutUrl);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        _refreshBundle();
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bundleAsync = ref.watch(
      inspectionBundleProvider(widget.inspectionId),
    );

    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialTab.clamp(0, 2),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.inspectionDetailTitle),
          actions: [
            IconButton(
              key: const Key('inspection-chat-btn'),
              tooltip: l10n.inspectionChatTitle,
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      InspectionChatPage(inspectionId: widget.inspectionId),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.tabTracking),
              Tab(text: l10n.tabOfficialReport),
              Tab(text: l10n.tabSettlement),
            ],
          ),
        ),
        body: AsyncValueWidget<CustomerInspectionBundle>(
          value: bundleAsync,
          onRetry: _refreshBundle,
          builder: (bundle) {
            final versions = bundle.reportVersions;
            final openVersion = versions.isEmpty
                ? null
                : versions.firstWhere(
                    (v) => v.id == _selectedVersionId,
                    orElse: () => versions.first,
                  );

            return TabBarView(
              children: [
                _TrackingTab(
                  bundle: bundle,
                  busy: _actionBusy,
                  onRefresh: () async => _refreshBundle(),
                  onTapEvidence: _openEvidence,
                ),
                _OfficialReportTab(
                  inspectionId: widget.inspectionId,
                  bundle: bundle,
                  openVersion: openVersion,
                  busy: _actionBusy,
                  onSelectVersion: (id) =>
                      setState(() => _selectedVersionId = id),
                  onRefresh: () async => _refreshBundle(),
                  onDownloadPdf: _downloadReportPdf,
                ),
                _SettlementTab(
                  bundle: bundle,
                  openVersion: openVersion,
                  busy: _actionBusy,
                  onRefresh: () async => _refreshBundle(),
                  onDownloadPdf: _downloadReportPdf,
                  onAcceptReport: _acceptReport,
                  onRequestClarification: _requestClarification,
                  onPaySepay: _payWithSepay,
                  onPayVnpay: _payWithVnpay,
                  onDownloadPaymentDocument: _downloadPaymentDocument,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _VerdictExpiryBanner extends StatelessWidget {
  const _VerdictExpiryBanner({required this.summary});

  final VerdictExpirySummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expired = summary.expiredCount > 0;
    final (bg, fg) = statusColorsForTone(
      context,
      expired ? StatusTone.danger : StatusTone.warning,
    );
    return Container(
      key: const Key('verdict-expiry-banner'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              expired
                  ? l10n.verdictExpiredChip(summary.expiredCount)
                  : l10n.verdictExpiringSoonChip(summary.expiringSoon.length),
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingTab extends StatelessWidget {
  const _TrackingTab({
    required this.bundle,
    required this.busy,
    required this.onRefresh,
    required this.onTapEvidence,
  });

  final CustomerInspectionBundle bundle;
  final bool busy;
  final Future<void> Function() onRefresh;
  final void Function(InspectionEvidence) onTapEvidence;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inspection = bundle.inspection;
    final status = bundle.workflowState?.status ?? inspection.status;
    final hasPublished = bundle.reportVersions.any((v) => v.isPublished);
    final verdictExpiry = summarizeVerdictExpiry(
      bundle.reinspectionVerifications,
    );

    final s1 = [
      'IN_PROGRESS',
      'FIELD_COMPLETED',
      'UNDER_REVIEW',
      'COMPLETED',
    ].contains(status);
    final s2 = [
      'FIELD_COMPLETED',
      'UNDER_REVIEW',
      'COMPLETED',
    ].contains(status);
    final s3 = ['UNDER_REVIEW', 'COMPLETED'].contains(status);
    final s4 = status == 'COMPLETED' || hasPublished;
    final s5 = hasPublished;

    final milestones = [
      (l10n.milestoneMissionSetup, s1),
      (l10n.milestoneDroneFlight, s2),
      (l10n.milestoneEvidenceAi, s3),
      (l10n.milestoneManagerReview, s4),
      (l10n.milestonePublished, s5),
    ];

    final confirmedFindings = bundle.findings
        .where((f) => f.status == 'CONFIRMED' || s3)
        .toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!verdictExpiry.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _VerdictExpiryBanner(summary: verdictExpiry),
            ),
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
                          inspection.assetName ?? inspection.assetId,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      StatusPill(
                        label: localizedInspectionStatus(l10n, status),
                        tone: statusToneForCode(status),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (inspection.plannedStartAt != null)
                    Text(
                      '${formatDateTimeShort(inspection.plannedStartAt)} → ${formatDateTimeShort(inspection.plannedEndAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (inspection.inspectorName != null &&
                      inspection.inspectorName!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${l10n.inspectorLabel}: ${inspection.inspectorName!.trim()}',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (inspection.inspectorAverageRating != null &&
                            inspection.inspectorRatingCount > 0) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: Color(0xFFF59E0B),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${inspection.inspectorAverageRating!.toStringAsFixed(1)} (${inspection.inspectorRatingCount})',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ],
                    ),
                  ],
                  if (inspection.managerName != null &&
                      inspection.managerName!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${l10n.managerLabel}: ${inspection.managerName!.trim()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (inspection.flightPermitFileName != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${l10n.flightPermitLabel}: ${inspection.flightPermitFileName}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.progressMilestonesTitle,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < milestones.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(
                            milestones[i].$2
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 20,
                            color: milestones[i].$2
                                ? const Color(0xFF16A34A)
                                : Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(milestones[i].$1)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.fieldSessionsTitle,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (bundle.fieldSessions.isEmpty)
                    Text(
                      l10n.noFieldSessionsYet,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  else
                    for (final s in bundle.fieldSessions)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            StatusPill(
                              label: localizedFieldSessionStatus(
                                l10n,
                                s.status,
                              ),
                              tone: statusToneForCode(s.status),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                formatDateTimeShort(s.startedAt),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          s.outcomeNotes ??
                              s.abortReason ??
                              s.postponementReason ??
                              s.preFlightChecklistNote ??
                              '',
                        ),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.evidenceGalleryTitle(bundle.evidence.length),
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (bundle.evidence.isEmpty)
                    Text(
                      l10n.noEvidenceYet,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  else
                    for (final ev in bundle.evidence)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          ev.isVideo
                              ? Icons.videocam_outlined
                              : Icons.photo_outlined,
                        ),
                        title: Text(ev.fileName),
                        subtitle: Text(
                          [
                            if (ev.locationDescription != null &&
                                ev.locationDescription!.trim().isNotEmpty)
                              ev.locationDescription!.trim(),
                            '${formatBytes(ev.sizeBytes)} · ${formatDateTimeShort(ev.createdAt)}',
                          ].join('\n'),
                        ),
                        trailing: const Icon(Icons.open_in_new_rounded),
                        onTap: busy ? null : () => onTapEvidence(ev),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.confirmedFindingsTitle(confirmedFindings.length),
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (confirmedFindings.isEmpty)
                    Text(
                      l10n.noFindingsYet,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  else
                    for (final f in confirmedFindings) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    f.findingCode.trim().isNotEmpty
                                        ? '${f.findingCode.trim()} · ${f.defectLabel}'
                                        : f.defectLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                StatusPill(
                                  label: localizedFindingSeverity(
                                    l10n,
                                    f.severity,
                                  ),
                                  tone: statusToneForCode(f.severity),
                                ),
                              ],
                            ),
                            if (_meaningfulFindingNote(f) case final note?) ...[
                              const SizedBox(height: 4),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${l10n.noteLabel}: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(text: note),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialReportTab extends ConsumerWidget {
  const _OfficialReportTab({
    required this.inspectionId,
    required this.bundle,
    required this.openVersion,
    required this.busy,
    required this.onSelectVersion,
    required this.onRefresh,
    required this.onDownloadPdf,
  });

  final String inspectionId;
  final CustomerInspectionBundle bundle;
  final InspectionReportVersion? openVersion;
  final bool busy;
  final ValueChanged<String> onSelectVersion;
  final Future<void> Function() onRefresh;
  final ValueChanged<InspectionReportVersion> onDownloadPdf;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (bundle.reportVersions.isEmpty || openVersion == null) {
      return EmptyState(
        icon: Icons.description_outlined,
        title: l10n.noReportVersionsYet,
      );
    }

    final aiAsync = ref.watch(
      reportAiSummaryProvider((
        inspectionId: inspectionId,
        versionId: openVersion!.id,
      )),
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bundle.reportVersions.length > 1)
                    DropdownButtonFormField<String>(
                      initialValue: openVersion!.id,
                      items: [
                        for (final v in bundle.reportVersions)
                          DropdownMenuItem(
                            value: v.id,
                            child: Text(
                              '${l10n.reportVersionLabel(v.versionNo)} · ${localizedReportStatus(l10n, v.status)}',
                            ),
                          ),
                      ],
                      onChanged: (id) {
                        if (id != null) onSelectVersion(id);
                      },
                    )
                  else
                    Row(
                      children: [
                        Text(
                          l10n.reportVersionLabel(openVersion!.versionNo),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        StatusPill(
                          label: localizedReportStatus(
                            l10n,
                            openVersion!.status,
                          ),
                          tone: statusToneForCode(openVersion!.status),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  if (openVersion!.publishedAt != null)
                    Text(
                      formatDateTimeShort(openVersion!.publishedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if ((openVersion!.flightPermitFileName ??
                          bundle.inspection.flightPermitFileName)
                      case final permitName?
                      when permitName.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.flightPermitLabel}: ${permitName.trim()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (openVersion!.isPublished)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        key: const Key('download-official-pdf-btn'),
                        onPressed: busy
                            ? null
                            : () => onDownloadPdf(openVersion!),
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: Text(l10n.downloadOfficialPdf),
                      ),
                    )
                  else
                    Text(
                      l10n.reportUnpublishedNotice,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.summarize_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.aiExecutiveSummaryTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  aiAsync.when(
                    data: (ai) {
                      final summaryText =
                          ai?.summary ?? openVersion!.summary ?? '';
                      if (summaryText.isEmpty && ai == null) {
                        return Text(l10n.nothingHereYet);
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ai != null) ...[
                            StatusPill(
                              label: l10n.overallRiskLabel(ai.overallRisk),
                              tone: statusToneForCode(ai.overallRisk),
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (summaryText.isNotEmpty) Text(summaryText),
                          if (ai != null && ai.keyHighlights.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              l10n.keyHighlightsLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            for (final h in ai.keyHighlights)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text('• $h'),
                              ),
                          ],
                          if (ai != null &&
                              ai.recommendedActions.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              l10n.recommendedActionsLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(ai.recommendedActions),
                          ],
                        ],
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) =>
                        Text(openVersion!.summary ?? l10n.nothingHereYet),
                  ),
                  const SizedBox(height: 12),
                  KnowledgeReferencesStrip(inspectionId: inspectionId),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettlementTab extends StatelessWidget {
  const _SettlementTab({
    required this.bundle,
    required this.openVersion,
    required this.busy,
    required this.onRefresh,
    required this.onDownloadPdf,
    required this.onAcceptReport,
    required this.onRequestClarification,
    required this.onPaySepay,
    required this.onPayVnpay,
    required this.onDownloadPaymentDocument,
  });

  final CustomerInspectionBundle bundle;
  final InspectionReportVersion? openVersion;
  final bool busy;
  final Future<void> Function() onRefresh;
  final ValueChanged<InspectionReportVersion> onDownloadPdf;
  final ValueChanged<InspectionReportVersion> onAcceptReport;
  final void Function(InspectionReportVersion, int priorCount)
  onRequestClarification;
  final VoidCallback onPaySepay;
  final VoidCallback onPayVnpay;
  final ValueChanged<bool> onDownloadPaymentDocument;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (openVersion == null || !openVersion!.isPublished) {
      return EmptyState(
        icon: Icons.payments_outlined,
        title: l10n.noReportVersionsYet,
      );
    }

    final payment = bundle.paymentStatus;
    final isPaid = payment?.paid ?? bundle.inspection.isPaid;
    final overdue = !isPaid && (payment?.isPaymentOverdue() ?? false);
    final isAccepted =
        (payment?.reportAccepted ??
            bundle.inspection.reportAccepted ??
            false) ||
        isPaid;
    final priorClarifications = bundle.inspection.clarificationCount > 0
        ? bundle.inspection.clarificationCount
        : bundle.reportVersions.where((v) => v.clarificationRequested).length;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MilestoneRow(
                    title: l10n.settlementStepAccept,
                    done: isAccepted,
                    active: !isAccepted,
                  ),
                  _MilestoneRow(
                    title: l10n.settlementStepPay,
                    done: isPaid,
                    active: isAccepted && !isPaid,
                  ),
                  _MilestoneRow(
                    title: l10n.settlementStepFulfilled,
                    done: isPaid,
                    active: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          if (payment?.amount != null && payment!.amount! > 0) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.serviceInvoiceTitle,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    if (payment.serviceBaseAmount != null)
                      _InvoiceLine(
                        label: l10n.preVatBase,
                        value: formatVnd(payment.serviceBaseAmount),
                      ),
                    if (payment.vatRate != null && payment.vatAmount != null)
                      _InvoiceLine(
                        label: l10n.vatLabel(
                          payment.vatRate!.toStringAsFixed(0),
                        ),
                        value: '+${formatVnd(payment.vatAmount)}',
                      ),
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isPaid ? l10n.totalPaid : l10n.amountToPay,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          formatVnd(payment.amount),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isPaid
                                    ? const Color(0xFF16A34A)
                                    : Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (isPaid || (payment?.isPaymentDue ?? false))
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    StatusPill(
                      label: isPaid
                          ? l10n.paymentStatusPaid
                          : overdue
                          ? l10n.paymentOverdue
                          : l10n.paymentDueOn(
                              formatDateShort(payment?.paymentDueAt),
                            ),
                      tone: isPaid
                          ? StatusTone.success
                          : overdue
                          ? StatusTone.danger
                          : StatusTone.warning,
                      showDot: true,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      key: const Key('payment-document-btn'),
                      onPressed: busy
                          ? null
                          : () => onDownloadPaymentDocument(isPaid),
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      label: Text(
                        isPaid ? l10n.paymentReceiptPdf : l10n.paymentNoticePdf,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isPaid || (payment?.isPaymentDue ?? false))
            const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: isPaid
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF16A34A),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.paymentPaidBanner,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (payment?.orderCode != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            '${payment?.paymentMethod ?? 'Sepay'} #${payment!.orderCode}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            key: const Key('settlement-download-pdf-btn'),
                            onPressed: busy
                                ? null
                                : () => onDownloadPdf(openVersion!),
                            icon: const Icon(Icons.picture_as_pdf_outlined),
                            label: Text(l10n.downloadOfficialPdf),
                          ),
                        ),
                      ],
                    )
                  : isAccepted
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.net15Notice,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          key: const Key('pay-sepay-btn'),
                          onPressed: busy ? null : onPaySepay,
                          icon: const Icon(Icons.qr_code_2_rounded),
                          label: Text(l10n.payWithSepay),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          key: const Key('pay-vnpay-btn'),
                          onPressed: busy ? null : onPayVnpay,
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: Text(l10n.payWithVnpay),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: busy ? null : onRefresh,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(l10n.refreshPaymentStatus),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton.icon(
                          key: const Key('settlement-download-pdf-btn'),
                          onPressed: busy
                              ? null
                              : () => onDownloadPdf(openVersion!),
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: Text(l10n.downloadOfficialPdf),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.icon(
                          key: const Key('accept-report-btn'),
                          onPressed: busy
                              ? null
                              : () => onAcceptReport(openVersion!),
                          icon: const Icon(Icons.check_circle_outline),
                          label: Text(l10n.acceptReport),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          key: const Key('request-clarification-btn'),
                          onPressed: busy
                              ? null
                              : () => onRequestClarification(
                                  openVersion!,
                                  priorClarifications,
                                ),
                          icon: const Icon(Icons.help_outline_rounded),
                          label: Text(l10n.requestClarification),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          CustomerInspectorRatingCard(inspectionId: bundle.inspection.id),
        ],
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({
    required this.title,
    required this.done,
    required this.active,
  });

  final String title;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            done
                ? Icons.check_circle_rounded
                : active
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 20,
            color: done
                ? const Color(0xFF16A34A)
                : active
                ? scheme.primary
                : scheme.outline,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? _meaningfulFindingNote(InspectionFinding finding) {
  final note = finding.technicalNotes.trim();
  if (note.isEmpty) return null;
  final lower = note.toLowerCase();
  if (lower == 'none' ||
      lower == 'không có' ||
      lower == finding.defectLabel.trim().toLowerCase()) {
    return null;
  }
  return note;
}

class _InvoiceLine extends StatelessWidget {
  const _InvoiceLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
