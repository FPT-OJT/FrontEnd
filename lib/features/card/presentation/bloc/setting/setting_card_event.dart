import 'package:equatable/equatable.dart';

abstract class SettingCardEvent extends Equatable {
  const SettingCardEvent();

  @override
  List<Object?> get props => [];
}

class OnCardSettingLoadEvent extends SettingCardEvent {
  const OnCardSettingLoadEvent(this.cardId);
  final String cardId;

  @override
  List<Object?> get props => [cardId];
}

class OnCardSettingUpdateEvent extends SettingCardEvent {
  const OnCardSettingUpdateEvent(
    this.cardId,
    this.firstPaymentDate,
    this.expiryDate,
  );
  final String cardId;
  final int? firstPaymentDate;
  final DateTime? expiryDate;

  @override
  List<Object?> get props => [cardId, firstPaymentDate, expiryDate];
}

class OnCardSettingDataChangedEvent extends SettingCardEvent {
  const OnCardSettingDataChangedEvent();
}

class OnCardSettingDeleteEvent extends SettingCardEvent {
  const OnCardSettingDeleteEvent(this.userCardId);
  final String userCardId;

  @override
  List<Object?> get props => [userCardId];
}
