import 'package:equatable/equatable.dart';

abstract class SearchCardEvent extends Equatable {
  const SearchCardEvent();

  @override
  List<Object?> get props => [];
}

class OnTextChangedEvent extends SearchCardEvent {
  const OnTextChangedEvent(this.keyword);
  final String keyword;

  @override
  List<Object?> get props => [keyword];
}

class OnCardSelectedEvent extends SearchCardEvent {
  const OnCardSelectedEvent(this.cardId);
  final String cardId;

  @override
  List<Object?> get props => [cardId];
}
