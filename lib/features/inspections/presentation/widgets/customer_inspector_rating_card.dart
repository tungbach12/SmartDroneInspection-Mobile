import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspector_rating.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';

class CustomerInspectorRatingCard extends ConsumerWidget {
  const CustomerInspectorRatingCard({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bundleAsync = ref.watch(inspectorRatingProvider(inspectionId));

    return bundleAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (bundle) {
        if (bundle == null || bundle.inspectorId == null) {
          return const SizedBox.shrink();
        }
        final myRating = bundle.myRating;
        final canOpen = bundle.canRate;
        if (!canOpen && myRating == null) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFF59E0B),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.inspectorName ?? l10n.inspectorLabel,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        myRating != null
                            ? '${l10n.yourRatingLabel}: ${myRating.overallScore}/5 ★'
                            : l10n.rateInspectorSubtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (canOpen)
                  FilledButton.tonal(
                    key: const Key('rate-inspector-btn'),
                    onPressed: () => _openRatingSheet(context, ref, bundle),
                    child: Text(
                      myRating != null
                          ? l10n.editRatingAction
                          : l10n.rateInspectorAction,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openRatingSheet(
    BuildContext context,
    WidgetRef ref,
    InspectorRatingBundle bundle,
  ) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _RatingFormSheet(
        inspectionId: inspectionId,
        bundle: bundle,
      ),
    );
    if (saved == true) {
      ref.invalidate(inspectorRatingProvider(inspectionId));
      ref.invalidate(inspectionBundleProvider(inspectionId));
    }
  }
}

class _RatingFormSheet extends ConsumerStatefulWidget {
  const _RatingFormSheet({
    required this.inspectionId,
    required this.bundle,
  });

  final String inspectionId;
  final InspectorRatingBundle bundle;

  @override
  ConsumerState<_RatingFormSheet> createState() => _RatingFormSheetState();
}

class _RatingFormSheetState extends ConsumerState<_RatingFormSheet> {
  late int _overallScore;
  late Map<String, int> _criteria;
  late TextEditingController _commentController;
  bool _saving = false;

  static const _defaultCustomerCriteria = <String>[
    'evidenceQuality',
    'communication',
    'professionalism',
  ];

  @override
  void initState() {
    super.initState();
    final my = widget.bundle.myRating;
    _overallScore = my?.overallScore ?? 5;
    final keys = widget.bundle.expectedCriteria.isNotEmpty
        ? widget.bundle.expectedCriteria.map((c) => c.code).toList()
        : widget.bundle.expectedCriteriaKeys.isNotEmpty
            ? widget.bundle.expectedCriteriaKeys
            : _defaultCustomerCriteria;
    _criteria = {
      for (final k in keys) k: my?.criterionScores[k] ?? 5,
    };
    _commentController = TextEditingController(text: my?.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.bundle.myRating != null
                        ? l10n.editRatingAction
                        : l10n.rateInspectorAction,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.ratingOverallLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                _StarSelector(
                  value: _overallScore,
                  size: 30,
                  onChanged: (v) => setState(() => _overallScore = v),
                ),
              ],
            ),
            const Divider(height: 20),
            for (final entry in _criteria.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _criterionLabel(context, l10n, entry.key),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (_criterionDescription(context, entry.key)
                              case final hint?)
                            Text(
                              hint,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                        ],
                      ),
                    ),
                    _StarSelector(
                      value: entry.value,
                      size: 22,
                      onChanged: (v) =>
                          setState(() => _criteria[entry.key] = v),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 2,
              maxLength: 2000,
              decoration: InputDecoration(
                labelText: l10n.ratingCommentHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              key: const Key('submit-inspector-rating-btn'),
              onPressed: _saving ? null : _submit,
              child: Text(_saving ? l10n.savingLabel : l10n.submitRatingAction),
            ),
          ],
        ),
      ),
    );
  }

  String _criterionLabel(BuildContext context, dynamic l10n, String key) {
    final lang = Localizations.localeOf(context).languageCode;
    for (final def in widget.bundle.expectedCriteria) {
      if (def.code == key) {
        return def.localizedLabel(lang);
      }
    }
    return switch (key) {
      'evidenceQuality' => l10n.ratingCriteriaEvidence as String,
      'communication' => l10n.ratingCriteriaCommunication as String,
      'professionalism' => l10n.ratingCriteriaProfessionalism as String,
      _ => key,
    };
  }

  String? _criterionDescription(BuildContext context, String key) {
    final lang = Localizations.localeOf(context).languageCode;
    for (final def in widget.bundle.expectedCriteria) {
      if (def.code == key) {
        final desc = def.localizedDescription(lang)?.trim();
        return desc != null && desc.isNotEmpty ? desc : null;
      }
    }
    return null;
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    final res = await ref
        .read(inspectionRepositoryProvider)
        .upsertInspectorRating(
          inspectionId: widget.inspectionId,
          request: UpsertInspectorRatingRequest(
            overallScore: _overallScore,
            criterionScores: _criteria,
            comment: _commentController.text,
          ),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (res) {
      case ApiSuccess():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.ratingSavedMessage)),
        );
        Navigator.of(context).pop(true);
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(describeApiFailure(context, failure)),
          ),
        );
    }
  }
}

class _StarSelector extends StatelessWidget {
  const _StarSelector({
    required this.value,
    required this.size,
    required this.onChanged,
  });

  final int value;
  final double size;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var star = 1; star <= 5; star++)
          InkResponse(
            radius: size * 0.7,
            onTap: () => onChanged(star),
            child: Icon(
              star <= value ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: const Color(0xFFF59E0B),
            ),
          ),
      ],
    );
  }
}
