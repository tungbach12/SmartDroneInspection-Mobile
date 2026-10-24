import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_evidence.freezed.dart';
part 'inspection_evidence.g.dart';

/// MF3-01/02 evidence metadata. The bytes live in object storage; retired evidence remains stored.
@freezed
abstract class InspectionEvidence with _$InspectionEvidence {
  const factory InspectionEvidence({
    required String id,
    required String inspectionId,
    String? fieldSessionId,
    required String fileName,
    required String contentType,
    required int sizeBytes,
    String? captureTime,
    double? latitude,
    double? longitude,
    required String createdAt,
    @Default(false) bool isDeleted,
  }) = _InspectionEvidence;

  factory InspectionEvidence.fromJson(Map<String, dynamic> json) =>
      _$InspectionEvidenceFromJson(json);
}
