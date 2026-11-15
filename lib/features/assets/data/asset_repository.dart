import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';

class AssetRepository {
  AssetRepository(this._dio);

  final Dio _dio;

  Future<ApiResult<List<Asset>>> list({
    int page = 1,
    int pageSize = 50,
    String? search,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/assets',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final data = response.data;
      final List<dynamic> rawItems;
      if (data is Map && data['items'] is List) {
        rawItems = data['items'] as List<dynamic>;
      } else if (data is List) {
        rawItems = data;
      } else {
        rawItems = const <dynamic>[];
      }
      final items = rawItems
          .map((e) => Asset.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return ApiResult.success(items);
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<Asset>> getById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/assets/$id');
      return ApiResult.success(Asset.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<Asset>> create(CreateAssetInput input) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/assets',
        data: input.toJson(),
      );
      return ApiResult.success(Asset.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<Asset>> update(String id, UpdateAssetInput input) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/assets/$id',
        data: input.toJson(),
      );
      return ApiResult.success(Asset.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<Asset>> retire(String id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/assets/$id/retire',
      );
      return ApiResult.success(Asset.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<List<AssetCategory>>> listCategories() async {
    try {
      final response = await _dio.get<dynamic>('/asset-categories');
      final list = response.data is List
          ? response.data as List<dynamic>
          : const <dynamic>[];
      return ApiResult.success(
        list
            .map(
              (e) =>
                  AssetCategory.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .where((c) => c.active)
            .toList(),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<List<AssetDocument>>> listDocuments(String assetId) async {
    try {
      final response = await _dio.get<dynamic>('/assets/$assetId/documents');
      final list = response.data is List
          ? response.data as List<dynamic>
          : const <dynamic>[];
      return ApiResult.success(
        list
            .map(
              (e) =>
                  AssetDocument.fromJson(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }

  Future<ApiResult<AssetDocument>> uploadDocument({
    required String assetId,
    required String fileName,
    String? filePath,
    Uint8List? bytes,
    String documentType = 'OTHER',
  }) async {
    try {
      final MultipartFile multipart;
      if (bytes != null) {
        multipart = MultipartFile.fromBytes(bytes, filename: fileName);
      } else if (filePath != null && filePath.isNotEmpty) {
        multipart = await MultipartFile.fromFile(filePath, filename: fileName);
      } else {
        return const ApiResult.failure(
          ApiFailure.unknown('Missing file payload for upload.'),
        );
      }
      final form = FormData.fromMap({
        'file': multipart,
        'documentType': documentType,
      });
      final response = await _dio.post<Map<String, dynamic>>(
        '/assets/$assetId/documents',
        data: form,
      );
      return ApiResult.success(AssetDocument.fromJson(response.data!));
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    } on Exception catch (e) {
      return ApiResult.failure(ApiFailure.unknown(e.toString()));
    }
  }

  Future<ApiResult<Uint8List>> downloadDocumentBytes({
    required String assetId,
    required String documentId,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        '/assets/$assetId/documents/$documentId/content',
        options: Options(responseType: ResponseType.bytes),
      );
      return ApiResult.success(
        Uint8List.fromList(response.data ?? const <int>[]),
      );
    } on DioException catch (e) {
      return ApiResult.failure(mapDioError(e));
    }
  }
}

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  return AssetRepository(ref.watch(dioProvider));
});
