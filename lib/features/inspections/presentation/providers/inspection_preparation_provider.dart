import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_preparation.dart';

final inspectionPreparationsProvider =
    FutureProvider.family<List<InspectionPreparation>, String>((ref, id) async {
      final result = await ref
          .watch(inspectionRepositoryProvider)
          .listPreparations(id);
      return switch (result) {
        ApiSuccess(:final data) => data,
        ApiError(:final failure) => throw ApiFailureException(failure),
      };
    });
