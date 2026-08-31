import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_drone_inspection/features/assets/presentation/providers/asset_list_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

/// Assets list — sample screen wiring repository → provider → UI.
class AssetsPage extends ConsumerWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetsAsync = ref.watch(assetListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Assets')),
      body: AsyncValueWidget(
        value: assetsAsync,
        onRetry: () => ref.invalidate(assetListProvider),
        emptyCheck: (assets) => assets.isEmpty,
        builder: (assets) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(assetListProvider),
          child: ListView.separated(
            itemCount: assets.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final asset = assets[index];
              return ListTile(
                leading: const Icon(Icons.apartment),
                title: Text(asset.name),
                subtitle: Text('${asset.assetCode} · ${asset.location ?? '—'}'),
                trailing: Chip(label: Text(asset.status)),
                onTap: () => context.push('/home'),
              );
            },
          ),
        ),
      ),
    );
  }
}
