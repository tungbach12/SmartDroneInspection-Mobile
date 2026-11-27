import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/contracts/data/contract_repository.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';

class ServiceRequestsNotifier extends AsyncNotifier<List<ServiceRequest>> {
  @override
  Future<List<ServiceRequest>> build() => _fetch();

  Future<List<ServiceRequest>> _fetch() async {
    final res = await ref.read(contractRepositoryProvider).listRequests();
    return switch (res) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw ApiFailureException(failure),
    };
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<ApiResult<ServiceRequest>> createRequest(
    CreateServiceRequestInput input,
  ) async {
    final res = await ref.read(contractRepositoryProvider).createRequest(input);
    if (res is ApiSuccess<ServiceRequest>) {
      await refresh();
    }
    return res;
  }
}

final serviceRequestLeadDaysProvider = FutureProvider<int>((ref) async {
  final res = await ref
      .read(contractRepositoryProvider)
      .getSchedulingPolicyLeadDays();
  return switch (res) {
    ApiSuccess(:final data) => data,
    ApiError() => minimumInspectionLeadDays,
  };
});

final serviceRequestsProvider =
    AsyncNotifierProvider<ServiceRequestsNotifier, List<ServiceRequest>>(
      ServiceRequestsNotifier.new,
    );

final serviceRequestDetailProvider =
    FutureProvider.family<ServiceRequest, String>((ref, requestId) async {
      final res = await ref
          .read(contractRepositoryProvider)
          .getRequest(requestId);
      return switch (res) {
        ApiSuccess(:final data) => data,
        ApiError(:final failure) => throw ApiFailureException(failure),
      };
    });

final unreadContractMessagesCountProvider = Provider<int>((ref) {
  final userId = ref.watch(authNotifierProvider).value?.user?.id;
  final requests =
      ref.watch(serviceRequestsProvider).value ?? const <ServiceRequest>[];
  var total = 0;
  for (final req in requests) {
    total += req.unreadCountForUser(userId);
  }
  return total;
});
