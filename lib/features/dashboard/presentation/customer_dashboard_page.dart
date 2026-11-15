import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/theme/app_theme.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';
import 'package:smart_drone_inspection/features/assets/presentation/providers/asset_list_provider.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/providers/contract_providers.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspections_provider.dart';
import 'package:smart_drone_inspection/features/notifications/presentation/providers/notification_providers.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';
import 'package:smart_drone_inspection/shared/widgets/motion_primitives.dart';
import 'package:smart_drone_inspection/shared/widgets/sdi_logo_mark.dart';

class CustomerDashboardPage extends ConsumerWidget {
  const CustomerDashboardPage({super.key});

  Future<void> _refreshAll(WidgetRef ref) async {
    await Future.wait([
      ref.read(assetListProvider.notifier).refresh(),
      ref.read(inspectionsNotifierProvider.notifier).refresh(),
      ref.read(serviceRequestsProvider.notifier).refresh(),
      ref.read(notificationsProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final assets = ref.watch(assetListProvider).value ?? const <Asset>[];
    final inspections =
        ref.watch(inspectionsNotifierProvider).value ?? const <Inspection>[];
    final requests =
        ref.watch(serviceRequestsProvider).value ?? const <ServiceRequest>[];
    final unreadTotal = ref.watch(totalUnreadBadgeProvider);

    final assetById = {for (final a in assets) a.id: a};
    final activeAssetsCount = assets.where((a) => a.isActive).length;
    final inProgressCount = inspections
        .where((i) => i.status != 'COMPLETED' && i.status != 'CANCELLED')
        .length;
    final publishedReportsCount = inspections
        .where((i) => i.hasPublishedReport)
        .length;
    final settledCount = inspections.where((i) => i.isPaid).length;

    return Scaffold(
      appBar: AppBar(
        title: SdiBrandLockup(
          logoSize: 30,
          subtitle: l10n.customerPortalSubtitle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton.outlined(
              key: const Key('notifications-bell-btn'),
              tooltip: l10n.notificationsTitle,
              onPressed: () => context.push('/notifications'),
              style: IconButton.styleFrom(
                side: BorderSide(color: scheme.outlineVariant),
                backgroundColor: scheme.surfaceContainerLow,
              ),
              icon: Badge.count(
                count: unreadTotal,
                isLabelVisible: unreadTotal > 0,
                child: const Icon(Icons.notifications_outlined, size: 21),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshAll(ref),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            MotionEntrance(
              offset: const Offset(0, 8),
              child: Text(
                l10n.dashboardTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 14),
            MotionEntrance(
              delay: const Duration(milliseconds: 40),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.75,
                children: [
                  _KpiCard(
                    label: l10n.kpiRegisteredAssets,
                    value: '$activeAssetsCount / ${assets.length}',
                    icon: Icons.domain_rounded,
                    tone: StatusTone.primary,
                    onTap: () => context.go('/assets'),
                  ),
                  _KpiCard(
                    label: l10n.kpiInProgress,
                    value: '$inProgressCount',
                    icon: Icons.flight_takeoff_rounded,
                    tone: StatusTone.warning,
                    onTap: () => context.go('/inspections'),
                  ),
                  _KpiCard(
                    label: l10n.kpiOfficialReports,
                    value: '$publishedReportsCount',
                    icon: Icons.description_rounded,
                    tone: StatusTone.primary,
                    onTap: () => context.go('/inspections'),
                  ),
                  _KpiCard(
                    label: l10n.kpiSettledFees,
                    value: '$settledCount',
                    icon: Icons.verified_rounded,
                    tone: StatusTone.success,
                    onTap: () => context.go('/inspections'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            MotionEntrance(
              delay: const Duration(milliseconds: 80),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryGradientButton(
                      height: 48,
                      icon: Icons.add_rounded,
                      label: l10n.quickActionNewRequest,
                      onPressed: () => context.push('/requests/new'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/assets'),
                      icon: const Icon(Icons.domain_add_outlined, size: 18),
                      label: Text(l10n.quickActionRegisterAsset),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            _SectionHeader(
              title: l10n.recentInspectionsTitle,
              actionLabel: l10n.viewAll,
              onAction: () => context.go('/inspections'),
            ),
            const SizedBox(height: 8),
            if (inspections.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.noInspectionsYet),
                ),
              )
            else
              MotionEntrance(
                delay: const Duration(milliseconds: 110),
                child: Column(
                  children: [
                    for (final item in inspections.take(4)) ...[
                      _DashboardItemRow(
                        icon: Icons.flight_takeoff_rounded,
                        tone: statusToneForCode(
                          item.hasPublishedReport
                              ? item.paymentStatus
                              : item.status,
                        ),
                        title:
                            item.assetName ??
                            assetById[item.assetId]?.name ??
                            '#${item.id.substring(0, 8)}',
                        subtitle:
                            '${formatDateShort(item.plannedStartAt)} · ${localizedInspectionStatus(l10n, item.status)}',
                        pillLabel: item.hasPublishedReport
                            ? localizedPaymentStatus(
                                l10n,
                                item.paymentStatus ?? 'PAYMENT_DUE',
                              )
                            : localizedInspectionStatus(l10n, item.status),
                        pillTone: statusToneForCode(
                          item.hasPublishedReport
                              ? item.paymentStatus
                              : item.status,
                        ),
                        onTap: () => context.push('/inspections/${item.id}'),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 16),

            _SectionHeader(
              title: '${l10n.requestsTitle} (${requests.length})',
              actionLabel: l10n.viewAll,
              onAction: () => context.go('/requests'),
            ),
            const SizedBox(height: 8),
            if (requests.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.nothingHereYet),
                ),
              )
            else
              for (final req in requests.take(2)) ...[
                _DashboardItemRow(
                  icon: Icons.assignment_outlined,
                  tone: statusToneForCode(req.effectiveStatus),
                  title: assetById[req.assetId]?.name ?? req.description,
                  subtitle: formatDateShort(req.requestedFrom),
                  pillLabel: localizedServiceRequestStatus(
                    l10n,
                    req.effectiveStatus,
                  ),
                  pillTone: statusToneForCode(req.effectiveStatus),
                  onTap: () => context.push('/requests/${req.id}'),
                ),
                const SizedBox(height: 8),
              ],
            const SizedBox(height: 16),
            _SectionHeader(
              title: l10n.assetOverviewTitle,
              actionLabel: l10n.viewAll,
              onAction: () => context.go('/assets'),
            ),
            const SizedBox(height: 8),
            if (assets.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.noAssetsYet),
                ),
              )
            else
              for (final asset in assets.take(4)) ...[
                _DashboardItemRow(
                  icon: Icons.domain_rounded,
                  tone: statusToneForCode(asset.status),
                  title: asset.name,
                  subtitle:
                      '${asset.code} · ${formatLocationDisplay(asset.locationText)}',
                  pillLabel: localizedAssetStatus(l10n, asset.status),
                  pillTone: statusToneForCode(asset.status),
                  onTap: () => context.push('/assets/${asset.id}'),
                ),
                const SizedBox(height: 8),
              ],
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final StatusTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: AppTheme.cardShadow(context),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LeadingGlyphBadge(icon: icon, tone: tone, size: 30),
                  const Spacer(),
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 14,
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.65),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 21,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardItemRow extends StatelessWidget {
  const _DashboardItemRow({
    required this.icon,
    required this.tone,
    required this.title,
    required this.subtitle,
    required this.pillLabel,
    required this.pillTone,
    required this.onTap,
  });

  final IconData icon;
  final StatusTone tone;
  final String title;
  final String subtitle;
  final String pillLabel;
  final StatusTone pillTone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              LeadingGlyphBadge(icon: icon, tone: tone, size: 38),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusPill(label: pillLabel, tone: pillTone, showDot: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}
