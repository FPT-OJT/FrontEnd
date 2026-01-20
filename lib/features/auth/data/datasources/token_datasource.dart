
abstract interface class TokenDataSource {
  Future<String> getAccessToken();
  Future<String> getRefreshToken();
  Future<void> saveAccessToken(String accessToken);
  Future<void> saveRefreshToken(String refreshToken);
  Future<void> deleteAccessToken();
  Future<void> deleteRefreshToken();
}
