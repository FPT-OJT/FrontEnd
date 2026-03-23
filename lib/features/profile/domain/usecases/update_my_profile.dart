import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/profile/domain/repositories/profile_repository.dart';

class UpdateMyProfileUseCase implements UseCase<void, UpdateMyProfileParams> {
  UpdateMyProfileUseCase({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;
  final ProfileRepository _profileRepository;

  @override
  Future<Either<Failure, void>> call(UpdateMyProfileParams params) async =>
      _profileRepository.updateMyProfile(
        firstName: params.firstName,
        lastName: params.lastName,
        email: params.email,
        countryCode: params.countryCode,
        phoneNumber: params.phoneNumber,
      );
}

@immutable
class UpdateMyProfileParams extends Equatable {
  const UpdateMyProfileParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
  });
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String phoneNumber;
  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    countryCode,
    phoneNumber,
  ];
}
