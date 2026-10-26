import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection.freezed.dart';
part 'inspection.g.dart';

@freezed
abstract class Inspection with _$Inspection {
  const factory Inspection({
    required String id,
    required String assetId,
    String? assetName,
    String? droneSerialNumber,
    String? droneModel,
    required String status,
    String? flightPermitFileKey,
    String? flightPermitFileName,
    String? flightPermitUploadedAt,
    @Default(<String>[]) List<String> inspectionItems,
  }) = _Inspection;

  const Inspection._();

  factory Inspection.fromJson(Map<String, dynamic> json) =>
      _$InspectionFromJson(json);
}

extension InspectionStatusExtension on Inspection {
  bool get isAssigned => status == 'ASSIGNED';
  bool get isReadyForFlight => status == 'READY_FOR_FLIGHT';
  bool get isInProgress => status == 'IN_PROGRESS';
  bool get isFieldCompleted => status == 'FIELD_COMPLETED';
  bool get hasFlightPermit =>
      flightPermitFileKey != null && flightPermitFileKey!.isNotEmpty;
}
