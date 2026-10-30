import 'package:file_picker/file_picker.dart';
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
  return () async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (picked == null) return null;
    return picked.xFile;
  };
});

typedef PickInspectionVideo = Future<XFile?> Function();
final inspectionVideoPickerProvider = Provider<PickInspectionVideo>((ref) {
  return () async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );
    if (picked == null) return null;
    return picked.xFile;
  };
});

class EvidenceUploadLimit {
  static const int maxBytes = 10 * 1024 * 1024;

  const EvidenceUploadLimit._();
}

final inspectionDetailProvider = FutureProvider.family<Inspection, String>((
  ref,
  id,
) async {
  final result = await ref
      .watch(inspectionRepositoryProvider)
      .getInspection(id);
  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiError(:final failure) => throw ApiFailureException(failure),
  };
});

final inspectionEvidenceProvider =
    FutureProvider.family<List<InspectionEvidence>, String>((ref, id) async {
      final result = await ref
          .watch(inspectionRepositoryProvider)
          .listEvidence(id);
      return switch (result) {
        ApiSuccess(:final data) => data,
        ApiError(:final failure) => throw ApiFailureException(failure),
      };
    });
