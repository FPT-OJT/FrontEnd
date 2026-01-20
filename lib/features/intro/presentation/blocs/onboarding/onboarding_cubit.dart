import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/intro/domain/usecases/end_onboarding.dart';
import 'package:fpt_ojt/features/intro/domain/usecases/get_onboarding_completion_status.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:fpt_ojt/features/intro/presentation/constants/onboarding_constants.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required this.endOnboardingUseCase,
    required this.getIsOnboardingUseCase,
  }) : super(const OnboardingInitial());
  final EndOnboardingUseCase endOnboardingUseCase;
  final GetOnboardingCompletionStatusUseCase getIsOnboardingUseCase;

  Future<void> initialize() async {
    emit(const OnboardingLoading());
    final res = await getIsOnboardingUseCase.call(NoParams());
    res.fold((failure) => emit(OnboardingError(failure.message)), (seen) {
      if (seen) {
        emit(const OnboardingCompleted());
      } else {
        emit(const OnboardingSession(0, onboardingItems));
      }
    });
  }

  Future<void> pageChanged(double page) async {
    emit(OnboardingSession(page, onboardingItems));
  }

  Future<void> complete() async {
    final res = await endOnboardingUseCase.call(NoParams());
    res.fold(
      (failure) => emit(OnboardingError(failure.message)),
      (_) => emit(const OnboardingCompleted()),
    );
  }
}
