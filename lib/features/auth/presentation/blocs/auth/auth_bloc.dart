import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/current_user.dart';
import 'package:fpt_ojt/features/auth/domain/usecases/logout.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_event.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required CurrentUserUseCase currentUserUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _currentUserUseCase = currentUserUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthInitial()) {
    on<AuthIsUserLoggedInEvent>(_onAuthIsUserLoggedInEvent);
    on<AuthLoggedInEvent>(_onAuthLoggedInEvent);
    on<AuthLoggedOutEvent>(_onAuthLoggedOutEvent);
  }
  final CurrentUserUseCase _currentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> _onAuthIsUserLoggedInEvent(
    AuthIsUserLoggedInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _currentUserUseCase.call(const NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthLoggedIn(user: user)),
    );
  }

  Future<void> _onAuthLoggedInEvent(
    AuthLoggedInEvent event,
    Emitter<AuthState> emit,
  ) async => emit(AuthLoggedIn(user: event.user));

  Future<void> _onAuthLoggedOutEvent(
    AuthLoggedOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _logoutUseCase.call(const NoParams());

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const AuthLoggedOut()),
    );
  }
}
