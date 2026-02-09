import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/auth/domain/entites/user.dart';
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
    on<AuthUpdateUserEvent>(_onAuthUpdateUserEvent);
  }
  final CurrentUserUseCase _currentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  // Cache user in memory to avoid unnecessary API calls
  User? _cachedUser;

  Future<void> _onAuthIsUserLoggedInEvent(
    AuthIsUserLoggedInEvent event,
    Emitter<AuthState> emit,
  ) async {
    // If user is already cached in memory, return immediately
    if (_cachedUser != null) {
      emit(AuthLoggedIn(user: _cachedUser!));
      return;
    }

    // Otherwise, fetch from repository (which will try API then cache)
    emit(const AuthLoading());
    final result = await _currentUserUseCase.call(const NoParams());
    result.fold(
      (failure) {
        _cachedUser = null; // Clear cache on failure
        emit(AuthFailure(failure.message));
      },
      (user) {
        _cachedUser = user; // Cache the user in memory
        emit(AuthLoggedIn(user: user));
      },
    );
  }

  Future<void> _onAuthLoggedInEvent(
    AuthLoggedInEvent event,
    Emitter<AuthState> emit,
  ) async {
    _cachedUser = event.user; // Cache user in memory
    emit(AuthLoggedIn(user: event.user));
  }

  Future<void> _onAuthLoggedOutEvent(
    AuthLoggedOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _logoutUseCase.call(const NoParams());

    result.fold((failure) => emit(AuthFailure(failure.message)), (_) {
      _cachedUser = null; // Clear cached user from memory
      emit(const AuthLoggedOut());
    });
  }

  // Update user info in memory (for future profile update feature)
  Future<void> _onAuthUpdateUserEvent(
    AuthUpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    _cachedUser = event.user; // Update cached user
    emit(AuthLoggedIn(user: event.user));
  }
}
