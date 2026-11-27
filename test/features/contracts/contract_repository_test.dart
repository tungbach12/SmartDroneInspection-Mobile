import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/contracts/data/contract_repository.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';

void main() {
  test('formatters format VND currency, locations, and 20-day lead date', () {
    expect(formatVnd(11000000), '11,000,000 ₫');
    expect(formatVnd(null), '—');
    expect(
      formatLocationDisplay('{"label":"Hanoi - Nhat Tan Bridge","lat":21.09}'),
      'Hanoi - Nhat Tan Bridge',
    );
    expect(
      earliestAllowedRequestDate(DateTime(2026, 10, 1, 14, 30)),
      DateTime(2026, 10, 21),
    );
    expect(
      earliestAllowedRequestDate(DateTime(2026, 10, 1, 14, 30), 7),
      DateTime(2026, 10, 8),
    );
  });

  test('ServiceRequest.effectiveStatus elevates OPEN when occurrences are ASSIGNED', () {
    final req = ServiceRequest.fromJson({
      'id': 'req-1',
      'assetId': 'asset-1',
      'description': 'Quarterly bridge inspection',
      'status': 'OPEN',
      'occurrences': [
        {
          'id': 'occ-1',
          'occurrenceIndex': 1,
          'plannedStartAt': '2026-11-10T08:00:00Z',
          'plannedEndAt': '2026-11-10T17:00:00Z',
          'status': 'ASSIGNED',
        },
      ],
      'messages': [
        {
          'id': 'm-1',
          'authorUserId': 'mgr-1',
          'body': 'Uploaded quote v1',
          'createdAt': '2026-10-01T10:00:00Z',
        },
        {
          'id': 'm-2',
          'authorUserId': 'cust-1',
          'body': 'Received, thanks',
          'createdAt': '2026-10-01T10:05:00Z',
        },
      ],
    });

    expect(req.effectiveStatus, 'ASSIGNED');
    expect(req.unreadCountForUser('cust-1'), 1);
  });

  group('ContractRepository', () {
    late Dio dio;
    late ContractRepository repo;
    late List<RequestOptions> requests;

    setUp(() {
      requests = [];
      dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            if (options.method == 'GET' &&
                options.path == '/contracts/requests/scheduling-policy') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'minimumLeadDays': 10},
                ),
              );
              return;
            }
            if (options.method == 'GET' &&
                options.path == '/contracts/requests') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: [_requestJson()],
                ),
              );
              return;
            }
            if (options.method == 'POST' &&
                options.path == '/contracts/requests') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 201,
                  data: _requestJson(),
                ),
              );
              return;
            }
            if (options.method == 'POST' &&
                options.path == '/contracts/requests/req-1/accept') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: _requestJson(status: 'ACCEPTED'),
                ),
              );
              return;
            }
            if (options.method == 'POST' &&
                options.path == '/contracts/requests/req-1/messages') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: _requestJson(),
                ),
              );
              return;
            }
            if (options.method == 'POST' &&
                options.path == '/contracts/requests/req-1/messages/read') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: _requestJson(),
                ),
              );
              return;
            }
            handler.reject(DioException(requestOptions: options));
          },
        ),
      );
      repo = ContractRepository(dio);
    });

    test('lists, creates, accepts quote with optimistic rowVersion, and posts chat', () async {
      final listRes = await repo.listRequests();
      expect((listRes as ApiSuccess<List<ServiceRequest>>).data, hasLength(1));

      final createRes = await repo.createRequest(
        const CreateServiceRequestInput(
          assetId: 'asset-1',
          requestedFrom: '2026-11-25T08:00:00Z',
          requestType: 'ONE_TIME',
          description: 'Thermal span check',
        ),
      );
      expect(createRes, isA<ApiSuccess<ServiceRequest>>());
      expect(requests.last.data['assetId'], 'asset-1');

      final acceptRes = await repo.acceptQuote(
        requestId: 'req-1',
        quoteRowVersion: 3,
      );
      expect((acceptRes as ApiSuccess<ServiceRequest>).data.status, 'ACCEPTED');
      expect(requests.last.data['quoteRowVersion'], 3);

      final chatRes = await repo.postMessage(
        requestId: 'req-1',
        body: 'Confirm schedule',
      );
      expect(chatRes, isA<ApiSuccess<ServiceRequest>>());

      final readRes = await repo.markMessagesRead('req-1');
      expect(readRes, isA<ApiSuccess<ServiceRequest>>());

      final policyRes = await repo.getSchedulingPolicyLeadDays();
      expect((policyRes as ApiSuccess<int>).data, 10);
    });
  });
}

Map<String, dynamic> _requestJson({String status = 'QUOTED'}) => {
  'id': 'req-1',
  'ownerCustomerId': 'cust-1',
  'assetId': 'asset-1',
  'description': 'Annual bridge check',
  'requestedFrom': '2026-11-25T08:00:00Z',
  'requestedUntil': '2026-11-25T17:00:00Z',
  'timezone': 'Asia/Ho_Chi_Minh',
  'windowStart': '08:00',
  'windowEnd': '17:00',
  'requestType': 'ONE_TIME',
  'status': status,
  'createdAt': '2026-10-20T08:00:00Z',
  'currentQuote': {
    'id': 'q-1',
    'scopeSnapshot': '2 main towers',
    'firstOccurrenceStartAt': '2026-11-25T08:00:00Z',
    'firstOccurrenceEndAt': '2026-11-25T17:00:00Z',
    'inspectorId': 'insp-user',
    'droneId': 'drone-1',
    'currency': 'VND',
    'pricePerOccurrenceVnd': 15000000,
    'pricePerOccurrenceUsd': 600,
    'rowVersion': 3,
    'createdAt': '2026-10-21T08:00:00Z',
    'updatedAt': '2026-10-21T08:00:00Z',
  },
};
