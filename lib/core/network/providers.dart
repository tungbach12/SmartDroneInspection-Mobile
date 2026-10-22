import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_drone_inspection/core/env/app_environment.dart';
import 'package:smart_drone_inspection/core/localization/locale_provider.dart';
import 'package:smart_drone_inspection/core/network/api_response_interceptor.dart';
import 'package:smart_drone_inspection/core/network/auth_interceptor.dart';
import 'package:smart_drone_inspection/core/network/locale_header_interceptor.dart';
import 'package:smart_drone_inspection/core/network/token_store.dart';

part 'providers.g.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

/// A bare refresh client that still sends the selected response locale.
@Riverpod(keepAlive: true)
Dio refreshDio(Ref ref) {
  final dio = Dio(BaseOptions(baseUrl: AppEnvironment.apiBaseUrl));
  dio.interceptors.addAll([
    LocaleHeaderInterceptor(
      () => ref.read(localeNotifierProvider).value?.languageCode ?? 'en',
    ),
    ApiResponseInterceptor(),
  ]);
  return dio;
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnvironment.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    LocaleHeaderInterceptor(
      () => ref.read(localeNotifierProvider).value?.languageCode ?? 'en',
    ),
    ApiResponseInterceptor(),
    AuthInterceptor(ref, dio),
  ]);

  ref.onDispose(dio.close);
  return dio;
}
