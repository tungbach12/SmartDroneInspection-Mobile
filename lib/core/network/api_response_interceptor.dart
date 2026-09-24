import 'package:dio/dio.dart';

Object? unwrapApiResponse(Object? body) {
  if (body is Map &&
      body['success'] == true &&
      body['message'] is String &&
      body.containsKey('data')) {
    return body['data'];
  }

  return body;
}

class ApiResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    response.data = unwrapApiResponse(response.data);
    handler.next(response);
  }
}
