import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';

typedef PickInspectionPhoto = Future<XFile?> Function();
final inspectionPhotoPickerProvider = Provider<PickInspectionPhoto>((ref) {
  final picker = ImagePicker();
  return () => picker.pickImage(source: ImageSource.camera, imageQuality: 90);
});

typedef PickFlightPermitFile = Future<XFile?> Function();
final flightPermitPickerProvider = Provider<PickFlightPermitFile>((ref) {
  final picker = ImagePicker();
  return () => picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
});

final inspectionDetailProvider =
    FutureProvider.family<Inspection, String>((ref, id) async {
  final result =
      await ref.watch(inspectionRepositoryProvider).getInspection(id);
  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiError(:final failure) => throw ApiFailureException(failure),
  };
});

final inspectionEvidenceProvider =
    FutureProvider.family<List<InspectionEvidence>, String>((ref, id) async {
  final result =
      await ref.watch(inspectionRepositoryProvider).listEvidence(id);
  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiError(:final failure) => throw ApiFailureException(failure),
  };
});
