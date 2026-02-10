import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/profile/data/datasource/country_datasource.dart';
import 'package:fpt_ojt/features/profile/data/datasource/profile_datasource.dart';
import 'package:fpt_ojt/features/profile/data/mappers/country_mapper.dart';
import 'package:fpt_ojt/features/profile/data/mappers/profile_mapper.dart';
import 'package:fpt_ojt/features/profile/domain/entities/country.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';
import 'package:fpt_ojt/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileDatasource profileDatasource,
    required CountryDatasource countryDatasource,
  }) : _profileDatasource = profileDatasource,
       _countryDatasource = countryDatasource;
  final ProfileDatasource _profileDatasource;
  final CountryDatasource _countryDatasource;

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    try {
      final response = await _countryDatasource.getCountries();
      return Right(response.data!.map((e) => e.toDomain()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Profile>> getMyProfile() async {
    try {
      final response = await _profileDatasource.getMyProfile();
      return Right(response.data!.toDomain());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateMyProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String countryCode,
    required String phoneNumber,
  }) async {
    try {
      final response = await _profileDatasource.updateMyProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );
      return Right(response.data);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
