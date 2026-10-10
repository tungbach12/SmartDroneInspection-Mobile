import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspector_assignment.dart';

/// MF2-01: the pairings an administrator opened for this Inspector that are still unanswered.
///
/// This is the entry point to MF2 on the device. Preparation, readiness and the field session all
/// sit downstream of a pairing the Inspector took, so without this an Inspector cannot start the
/// flow from the phone they carry into the field.
final assignmentInboxProvider = FutureProvider<List<InspectorAssignment>>((
  ref,
) async {
  final result = await ref
      .watch(inspectionRepositoryProvider)
      .listMyAssignments();
  switch (result) {
    case ApiSuccess(:final data):
      return data;
    case ApiError(:final failure):
      throw Exception(failure);
  }
});
