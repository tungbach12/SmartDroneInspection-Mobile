/// MF3-01/02 evidence metadata. Bytes are stored in MinIO and accessed via bearer auth.
class InspectionEvidence {
  const InspectionEvidence({
    required this.id,
    required this.inspectionId,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.createdAt,
    this.fieldSessionId,
    this.captureTime,
    this.latitude,
    this.longitude,
    this.isDeleted = false,
    this.locationDescription,
  });

  factory InspectionEvidence.fromJson(Map<String, dynamic> json) {
    return InspectionEvidence(
      id: json['id'] as String,
      inspectionId: (json['inspectionId'] as String?) ?? '',
      fieldSessionId: json['fieldSessionId'] as String?,
      fileName: (json['fileName'] as String?) ?? 'evidence',
      contentType:
          (json['contentType'] as String?) ?? 'application/octet-stream',
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      captureTime: json['captureTime'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: (json['createdAt'] as String?) ?? '',
      isDeleted: (json['isDeleted'] as bool?) ?? false,
      locationDescription: json['locationDescription'] as String?,
    );
  }

  final String id;
  final String inspectionId;
  final String? fieldSessionId;
  final String fileName;
  final String contentType;
  final int sizeBytes;
  final String? captureTime;
  final double? latitude;
  final double? longitude;
  final String createdAt;
  final bool isDeleted;
  final String? locationDescription;

  bool get isImage => contentType.toLowerCase().startsWith('image/');
  bool get isVideo => contentType.toLowerCase().startsWith('video/');
}
