import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/login_with_email.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_state.dart';

class LoginDetailsBloc extends Bloc<LoginDetailsEvent, LoginDetailsState> {
  LoginDetailsBloc({required LoginWithEmailUseCase loginWithEmailUseCase})
    : _loginWithEmailUseCase = loginWithEmailUseCase,
      super(const LoginDetailsInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }
  final LoginWithEmailUseCase _loginWithEmailUseCase;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginDetailsState> emit,
  ) async {
    emit(const LoginSubmitting());
    final result = await _loginWithEmailUseCase.call(
      LoginWithEmailParams(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      ),
    );
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (user) => emit(LoginSuccess(user: user)),
    );
  }
}
