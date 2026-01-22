import 'package:fpt_ojt/features/auth/data/datasources/google_auth_data_source.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthDataSourceImpl implements GoogleAuthDataSource {
  GoogleAuthDataSourceImpl({required GoogleSignIn googleSignIn})
    : _googleSignIn = googleSignIn;
  final GoogleSignIn _googleSignIn;
  @override
  Future<String> getIdToken() async {
    final account = await _googleSignIn.authenticate();

    final auth = account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw Exception('Login with Google failed');
    }
    return idToken;
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
