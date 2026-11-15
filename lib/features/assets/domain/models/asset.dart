class Asset {
  const Asset({
    required this.id,
    required this.code,
    required this.name,
    required this.locationText,
    required this.status,
    required this.categoryId,
    required this.createdAt,
    this.description,
    this.latitude,
    this.longitude,
    this.inspectionItems = const <String>[],
    this.structureHeightMeters,
    this.footprintAreaSquareMeters,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['inspectionItems'];
    return Asset(
      id: json['id'] as String,
      code: (json['code'] ?? json['assetCode'] ?? '') as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      locationText: (json['locationText'] ?? json['location'] ?? '') as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: (json['status'] as String?) ?? 'ACTIVE',
      categoryId: (json['categoryId'] as String?) ?? '',
      createdAt: (json['createdAt'] as String?) ?? '',
      inspectionItems: itemsRaw is List
          ? itemsRaw.map((e) => e.toString()).toList()
          : const <String>[],
      structureHeightMeters: (json['structureHeightMeters'] as num?)
          ?.toDouble(),
      footprintAreaSquareMeters: (json['footprintAreaSquareMeters'] as num?)
          ?.toDouble(),
    );
  }

  final String id;
  final String code;
  final String name;
  final String? description;
  final String locationText;
  final double? latitude;
  final double? longitude;
  final String status;
  final String categoryId;
  final String createdAt;
  final List<String> inspectionItems;
  final double? structureHeightMeters;
  final double? footprintAreaSquareMeters;

  bool get isActive => status.toUpperCase() == 'ACTIVE';
  bool get isRetired => status.toUpperCase() == 'RETIRED';
}

class AssetCategory {
  const AssetCategory({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.active = true,
  });

  factory AssetCategory.fromJson(Map<String, dynamic> json) {
    return AssetCategory(
      id: json['id'] as String,
      code: (json['code'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      description: json['description'] as String?,
      active: (json['active'] as bool?) ?? true,
    );
  }

  final String id;
  final String code;
  final String name;
  final String? description;
  final bool active;
}

class AssetDocument {
  const AssetDocument({
    required this.id,
    required this.documentType,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.createdAt,
    this.documentDate,
  });

  factory AssetDocument.fromJson(Map<String, dynamic> json) {
    return AssetDocument(
      id: json['id'] as String,
      documentType: (json['documentType'] as String?) ?? 'OTHER',
      fileName: (json['fileName'] as String?) ?? 'document',
      contentType:
          (json['contentType'] as String?) ?? 'application/octet-stream',
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      documentDate: json['documentDate'] as String?,
      createdAt: (json['createdAt'] as String?) ?? '',
    );
  }

  final String id;
  final String documentType;
  final String fileName;
  final String contentType;
  final int sizeBytes;
  final String? documentDate;
  final String createdAt;
}

class CreateAssetInput {
  const CreateAssetInput({
    required this.name,
    required this.code,
    required this.categoryId,
    required this.locationText,
    this.description,
    this.latitude,
    this.longitude,
    this.structureHeightMeters,
    this.footprintAreaSquareMeters,
    this.inspectionItems = const <String>[],
  });

  final String name;
  final String code;
  final String categoryId;
  final String locationText;
  final String? description;
  final double? latitude;
  final double? longitude;
  final double? structureHeightMeters;
  final double? footprintAreaSquareMeters;
  final List<String> inspectionItems;

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'categoryId': categoryId,
    'locationText': locationText,
    if (description != null && description!.isNotEmpty)
      'description': description,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    if (structureHeightMeters != null)
      'structureHeightMeters': structureHeightMeters,
    if (footprintAreaSquareMeters != null)
      'footprintAreaSquareMeters': footprintAreaSquareMeters,
    if (inspectionItems.isNotEmpty) 'inspectionItems': inspectionItems,
  };
}

class UpdateAssetInput {
  const UpdateAssetInput({
    this.name,
    this.description,
    this.locationText,
    this.latitude,
    this.longitude,
    this.structureHeightMeters,
    this.footprintAreaSquareMeters,
  });

  final String? name;
  final String? description;
  final String? locationText;
  final double? latitude;
  final double? longitude;
  final double? structureHeightMeters;
  final double? footprintAreaSquareMeters;

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (description != null) 'description': description,
    if (locationText != null) 'locationText': locationText,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    if (structureHeightMeters != null)
      'structureHeightMeters': structureHeightMeters,
    if (footprintAreaSquareMeters != null)
      'footprintAreaSquareMeters': footprintAreaSquareMeters,
  };
}
