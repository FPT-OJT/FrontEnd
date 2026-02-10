import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/profile/domain/entities/country.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';

class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object?> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {
  const UpdateProfileInitial();
  @override
  List<Object?> get props => [];
}

class UpdateProfileLoading extends UpdateProfileState {
  const UpdateProfileLoading();
  @override
  List<Object?> get props => [];
}

class UpdateProfileLoaded extends UpdateProfileState {
  const UpdateProfileLoaded({required this.countries, required this.profile});
  final List<Country> countries;
  final Profile profile;
  @override
  List<Object?> get props => [countries, profile];
}

class UpdateProfileSuccess extends UpdateProfileState {
  const UpdateProfileSuccess();
  @override
  List<Object?> get props => [];
}

class UpdateProfileFailure extends UpdateProfileState {
  const UpdateProfileFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
