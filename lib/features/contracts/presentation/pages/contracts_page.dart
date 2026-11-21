import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';
import 'package:smart_drone_inspection/features/assets/presentation/providers/asset_list_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/providers/contract_providers.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

class ContractsPage extends ConsumerStatefulWidget {
  const ContractsPage({super.key});

  @override
  ConsumerState<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends ConsumerState<ContractsPage> {
  final _search = TextEditingController();
  String _statusFilter = 'ALL';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final asyncRequests = ref.watch(serviceRequestsProvider);
    final assets = ref.watch(assetListProvider).value ?? const <Asset>[];
    final assetById = {for (final a in assets) a.id: a};
    final currentUserId = ref.watch(authNotifierProvider).value?.user?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.requestsTitle),
        actions: [
          IconButton(
            tooltip: l10n.notificationsTitle,
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      floatingActionButton: (asyncRequests.value?.isNotEmpty ?? false)
          ? FloatingActionButton.extended(
              key: const Key('new-service-request-fab'),
              heroTag: 'new-service-request-fab',
              onPressed: () => context.push('/requests/new'),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.newServiceRequest),
            )
          : null,
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
                for (final code in const [
                  'ALL',
                  'OPEN',
                  'QUOTED',
                  'ACCEPTED',
                  'CONTRACT_SIGNED',
                  'ASSIGNED',
                  'CANCELLED',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        code == 'ALL'
                            ? l10n.all
                            : localizedServiceRequestStatus(l10n, code),
                      ),
                      selected: _statusFilter == code,
                      onSelected: (_) => setState(() => _statusFilter = code),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AsyncValueWidget<List<ServiceRequest>>(
              value: asyncRequests,
              onRetry: () =>
                  ref.read(serviceRequestsProvider.notifier).refresh(),
              builder: (requests) {
                final q = _search.text.trim().toLowerCase();
                final filtered = requests.where((req) {
                  final eff = req.effectiveStatus;
                  if (_statusFilter != 'ALL' && eff != _statusFilter) {
                    return false;
                  }
                  if (q.isEmpty) return true;
                  final asset = assetById[req.assetId];
                  return req.description.toLowerCase().contains(q) ||
                      (asset?.name.toLowerCase().contains(q) ?? false) ||
                      (asset?.code.toLowerCase().contains(q) ?? false);
                }).toList();

                if (filtered.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(serviceRequestsProvider.notifier).refresh(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 72),
                        EmptyState(
                          icon: Icons.assignment_outlined,
                          title: l10n.nothingHereYet,
                          action: FilledButton.icon(
                            onPressed: () => context.push('/requests/new'),
                            icon: const Icon(Icons.add_rounded),
                            label: Text(l10n.newServiceRequest),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(serviceRequestsProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final req = filtered[index];
                      final asset = assetById[req.assetId];
                      final status = req.effectiveStatus;
                      final unread = req.unreadCountForUser(currentUserId);
                      final price = req.currentQuote?.pricePerOccurrenceVnd;

                      return Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.push('/requests/${req.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LeadingGlyphBadge(
                                      icon: Icons.assignment_outlined,
                                      tone: statusToneForCode(status),
                                      size: 40,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        asset != null
                                            ? '${asset.name} (${asset.code})'
                                            : '#${req.id.substring(0, 8)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    StatusPill(
                                      label: localizedServiceRequestStatus(
                                        l10n,
                                        status,
                                      ),
                                      tone: statusToneForCode(status),
                                      showDot: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                if (req.description.isNotEmpty)
                                  Text(
                                    req.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      '${formatDateShort(req.requestedFrom)} · ${req.requestType == 'RECURRING' ? l10n.requestTypeRecurring : l10n.requestTypeOneTime}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                    const Spacer(),
                                    if (price != null && price > 0)
                                      Text(
                                        formatVnd(price),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    if (unread > 0) ...[
                                      const SizedBox(width: 8),
                                      StatusPill(
                                        label: l10n.unreadMessagesBadge(unread),
                                        tone: StatusTone.warning,
                                        icon: Icons.chat_bubble_outline,
                                      ),
                                    ],
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
