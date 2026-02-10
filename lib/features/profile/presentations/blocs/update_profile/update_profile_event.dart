import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';

class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileStarted extends UpdateProfileEvent {
  const UpdateProfileStarted();
  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends UpdateProfileEvent {
  const UpdateProfileRequested({required this.profile});
  final Profile profile;
  @override
  List<Object?> get props => [profile];
}
