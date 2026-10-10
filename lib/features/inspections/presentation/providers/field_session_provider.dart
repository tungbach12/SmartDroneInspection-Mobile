import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/field_session.dart';

final fieldSessionsProvider = FutureProvider.family<List<FieldSession>, String>(
  (ref, inspectionId) async {
    final result = await ref
        .watch(inspectionRepositoryProvider)
        .listFieldSessions(inspectionId);
    switch (result) {
      case ApiSuccess(:final data):
        return data;
      case ApiError(:final failure):
        throw Exception(failure);
    }
  },
);
