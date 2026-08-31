import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

@freezed
abstract class Asset with _$Asset {
  const factory Asset({
    required String id,
    required String name,
    required String assetCode,
    String? description,
    String? location,
    @Default('Active') String status,
    required String createdAt,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}
