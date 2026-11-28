import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';
import 'package:smart_drone_inspection/features/assets/presentation/providers/asset_list_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

class AssetsPage extends ConsumerStatefulWidget {
  const AssetsPage({super.key});

  @override
  ConsumerState<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends ConsumerState<AssetsPage> {
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
    final asyncAssets = ref.watch(assetListProvider);
    final categories =
        ref.watch(assetCategoriesProvider).value ?? const <AssetCategory>[];
    final categoryNames = {for (final c in categories) c.id: c.name};

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.assetsTitle),
        actions: [
          IconButton(
            tooltip: l10n.notificationsTitle,
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      floatingActionButton: (asyncAssets.value?.isNotEmpty ?? false)
          ? FloatingActionButton.extended(
              key: const Key('register-asset-fab'),
              heroTag: 'register-asset-fab',
              onPressed: () => _showAssetFormDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.registerAsset),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.searchAssetsHint,
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
                  'ACTIVE',
                  'PENDING_REVIEW',
                  'INACTIVE',
                  'RETIRED',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        code == 'ALL'
                            ? l10n.all
                            : localizedAssetStatus(l10n, code),
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
            child: AsyncValueWidget<List<Asset>>(
              value: asyncAssets,
              onRetry: () => ref.read(assetListProvider.notifier).refresh(),
              builder: (assets) {
                final q = _search.text.trim().toLowerCase();
                final filtered = assets.where((asset) {
                  if (_statusFilter != 'ALL' &&
                      asset.status.toUpperCase() != _statusFilter) {
                    return false;
                  }
                  if (q.isEmpty) return true;
                  return asset.name.toLowerCase().contains(q) ||
                      asset.code.toLowerCase().contains(q) ||
                      formatLocationDisplay(asset.locationText)
                          .toLowerCase()
                          .contains(q);
                }).toList();

                if (filtered.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(assetListProvider.notifier).refresh(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 72),
                        EmptyState(
                          icon: Icons.domain_outlined,
                          title: l10n.noAssetsYet,
                          action: FilledButton.icon(
                            onPressed: () => _showAssetFormDialog(context),
                            icon: const Icon(Icons.add_rounded),
                            label: Text(l10n.registerAsset),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(assetListProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final asset = filtered[index];
                      return Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.push('/assets/${asset.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LeadingGlyphBadge(
                                      icon: Icons.domain_rounded,
                                      tone: statusToneForCode(asset.status),
                                      size: 40,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            asset.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${asset.code}${categoryNames[asset.categoryId] != null ? ' · ${categoryNames[asset.categoryId]}' : ''}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    StatusPill(
                                      label: localizedAssetStatus(
                                        l10n,
                                        asset.status,
                                      ),
                                      tone: statusToneForCode(asset.status),
                                      showDot: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.place_outlined,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        formatLocationDisplay(
                                          asset.locationText,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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

  Future<void> _showAssetFormDialog(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _CreateAssetSheet(),
    );
  }
}

class _CreateAssetSheet extends ConsumerStatefulWidget {
  const _CreateAssetSheet();

  @override
  ConsumerState<_CreateAssetSheet> createState() => _CreateAssetSheetState();
}

class _CreateAssetSheetState extends ConsumerState<_CreateAssetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _location = TextEditingController();
  final _description = TextEditingController();
  final _height = TextEditingController();
  final _area = TextEditingController();
  String? _selectedCategoryId;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _location.dispose();
    _description.dispose();
    _height.dispose();
    _area.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final res = await ref
        .read(assetListProvider.notifier)
        .createAsset(
          CreateAssetInput(
            name: _name.text.trim(),
            code: _code.text.trim().toUpperCase(),
            categoryId: _selectedCategoryId!,
            locationText: _location.text.trim(),
            description: _description.text.trim().isEmpty
                ? null
                : _description.text.trim(),
            structureHeightMeters: double.tryParse(_height.text.trim()),
            footprintAreaSquareMeters: double.tryParse(_area.text.trim()),
          ),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (res) {
      case ApiSuccess():
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.assetSavedSuccess)));
      case ApiError(:final failure):
        setState(() => _error = describeApiFailure(context, failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categoriesAsync = ref.watch(assetCategoriesProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.registerAsset,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              if (_error != null) ...[
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: 10),
              ],
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: l10n.assetName),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.required : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _code,
                decoration: InputDecoration(labelText: l10n.assetCode),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.required : null,
              ),
              const SizedBox(height: 12),
              categoriesAsync.when(
                data: (categories) {
                  _selectedCategoryId ??= categories.isNotEmpty
                      ? categories.first.id
                      : null;
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    decoration: InputDecoration(labelText: l10n.assetCategory),
                    items: [
                      for (final c in categories)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                    validator: (v) => v == null ? l10n.required : null,
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (err, _) => Text(err.toString()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _location,
                decoration: InputDecoration(labelText: l10n.assetLocation),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.required : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _height,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.structureHeightMeters,
                      ),
                      validator: (v) {
                        final raw = v?.trim() ?? '';
                        if (raw.isEmpty) return null;
                        final parsed = double.tryParse(raw);
                        if (parsed == null || parsed <= 0) {
                          return '> 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _area,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.footprintAreaSqm,
                      ),
                      validator: (v) {
                        final raw = v?.trim() ?? '';
                        if (raw.isEmpty) return null;
                        final parsed = double.tryParse(raw);
                        if (parsed == null || parsed <= 0) {
                          return '> 0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.assetDescription),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saving ? null : () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _submit,
                      child: Text(_saving ? l10n.saving : l10n.save),
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
