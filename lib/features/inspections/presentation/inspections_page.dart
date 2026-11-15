import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';
import 'package:smart_drone_inspection/features/assets/presentation/providers/asset_list_provider.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/providers/contract_providers.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspections_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

class InspectionsPage extends ConsumerStatefulWidget {
  const InspectionsPage({super.key});

  @override
  ConsumerState<InspectionsPage> createState() => _InspectionsPageState();
}

class _InspectionsPageState extends ConsumerState<InspectionsPage> {
  final _search = TextEditingController();
  String _quickFilter = 'ALL';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inspectionsAsync = ref.watch(inspectionsNotifierProvider);
    final assets = ref.watch(assetListProvider).value ?? const <Asset>[];
    final assetById = {for (final a in assets) a.id: a};
    final requests =
        ref.watch(serviceRequestsProvider).value ?? const <ServiceRequest>[];

    final occByInspectionId = <String, ServiceRequestOccurrence>{};
    final descByInspectionId = <String, String>{};
    for (final req in requests) {
      for (final occ in req.occurrences) {
        if (occ.inspectionId != null) {
          occByInspectionId[occ.inspectionId!] = occ;
          if (req.description.isNotEmpty) {
            descByInspectionId[occ.inspectionId!] = req.description;
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inspectionsTitle),
        actions: [
          IconButton(
            tooltip: l10n.notificationsTitle,
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.searchRequestsHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _search.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close_rounded),
                      )
                    : null,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final item in [
                  ('ALL', l10n.filterAll),
                  ('IN_PROGRESS', l10n.filterInProgress),
                  ('REPORT_READY', l10n.filterReportReady),
                  ('ACTION_NEEDED', l10n.filterActionNeeded),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(item.$2),
                      selected: _quickFilter == item.$1,
                      onSelected: (_) => setState(() => _quickFilter = item.$1),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AsyncValueWidget<List<Inspection>>(
              value: inspectionsAsync,
              onRetry: () =>
                  ref.read(inspectionsNotifierProvider.notifier).refresh(),
              builder: (items) {
                final q = _search.text.trim().toLowerCase();
                final filtered = items.where((row) {
                  final occ = occByInspectionId[row.id];
                  final reportPublished = row.reportStatus == 'PUBLISHED';
                  final paymentStatus =
                      (row.paymentStatus ??
                              occ?.paymentStatus ??
                              'NOT_APPLICABLE')
                          .toUpperCase();
                  final isPaid = paymentStatus == 'PAID';
                  final isAccepted =
                      reportPublished &&
                      ((row.reportAccepted ?? false) ||
                          occ?.reportAcceptedAt != null ||
                          isPaid);
                  final actionNeeded =
                      reportPublished && (!isAccepted || !isPaid);

                  if (_quickFilter == 'IN_PROGRESS' &&
                      (row.status == 'COMPLETED' ||
                          row.status == 'CANCELLED')) {
                    return false;
                  }
                  if (_quickFilter == 'REPORT_READY' && !reportPublished) {
                    return false;
                  }
                  if (_quickFilter == 'ACTION_NEEDED' && !actionNeeded) {
                    return false;
                  }

                  if (q.isEmpty) return true;
                  final asset = assetById[row.assetId];
                  final name = (row.assetName ?? asset?.name ?? '')
                      .toLowerCase();
                  final code = (row.assetCode ?? asset?.code ?? '')
                      .toLowerCase();
                  final obj =
                      (row.objective ?? descByInspectionId[row.id] ?? '')
                          .toLowerCase();
                  return name.contains(q) ||
                      code.contains(q) ||
                      obj.contains(q);
                }).toList();

                if (filtered.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => ref
                        .read(inspectionsNotifierProvider.notifier)
                        .refresh(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 72),
                        EmptyState(
                          icon: Icons.flight_takeoff_rounded,
                          title: l10n.noInspectionsYet,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(inspectionsNotifierProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final row = filtered[index];
                      final asset = assetById[row.assetId];
                      final occ = occByInspectionId[row.id];
                      final assetTitle =
                          row.assetName ??
                          asset?.name ??
                          '#${row.assetId.substring(0, 8)}';
                      final assetCode = row.assetCode ?? asset?.code;
                      final objective =
                          row.objective ?? descByInspectionId[row.id];
                      final amount = row.paymentAmount ?? occ?.totalPrice;
                      final payStatus =
                          (row.paymentStatus ?? occ?.paymentStatus ?? '')
                              .toUpperCase();

                      return Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.push('/inspections/${row.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LeadingGlyphBadge(
                                      icon: Icons.flight_takeoff_rounded,
                                      tone: statusToneForCode(row.status),
                                      size: 40,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            assetCode != null
                                                ? '$assetTitle ($assetCode)'
                                                : assetTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          if (objective != null &&
                                              objective.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              objective,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    StatusPill(
                                      label: localizedInspectionStatus(
                                        l10n,
                                        row.status,
                                      ),
                                      tone: statusToneForCode(row.status),
                                      showDot: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    if (row.plannedStartAt != null)
                                      Text(
                                        formatDateShort(row.plannedStartAt),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    if (row.reportStatus != null)
                                      StatusPill(
                                        label:
                                            '${localizedReportStatus(l10n, row.reportStatus!)} ${row.reportVersionNo != null ? 'v${row.reportVersionNo}' : ''}'
                                                .trim(),
                                        tone: statusToneForCode(
                                          row.reportStatus,
                                        ),
                                      ),
                                    if (row.hasPublishedReport &&
                                        payStatus.isNotEmpty)
                                      StatusPill(
                                        label: localizedPaymentStatus(
                                          l10n,
                                          payStatus,
                                        ),
                                        tone: statusToneForCode(payStatus),
                                      ),
                                    if (amount != null && amount > 0)
                                      Text(
                                        formatVnd(amount),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
