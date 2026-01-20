import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/login_with_google.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_options/login_options_state.dart';

class LoginOptionsCubit extends Cubit<LoginOptionsState> {
  LoginOptionsCubit({required LoginWithGoogleUseCase loginWithGoogleUseCase})
    : _loginWithGoogleUseCase = loginWithGoogleUseCase,
      super(const LoginOptionsInitial());
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  Future<void> loginWithFacebook() async {
    emit(const LoginWithFacebookLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(const LoginWithFacebookSuccess());
  }

  Future<void> loginWithGoogle() async {
    emit(const LoginWithGoogleLoading());
    final result = await _loginWithGoogleUseCase.call(NoParams());
    result.fold(
      (failure) => emit(LoginWithGoogleError(failure.message)),
      (user) => emit(LoginWithGoogleSuccess(user: user)),
    );
  }
}
