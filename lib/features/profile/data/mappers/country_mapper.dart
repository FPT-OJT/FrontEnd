import 'package:fpt_ojt/features/profile/data/models/country_model.dart';
import 'package:fpt_ojt/features/profile/domain/entities/country.dart';

extension CountryMapper on CountryModel {
  Country toDomain() =>
      Country(phoneCode: phoneCode, isoCode: isoCode, name: name);
}
