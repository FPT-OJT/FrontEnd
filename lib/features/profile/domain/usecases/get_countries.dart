import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/profile/domain/entities/country.dart';
import 'package:fpt_ojt/features/profile/domain/repositories/profile_repository.dart';

class GetCountriesUseCase implements UseCase<List<Country>, NoParams> {
  GetCountriesUseCase({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;
  final ProfileRepository _profileRepository;
  @override
  Future<Either<Failure, List<Country>>> call(NoParams params) async =>
      _profileRepository.getCountries();
}
