import 'package:fpt_ojt/core/common/token/token_store.dart';
import 'package:fpt_ojt/core/storages/key_value_storage.dart';

class TokenStoreImpl implements TokenStore {
  TokenStoreImpl({required KeyValueStorage secureKVStorage})
    : _secureKVStorage = secureKVStorage;
  final KeyValueStorage _secureKVStorage;
  final Map<String, String> _memoryTokenStore = {};
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  @override
  Future<String> getAccessToken() async =>
      _memoryTokenStore[_accessTokenKey] ?? '';
  @override
  Future<String> getRefreshToken() async =>
      _memoryTokenStore[_refreshTokenKey] ??
      await _secureKVStorage.get<String>(_refreshTokenKey) ??
      '';
  @override
  Future<void> saveAccessToken(String accessToken) async {
    _memoryTokenStore[_accessTokenKey] = accessToken;
  }

  @override
  Future<void> saveRefreshToken(
    String refreshToken, {
    bool rememberMe = false,
  }) async {
    if (rememberMe) {
      await _secureKVStorage.set(_refreshTokenKey, refreshToken);
      _memoryTokenStore[_refreshTokenKey] = refreshToken;
    }
  }

  @override
  Future<void> deleteAccessToken() async {
    await _secureKVStorage.remove(_accessTokenKey);
    _memoryTokenStore.remove(_accessTokenKey);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await _secureKVStorage.remove(_refreshTokenKey);
    _memoryTokenStore.remove(_refreshTokenKey);
  }
}
