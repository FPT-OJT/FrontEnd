class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatar,
    required this.role,
    required this.status,
  });
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatar;
  final String role;
  final String status;
}

class LoginResponse {
  LoginResponse({
    required this.user,
    required this.token,
    required this.refreshToken,
    required this.tokenType,
    required this.scope,
    required this.idToken,
  });
  final UserModel user;
  final String token;
  final String refreshToken;
  final String tokenType;
  final String scope;
  final String idToken;
}
