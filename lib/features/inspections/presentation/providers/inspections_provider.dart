import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';

final inspectionsProvider = FutureProvider<List<Inspection>>((ref) async {
  final result =
      await ref.watch(inspectionRepositoryProvider).listInspections();
  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiError(:final failure) => throw ApiFailureException(failure),
  };
});
