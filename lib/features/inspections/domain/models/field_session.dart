import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_session.freezed.dart';
part 'field_session.g.dart';

/// MF2-09 to MF2-11: one field session under an inspection.
///
/// The session records the readiness decision it started against, so a later audit can answer which
/// approval the field work relied on rather than "some approval, at some point". `startedAt` is the
/// software's session start and is not hardware flight time; nothing here arms a Drone.
@freezed
abstract class FieldSession with _$FieldSession {
  const factory FieldSession({
    required String id,
    required String inspectionId,
    required String organizationId,
    required String inspectorUserId,
    String? droneId,
    String? readinessDecisionId,
    String? checklistTemplateId,
    int? readinessVersion,
    required String status,
    String? startedAt,
    String? endedAt,
    String? postponementReason,
    String? abortReason,
  }) = _FieldSession;

  const FieldSession._();

  factory FieldSession.fromJson(Map<String, dynamic> json) =>
      _$FieldSessionFromJson(json);
}

/// Presentation helpers that read a session's stored state.
///
/// These live outside the generated model rather than inside the `@freezed` class: Freezed 4
/// generates a mixin, and a getter declared in the annotated class has nowhere to attach.
extension FieldSessionStatus on FieldSession {
  /// Whether this session still occupies the inspection, so a new start would be refused.
  bool get isOpen => status == 'PLANNED' || status == 'IN_PROGRESS';

  /// Whether the session was stopped by weather or site safety and may be attempted again.
  bool get isPostponed => status == 'POSTPONED';

  /// Whether the session ended and will not resume under this record.
  bool get isAborted => status == 'ABORTED';
}
