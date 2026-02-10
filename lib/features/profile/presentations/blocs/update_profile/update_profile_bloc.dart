import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/profile/domain/entities/country.dart';
import 'package:fpt_ojt/features/profile/domain/entities/profile.dart';
import 'package:fpt_ojt/features/profile/domain/usecases/get_countries.dart';
import 'package:fpt_ojt/features/profile/domain/usecases/get_my_profile.dart';
import 'package:fpt_ojt/features/profile/domain/usecases/update_my_profile.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_event.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc({
    required GetCountriesUseCase getCountriesUseCase,
    required GetMyProfileUseCase getMyProfileUseCase,
    required UpdateMyProfileUseCase updateMyProfileUseCase,
  }) : _getCountriesUseCase = getCountriesUseCase,
       _getMyProfileUseCase = getMyProfileUseCase,
       _updateMyProfileUseCase = updateMyProfileUseCase,
       super(const UpdateProfileInitial()) {
    on<UpdateProfileStarted>(_onUpdateProfileStarted);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }
  final GetCountriesUseCase _getCountriesUseCase;
  final GetMyProfileUseCase _getMyProfileUseCase;
  final UpdateMyProfileUseCase _updateMyProfileUseCase;

  Future<void> _onUpdateProfileStarted(
    UpdateProfileStarted event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(const UpdateProfileLoading());

    final results = await Future.wait([
      _getCountriesUseCase(const NoParams()),
      _getMyProfileUseCase(const NoParams()),
    ]);

    final countriesEither = results[0] as Either<Failure, List<Country>>;
    final profileEither = results[1] as Either<Failure, Profile>;
    debugPrint(
      'countries: ${countriesEither.fold((l) => l.message, (r) => r.toString())}',
    );
    debugPrint(
      'profile: ${profileEither.fold((l) => l.message, (r) => r.toString())}',
    );
    final state = countriesEither.flatMap(
      (countries) => profileEither.map(
        (profile) =>
            UpdateProfileLoaded(countries: countries, profile: profile),
      ),
    );

    state.fold(
      (failure) => emit(UpdateProfileFailure(failure.message)),
      emit.call,
    );
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(const UpdateProfileLoading());
    final result = await _updateMyProfileUseCase.call(
      UpdateMyProfileParams(
        firstName: event.profile.firstName,
        lastName: event.profile.lastName,
        email: event.profile.email,
        countryCode: event.profile.countryCode,
        phoneNumber: event.profile.phoneNumber,
      ),
    );
    result.fold(
      (failure) => emit(UpdateProfileFailure(failure.message)),
      (_) => emit(const UpdateProfileSuccess()),
    );
  }
}
