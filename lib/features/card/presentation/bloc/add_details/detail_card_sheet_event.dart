import 'package:equatable/equatable.dart';

abstract class DetailCardSheetEvent extends Equatable {
  const DetailCardSheetEvent();

  @override
  List<Object?> get props => [];
}

class OnCardAddEvent extends DetailCardSheetEvent {
  const OnCardAddEvent(this.cardId, this.firstPaymentDate, this.expiryDate);
  final String cardId;
  final DateTime? firstPaymentDate;
  final DateTime? expiryDate;

  @override
  List<Object?> get props => [cardId, firstPaymentDate, expiryDate];
}

class OnCardCloseEvent extends DetailCardSheetEvent {
  const OnCardCloseEvent(this.cardId);
  final String cardId;

  @override
  List<Object?> get props => [cardId];
}

class OnViewMyWalletSelected extends DetailCardSheetEvent {
  const OnViewMyWalletSelected();

  @override
  List<Object?> get props => [];
}
