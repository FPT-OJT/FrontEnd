import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';
import 'package:fpt_ojt/features/profile/domain/repositories/profile_repository.dart';

class GetMyProfileUseCase implements UseCase<Profile, NoParams> {
  GetMyProfileUseCase({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;
  final ProfileRepository _profileRepository;
  @override
  Future<Either<Failure, Profile>> call(NoParams params) async =>
      _profileRepository.getMyProfile();
}
