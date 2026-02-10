import 'package:equatable/equatable.dart';

abstract class DetailCardEvent extends Equatable {
  const DetailCardEvent();

  @override
  List<Object?> get props => [];
}

class OnCardAddEvent extends DetailCardEvent {
  const OnCardAddEvent(this.cardId);
  final String cardId;

  @override
  List<Object?> get props => [cardId];
}

class OnCardCloseEvent extends DetailCardEvent {
  const OnCardCloseEvent(this.cardId);
  final String cardId;

  @override
  List<Object?> get props => [cardId];
}

class OnViewMyWalletSelected extends DetailCardEvent {
  const OnViewMyWalletSelected();

  @override
  List<Object?> get props => [];
}
