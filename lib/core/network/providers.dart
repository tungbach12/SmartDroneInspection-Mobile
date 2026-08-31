import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_drone_inspection/core/env/app_environment.dart';
import 'package:smart_drone_inspection/core/network/auth_interceptor.dart';
import 'package:smart_drone_inspection/core/network/token_store.dart';

part 'providers.g.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

/// Bare Dio for the refresh call — no auth interceptor, so refresh can't recurse.
@Riverpod(keepAlive: true)
Dio refreshDio(Ref ref) {
  return Dio(BaseOptions(baseUrl: AppEnvironment.apiBaseUrl));
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppEnvironment.apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Accept': 'application/json'},
  ));

  dio.interceptors.add(AuthInterceptor(ref, dio));

  ref.onDispose(dio.close);
  return dio;
}
