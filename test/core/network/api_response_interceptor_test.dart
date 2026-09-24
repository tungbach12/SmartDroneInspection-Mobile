import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_response_interceptor.dart';

void main() {
  group('unwrapApiResponse', () {
    test('unwraps a successful API response envelope', () {
      final payload = [
        {'id': 'inspection-1'},
      ];

      expect(
        unwrapApiResponse({
          'success': true,
          'message': 'Success',
          'data': payload,
        }),
        payload,
      );
    });

    test('leaves Problem Details errors unchanged', () {
      final problem = {
        'type': 'about:blank',
        'title': 'Forbidden',
        'status': 403,
        'code': 'ACCESS_DENIED',
      };

      expect(unwrapApiResponse(problem), problem);
    });

    test('leaves unwrapped payloads unchanged for compatibility', () {
      final payload = {'id': 'inspection-1'};

      expect(unwrapApiResponse(payload), same(payload));
    });
  });
}
