import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';

class InspectionsNotifier extends AsyncNotifier<List<Inspection>> {
  @override
  Future<List<Inspection>> build() => _fetch();

  Future<List<Inspection>> _fetch() async {
    final result = await ref
        .read(inspectionRepositoryProvider)
        .listInspections();
    return switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw ApiFailureException(failure),
    };
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }
}

final inspectionsNotifierProvider =
    AsyncNotifierProvider<InspectionsNotifier, List<Inspection>>(
      InspectionsNotifier.new,
    );
