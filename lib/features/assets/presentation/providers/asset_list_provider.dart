import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/assets/data/asset_repository.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';

/// Assets list state: fetches on build, invalidate to refresh.
class AssetListNotifier extends AsyncNotifier<List<Asset>> {
  @override
  Future<List<Asset>> build() async {
    final result = await ref.watch(assetRepositoryProvider).list();
    return switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw Exception(failure),
    };
  }
}

final assetListProvider = AsyncNotifierProvider<AssetListNotifier, List<Asset>>(
  AssetListNotifier.new,
);
