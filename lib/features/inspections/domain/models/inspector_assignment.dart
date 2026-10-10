import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspector_assignment.freezed.dart';
part 'inspector_assignment.g.dart';

/// MF2-01/02: one Inspector–Drone pairing an administrator opened for this Inspector.
///
/// The asset name, the Drone serial and the validity window travel with the record so the Inspector
/// can answer on the device without opening three other screens. Accepting is not readiness: it
/// records that the Inspector took the job, and MF2-07 decides separately whether the mission may
/// fly.
@freezed
abstract class InspectorAssignment with _$InspectorAssignment {
  const factory InspectorAssignment({
    required String id,
    required String organizationId,
    required String assetId,
    required String assetName,
    required String inspectorUserId,
    required String droneId,
    required String droneSerialNumber,
    required String droneServiceability,
    String? validFrom,
    String? validUntil,
    required String status,
    String? reason,
    String? assignmentResponse,
    String? respondedAt,
    required String assignedAt,
  }) = _InspectorAssignment;

  const InspectorAssignment._();

  factory InspectorAssignment.fromJson(Map<String, dynamic> json) =>
      _$InspectorAssignmentFromJson(json);
}

/// Presentation helpers that read a pairing's stored state.
///
/// These live outside the generated model rather than inside the `@freezed` class: Freezed 4
/// generates a mixin, and a getter declared in the annotated class has nowhere to attach.
extension InspectorAssignmentState on InspectorAssignment {
  /// Whether the Inspector may still answer. A suspended pairing cannot be flown.
  bool get isOpen => status == 'ACTIVE' && assignmentResponse == null;
}
