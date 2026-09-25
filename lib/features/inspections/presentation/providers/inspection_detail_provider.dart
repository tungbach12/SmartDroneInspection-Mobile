import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_checklist_item.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';

typedef PickInspectionPhoto = Future<XFile?> Function();

final inspectionPhotoPickerProvider = Provider<PickInspectionPhoto>((ref) {
  final picker = ImagePicker();
  return () => picker.pickImage(source: ImageSource.camera, imageQuality: 90);
});

final inspectionChecklistProvider =
    FutureProvider.family<List<InspectionChecklistItem>, String>((
      ref,
      id,
    ) async {
      final result = await ref
          .watch(inspectionRepositoryProvider)
          .checklist(id);
      return switch (result) {
        ApiSuccess(:final data) => data,
        ApiError(:final failure) => throw Exception(failure),
      };
    });

final inspectionEvidenceProvider =
    FutureProvider.family<List<InspectionEvidence>, String>((ref, id) async {
      final result = await ref
          .watch(inspectionRepositoryProvider)
          .listEvidence(id);
      return switch (result) {
        ApiSuccess(:final data) => data,
        ApiError(:final failure) => throw Exception(failure),
      };
    });
