import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/register.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/register/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required RegisterUseCase registerUseCase})
    : _registerUseCase = registerUseCase,
      super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  final RegisterUseCase _registerUseCase;

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterSubmitting());
    final result = await _registerUseCase.call(
      RegisterParams(
        firstName: event.firstName,
        lastName: event.lastName,
        username: event.username,
        password: event.password,
        repeatPassword: event.repeatPassword,
      ),
    );
    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (ok) => emit(const RegisterSuccess()),
    );
  }
}
