import 'package:fpt_ojt/features/profile/data/models/profile_model.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';

extension ProfileMapper on ProfileModel {
  Profile toDomain() => Profile(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    countryCode: countryPhoneCode ?? '',
    phoneNumber: phoneNumber ?? '',
  );
}
