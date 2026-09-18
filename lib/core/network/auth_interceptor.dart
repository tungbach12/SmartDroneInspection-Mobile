import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/providers.dart';
import 'package:smart_drone_inspection/core/network/token_store.dart';

/// Wraps [Dio] with JWT attach and single-flight 401 refresh.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref, this._dio);

  final Ref _ref;
  final Dio _dio;
  Completer<void>? _refreshLock;

  TokenStore get _tokens => _ref.read(tokenStoreProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokens.access;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Another request is already refreshing: wait for it, then retry.
    if (_refreshLock != null) {
      try {
        await _refreshLock!.future;
      } catch (_) {
        return handler.next(err);
      }
      return _retry(err, handler);
    }

    _refreshLock = Completer<void>();
    try {
      final refresh = _tokens.refresh;
      if (refresh == null) {
        throw DioException(requestOptions: err.requestOptions);
      }
      final response = await _ref
          .read(refreshDioProvider)
          .post('/mobile/auth/refresh', data: {'refreshToken': refresh});
      await _tokens.save(
        access: response.data['accessToken'] as String,
        refresh: response.data['refreshToken'] as String,
      );
      _refreshLock!.complete();
    } catch (e) {
      _refreshLock!.completeError(e);
      _refreshLock = null;
      await _tokens.clear();
      return handler.next(err);
    }
    _refreshLock = null;

    return _retry(err, handler);
  }

  Future<void> _retry(DioException err, ErrorInterceptorHandler handler) async {
    try {
      final response = await _dio.fetch(
        err.requestOptions
          ..headers['Authorization'] = 'Bearer ${_tokens.access}',
      );
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}
