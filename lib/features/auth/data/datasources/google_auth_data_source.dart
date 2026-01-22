abstract class GoogleAuthDataSource {
  Future<String> getIdToken();
  Future<void> signOut();
}
