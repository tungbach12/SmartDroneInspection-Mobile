import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_evidence.freezed.dart';
part 'inspection_evidence.g.dart';

@freezed
abstract class InspectionEvidence with _$InspectionEvidence {
  const factory InspectionEvidence({
    required String evidenceId,
    required String fileName,
    required String contentType,
    required int sizeBytes,
    required String checksumSha256,
    required String source,
    String? captureTime,
    double? latitude,
    double? longitude,
    String? externalReference,
    required String uploadStatus,
    required String createdAt,
  }) = _InspectionEvidence;

  factory InspectionEvidence.fromJson(Map<String, dynamic> json) =>
      _$InspectionEvidenceFromJson(json);
}
