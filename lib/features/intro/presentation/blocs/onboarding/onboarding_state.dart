import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/intro/domain/entities/onboarding_item.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
  @override
  List<Object?> get props => [];
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
  @override
  List<Object?> get props => [];
}

class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
  @override
  List<Object?> get props => [];
}

class OnboardingError extends OnboardingState {
  const OnboardingError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class OnboardingSession extends OnboardingState {
  const OnboardingSession(this.page, this.items);
  final double page;
  final List<OnboardingItem> items;
  OnboardingSession copyWith({double? page, List<OnboardingItem>? items}) =>
      OnboardingSession(page ?? this.page, items ?? this.items);

  bool get isLast => page >= items.length - 1;
  bool get isFirst => page <= 0;

  int get currentIndex => page.round().clamp(0, items.length - 1);
  OnboardingItem get currentItem => items[currentIndex];
  @override
  List<Object?> get props => [page, items];
}
