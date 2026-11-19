import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/knowledge_recommendation.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Slim collapsible strip of DroneKnowledgeAI historical cases and standards.
/// Hides itself entirely when the endpoint is unavailable or returns nothing.
class KnowledgeReferencesStrip extends ConsumerStatefulWidget {
  const KnowledgeReferencesStrip({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  ConsumerState<KnowledgeReferencesStrip> createState() =>
      _KnowledgeReferencesStripState();
}

class _KnowledgeReferencesStripState
    extends ConsumerState<KnowledgeReferencesStrip> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(
      knowledgeRecommendationsProvider(widget.inspectionId),
    );
    final data = async.value;
    if (data == null || data.isEmpty) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final cases = data.cases;
    final guidelines = data.guidelines;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 16,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.knowledgeMatchesTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (cases.isNotEmpty)
                    _MiniChip(label: l10n.knowledgeCasesCount(cases.length)),
                  if (guidelines.isNotEmpty)
                    _MiniChip(
                      label: l10n.knowledgeStandardsCount(guidelines.length),
                    ),
                  const SizedBox(width: 2),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (!_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final c in cases.take(3))
                    _MiniChip(
                      label: l10n.knowledgeMatchPercent(c.matchPercent),
                      tone: StatusTone.primary,
                    ),
                  for (final g in guidelines.take(3))
                    _MiniChip(label: g.standardCode ?? '—'),
                ],
              ),
            ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final c in cases) _CaseRow(item: c),
                  if (cases.isNotEmpty && guidelines.isNotEmpty)
                    const Divider(height: 12),
                  for (final g in guidelines) _GuidelineRow(item: g),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label, this.tone = StatusTone.neutral});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = statusColorsForTone(context, tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CaseRow extends StatelessWidget {
  const _CaseRow({required this.item});

  final KnowledgeCase item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = [
      if (item.technicalNotes != null && item.technicalNotes!.trim().isNotEmpty)
        item.technicalNotes!.trim(),
      if (item.outcome != null && item.outcome!.trim().isNotEmpty)
        item.outcome!.trim(),
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusPill(
            label: l10n.knowledgeMatchPercent(item.matchPercent),
            tone: statusToneForCode(item.severity),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [
                    if (item.defectLabel != null) item.defectLabel!.trim(),
                    if (item.severity != null)
                      localizedFindingSeverity(l10n, item.severity!),
                  ].where((s) => s.isNotEmpty).join(' · '),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (summary.isNotEmpty)
                  Text(
                    summary,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidelineRow extends StatelessWidget {
  const _GuidelineRow({required this.item});

  final KnowledgeGuideline item;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(item.referenceUrl ?? '');
    final canOpen = uri != null && uri.hasScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusPill(label: item.standardCode ?? '—', tone: StatusTone.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title?.trim().isNotEmpty == true
                      ? item.title!.trim()
                      : '—',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.guidance != null && item.guidance!.trim().isNotEmpty)
                  Text(
                    item.guidance!.trim(),
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (canOpen)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              tooltip: context.l10n.viewDetails,
              onPressed: () =>
                  launchUrl(uri, mode: LaunchMode.externalApplication),
            ),
        ],
      ),
    );
  }
}
