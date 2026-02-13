import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/profile/domain/entities/country.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> getMyProfile();
  Future<Either<Failure, void>> updateMyProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String countryCode,
    required String phoneNumber,
  });
  Future<Either<Failure, List<Country>>> getCountries();
}
