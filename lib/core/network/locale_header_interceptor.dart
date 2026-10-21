import 'package:dio/dio.dart';

class LocaleHeaderInterceptor extends Interceptor {
  LocaleHeaderInterceptor(this._languageCode);

  final String Function() _languageCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final languageCode = _languageCode();
    options.headers['Accept-Language'] = languageCode == 'vi' ? 'vi' : 'en';
    handler.next(options);
  }
}
