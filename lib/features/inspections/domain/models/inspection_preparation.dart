import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_preparation.freezed.dart';
part 'inspection_preparation.g.dart';

@freezed
abstract class InspectionPreparation with _$InspectionPreparation {
  const factory InspectionPreparation({
    required String id,
    required String inspectionId,
    required String inspectorUserId,
    required int preparationVersion,
    required String shotList,
    String? evidenceTypes,
    String? accessConstraints,
    String? safetyObservations,
    String? permitDocumentReferences,
    String? status,
    String? submittedAt,
    DateTime? plannedStartAt,
    DateTime? plannedEndAt,
  }) = _InspectionPreparation;

  factory InspectionPreparation.fromJson(Map<String, dynamic> json) =>
      _$InspectionPreparationFromJson(json);
}
