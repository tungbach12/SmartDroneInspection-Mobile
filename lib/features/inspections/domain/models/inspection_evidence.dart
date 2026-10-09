import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_evidence.freezed.dart';
part 'inspection_evidence.g.dart';

/// MF3-01/02 evidence metadata. The bytes live in object storage; the server computes the
/// checksum and treats a repeated upload of the same file as idempotent.
@freezed
abstract class InspectionEvidence with _$InspectionEvidence {
  const factory InspectionEvidence({
    required String id,
    required String inspectionId,
    String? fieldSessionId,
    required String fileName,
    required String contentType,
    required int sizeBytes,
    required String checksumSha256,
    String? captureTime,
    required String source,
    double? latitude,
    double? longitude,
    String? externalReference,
    required String uploadStatus,
    required String createdAt,
  }) = _InspectionEvidence;

  factory InspectionEvidence.fromJson(Map<String, dynamic> json) =>
      _$InspectionEvidenceFromJson(json);
}
