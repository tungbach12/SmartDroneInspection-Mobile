import 'package:freezed_annotation/freezed_annotation.dart';

part 'started_inspection.freezed.dart';
part 'started_inspection.g.dart';

@freezed
abstract class StartedInspection with _$StartedInspection {
  const factory StartedInspection({
    required String inspectionId,
    required String assignmentId,
    required String serviceOrderId,
    required String assetId,
    required String checklistTemplateId,
    required String status,
    required String startedAt,
  }) = _StartedInspection;

  factory StartedInspection.fromJson(Map<String, dynamic> json) =>
      _$StartedInspectionFromJson(json);
}
