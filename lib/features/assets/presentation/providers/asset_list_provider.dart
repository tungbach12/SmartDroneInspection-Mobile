import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/assets/data/asset_repository.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';

class AssetListNotifier extends AsyncNotifier<List<Asset>> {
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  @override
  Future<List<Asset>> build() => _fetch();

  Future<List<Asset>> _fetch() async {
    final result = await ref
        .read(assetRepositoryProvider)
        .list(search: _searchQuery.isEmpty ? null : _searchQuery);
    return switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw ApiFailureException(failure),
    };
  }

  Future<void> setSearch(String query) async {
    _searchQuery = query.trim();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<ApiResult<Asset>> createAsset(CreateAssetInput input) async {
    final res = await ref.read(assetRepositoryProvider).create(input);
    if (res is ApiSuccess<Asset>) {
      await refresh();
    }
    return res;
  }

  Future<ApiResult<Asset>> updateAsset(
    String id,
    UpdateAssetInput input,
  ) async {
    final res = await ref.read(assetRepositoryProvider).update(id, input);
    if (res is ApiSuccess<Asset>) {
      await refresh();
    }
    return res;
  }

  Future<ApiResult<Asset>> retireAsset(String id) async {
    final res = await ref.read(assetRepositoryProvider).retire(id);
    if (res is ApiSuccess<Asset>) {
      await refresh();
    }
    return res;
  }
}

final assetListProvider = AsyncNotifierProvider<AssetListNotifier, List<Asset>>(
  AssetListNotifier.new,
);

final assetCategoriesProvider = FutureProvider<List<AssetCategory>>((
  ref,
) async {
  final res = await ref.read(assetRepositoryProvider).listCategories();
  return switch (res) {
    ApiSuccess(:final data) => data,
    ApiError(:final failure) => throw ApiFailureException(failure),
  };
});

final assetDetailProvider = FutureProvider.family<Asset, String>((
  ref,
  assetId,
) async {
  final res = await ref.read(assetRepositoryProvider).getById(assetId);
  return switch (res) {
    ApiSuccess(:final data) => data,
    ApiError(:final failure) => throw ApiFailureException(failure),
  };
});

final assetDocumentsProvider =
    FutureProvider.family<List<AssetDocument>, String>((ref, assetId) async {
      final res = await ref
          .read(assetRepositoryProvider)
          .listDocuments(assetId);
      return switch (res) {
        ApiSuccess(:final data) => data,
        ApiError(:final failure) => throw ApiFailureException(failure),
      };
    });
