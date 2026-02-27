import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_reponse.freezed.dart';
part 'login_reponse.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required Role role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

enum Role {
  @JsonValue('CUSTOMER')
  customer,
  @JsonValue('ADMIN')
  admin,
}
