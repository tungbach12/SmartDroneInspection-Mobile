import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';

class AssetRepository {
  AssetRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<Asset>>> list({int page = 1, String? search}) async {
    try {
      final response = await _dio.get(
        '/assets',
        queryParameters: {
          'page': page,
          'pageSize': 20,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final items = (response.data['items'] as List)
          .map((e) => Asset.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(items);
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }
}

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  return AssetRepository(ref.watch(dioProvider));
});
