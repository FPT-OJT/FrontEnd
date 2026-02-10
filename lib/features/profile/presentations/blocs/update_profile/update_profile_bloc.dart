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
       super(const UpdateProfileState()) {
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
    emit(state.copyWith(status: UpdateProfileStatus.loading));

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

    final resultState = countriesEither.flatMap(
      (countries) => profileEither.map(
        (profile) => state.copyWith(
          status: UpdateProfileStatus.loaded,
          countries: countries,
          profile: profile,
          errorMessage: null,
        ),
      ),
    );

    resultState.fold(
      (failure) => emit(
        state.copyWith(
          status: UpdateProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      emit.call,
    );
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(state.copyWith(status: UpdateProfileStatus.loading));

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
      (failure) => emit(
        state.copyWith(
          status: UpdateProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(status: UpdateProfileStatus.success, errorMessage: null),
      ),
    );
  }
}
