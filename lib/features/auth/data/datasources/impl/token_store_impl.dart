import 'package:fpt_ojt/core/common/token/token_store.dart';
import 'package:fpt_ojt/core/storages/key_value_storage.dart';

class TokenStoreImpl implements TokenStore {
  TokenStoreImpl({required KeyValueStorage localStorage})
    : _localStorage = localStorage;
  final KeyValueStorage _localStorage;
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  @override
  Future<String> getAccessToken() async =>
      await _localStorage.get<String>(_accessTokenKey) ?? '';
  @override
  Future<String> getRefreshToken() async =>
      await _localStorage.get<String>(_refreshTokenKey) ?? '';
  @override
  Future<void> saveAccessToken(String accessToken) async {
    await _localStorage.set(_accessTokenKey, accessToken);
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await _localStorage.set(_refreshTokenKey, refreshToken);
  }

  @override
  Future<void> deleteAccessToken() async {
    await _localStorage.remove(_accessTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await _localStorage.remove(_refreshTokenKey);
  }
}
