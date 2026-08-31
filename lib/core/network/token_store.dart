import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token storage backed by flutter_secure_storage.
/// In-memory cache avoids async reads in Dio interceptor hot path.
class TokenStore {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _access;
  String? _refresh;

  Future<void> load() async {
    _access = await _storage.read(key: _accessKey);
    _refresh = await _storage.read(key: _refreshKey);
  }

  String? get access => _access;
  String? get refresh => _refresh;

  Future<void> save({required String access, required String refresh}) async {
    _access = access;
    _refresh = refresh;
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  Future<void> clear() async {
    _access = null;
    _refresh = null;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
