import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_assignment.freezed.dart';
part 'inspection_assignment.g.dart';

@freezed
abstract class InspectionAssignment with _$InspectionAssignment {
  const factory InspectionAssignment({
    required String assignmentId,
    required String serviceOrderId,
    required String assetId,
    String? deadline,
    required String status,
    String? inspectionId,
  }) = _InspectionAssignment;

  factory InspectionAssignment.fromJson(Map<String, dynamic> json) =>
      _$InspectionAssignmentFromJson(json);
}
