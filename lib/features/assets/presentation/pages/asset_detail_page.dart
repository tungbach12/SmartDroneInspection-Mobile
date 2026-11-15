import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/assets/data/asset_repository.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';
import 'package:smart_drone_inspection/features/assets/presentation/providers/asset_list_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

class AssetDetailPage extends ConsumerStatefulWidget {
  const AssetDetailPage({super.key, required this.assetId});

  final String assetId;

  @override
  ConsumerState<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends ConsumerState<AssetDetailPage> {
  bool _busy = false;

  Future<void> _uploadDocument() async {
    final l10n = context.l10n;
    final file = await FilePicker.pickFile();
    if (file == null) return;
    final bytes = await file.readAsBytes();

    setState(() => _busy = true);
    final res = await ref
        .read(assetRepositoryProvider)
        .uploadDocument(
          assetId: widget.assetId,
          bytes: bytes,
          filePath: kIsWeb ? null : file.path,
          fileName: file.name,
        );
    if (!mounted) return;
    setState(() => _busy = false);

    switch (res) {
      case ApiSuccess():
        ref.invalidate(assetDocumentsProvider(widget.assetId));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.documentUploaded)));
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _viewOrSaveDocument(AssetDocument doc) async {
    setState(() => _busy = true);
    final res = await ref
        .read(assetRepositoryProvider)
        .downloadDocumentBytes(assetId: widget.assetId, documentId: doc.id);
    if (!mounted) return;
    setState(() => _busy = false);

    switch (res) {
      case ApiSuccess(:final data):
        if (doc.contentType.startsWith('image/')) {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(doc.fileName),
              content: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(data, fit: BoxFit.contain),
              ),
              actions: [
                TextButton(
                  onPressed: () => _saveBytes(doc.fileName, data),
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
          await _saveBytes(doc.fileName, data);
        }
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _saveBytes(String fileName, Uint8List bytes) async {
    final saved = await FilePicker.saveFile(
      dialogTitle: fileName,
      fileName: fileName,
      bytes: bytes,
    );
    if (!mounted || saved == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.documentSavedTo(fileName))),
    );
  }

  Future<void> _retireAsset(Asset asset) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.retireAsset),
        content: Text(l10n.retireAssetConfirm(asset.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    final res = await ref
        .read(assetListProvider.notifier)
        .retireAsset(asset.id);
    if (!mounted) return;
    setState(() => _busy = false);

    switch (res) {
      case ApiSuccess():
        ref.invalidate(assetDetailProvider(widget.assetId));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.assetRetiredSuccess)));
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _editAsset(Asset asset) async {
    final nameCtrl = TextEditingController(text: asset.name);
    final locCtrl = TextEditingController(
      text: formatLocationDisplay(asset.locationText),
    );
    final descCtrl = TextEditingController(text: asset.description ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.editAsset),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: context.l10n.assetName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locCtrl,
                decoration: InputDecoration(
                  labelText: context.l10n.assetLocation,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: context.l10n.assetDescription,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );

    if (saved != true || !mounted) return;
    setState(() => _busy = true);
    final res = await ref
        .read(assetListProvider.notifier)
        .updateAsset(
          asset.id,
          UpdateAssetInput(
            name: nameCtrl.text.trim(),
            locationText: locCtrl.text.trim(),
            description: descCtrl.text.trim(),
          ),
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (res is ApiSuccess<Asset>) {
      ref.invalidate(assetDetailProvider(widget.assetId));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.assetSavedSuccess)));
    } else if (res is ApiError<Asset>) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(describeApiFailure(context, res.failure))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final assetAsync = ref.watch(assetDetailProvider(widget.assetId));
    final docsAsync = ref.watch(assetDocumentsProvider(widget.assetId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.assetsTitle)),
      body: AsyncValueWidget<Asset>(
        value: assetAsync,
        onRetry: () => ref.invalidate(assetDetailProvider(widget.assetId)),
        builder: (asset) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(assetDetailProvider(widget.assetId));
            ref.invalidate(assetDocumentsProvider(widget.assetId));
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  asset.name,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  asset.code,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          StatusPill(
                            label: localizedAssetStatus(l10n, asset.status),
                            tone: statusToneForCode(asset.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.place_outlined,
                        text: formatLocationDisplay(asset.locationText),
                      ),
                      if (asset.structureHeightMeters != null ||
                          asset.footprintAreaSquareMeters != null) ...[
                        const SizedBox(height: 6),
                        _InfoRow(
                          icon: Icons.straighten_rounded,
                          text: [
                            if (asset.structureHeightMeters != null)
                              '${asset.structureHeightMeters} m',
                            if (asset.footprintAreaSquareMeters != null)
                              '${asset.footprintAreaSquareMeters} m²',
                          ].join(' · '),
                        ),
                      ],
                      if (asset.description != null &&
                          asset.description!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(asset.description!),
                      ],
                      if (asset.inspectionItems.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final item in asset.inspectionItems)
                              Chip(label: Text(item)),
                          ],
                        ),
                      ],
                      if (!asset.isRetired) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _busy
                                    ? null
                                    : () => _editAsset(asset),
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                label: Text(l10n.editAsset),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _busy
                                    ? null
                                    : () => _retireAsset(asset),
                                icon: Icon(
                                  Icons.block_rounded,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                label: Text(
                                  l10n.retireAsset,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                              l10n.assetDocuments,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: _busy ? null : _uploadDocument,
                            icon: const Icon(
                              Icons.upload_file_rounded,
                              size: 18,
                            ),
                            label: Text(l10n.uploadDocument),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AsyncValueWidget<List<AssetDocument>>(
                        value: docsAsync,
                        onRetry: () => ref.invalidate(
                          assetDocumentsProvider(widget.assetId),
                        ),
                        builder: (docs) {
                          if (docs.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(l10n.noDocumentsYet),
                            );
                          }
                          return Column(
                            children: [
                              for (final doc in docs)
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(
                                    doc.contentType.startsWith('image/')
                                        ? Icons.image_outlined
                                        : Icons.description_outlined,
                                  ),
                                  title: Text(doc.fileName),
                                  subtitle: Text(
                                    '${doc.documentType} · ${formatBytes(doc.sizeBytes)}',
                                  ),
                                  trailing: IconButton(
                                    onPressed: _busy
                                        ? null
                                        : () => _viewOrSaveDocument(doc),
                                    icon: const Icon(Icons.download_rounded),
                                  ),
                                  onTap: _busy
                                      ? null
                                      : () => _viewOrSaveDocument(doc),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    );
  }
}
