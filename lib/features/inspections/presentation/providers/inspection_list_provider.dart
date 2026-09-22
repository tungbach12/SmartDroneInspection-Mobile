import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_assignment.dart';

class InspectionListNotifier extends AsyncNotifier<List<InspectionAssignment>> {
  @override
  Future<List<InspectionAssignment>> build() async {
    final result = await ref
        .watch(inspectionRepositoryProvider)
        .listAcceptedAssignments();
    return switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw Exception(failure),
    };
  }

  Future<void> start(String assignmentId) async {
    state = const AsyncLoading();
    final result = await ref
        .read(inspectionRepositoryProvider)
        .start(assignmentId);
    switch (result) {
      case ApiSuccess():
        state = await AsyncValue.guard(
          () async => switch (await ref
              .read(inspectionRepositoryProvider)
              .listAcceptedAssignments()) {
            ApiSuccess(:final data) => data,
            ApiError(:final failure) => throw Exception(failure),
          },
        );
      case ApiError(:final failure):
        state = AsyncError(Exception(failure), StackTrace.current);
    }
  }
}

final inspectionListProvider =
    AsyncNotifierProvider<InspectionListNotifier, List<InspectionAssignment>>(
      InspectionListNotifier.new,
    );
