import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:fpt_ojt/features/intro/presentation/constants/onboarding_constants.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitial());

  Future<void> initialize() async {
    emit(const OnboardingLoading());
    //TODO: check if onboarding completed
    emit(const OnboardingSession(0, onboardingItems));
  }

  Future<void> pageChanged(double page) async {
    emit(OnboardingSession(page, onboardingItems));
  }

  Future<void> complete() async {
    // TODO: mark onboarding as completed in local storage
  }
}
