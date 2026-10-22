import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/locale_header_interceptor.dart';

void main() {
  test('uses English until the persisted locale becomes available', () async {
    String? locale;
    final interceptor = LocaleHeaderInterceptor(() => locale ?? 'en');
    final options = RequestOptions(path: '/auth/refresh');
    interceptor.onRequest(options, RequestInterceptorHandler());

    expect(options.headers['Accept-Language'], 'en');

    locale = 'vi';
    final nextOptions = RequestOptions(path: '/inspections');
    interceptor.onRequest(nextOptions, RequestInterceptorHandler());
    expect(nextOptions.headers['Accept-Language'], 'vi');
  });

  test('adds the current locale as Accept-Language per request', () async {
    var locale = 'en';
    final interceptor = LocaleHeaderInterceptor(() => locale);
    final options = RequestOptions(path: '/inspections');
    final handler = RequestInterceptorHandler();
    interceptor.onRequest(options, handler);
    await Future<void>.delayed(Duration.zero);

    expect(options.headers['Accept-Language'], 'en');

    locale = 'vi';
    final nextOptions = RequestOptions(path: '/inspections');
    interceptor.onRequest(nextOptions, RequestInterceptorHandler());

    expect(nextOptions.headers['Accept-Language'], 'vi');
  });
}
