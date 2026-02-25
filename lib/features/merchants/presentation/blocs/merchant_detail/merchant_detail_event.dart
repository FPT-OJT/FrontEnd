import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/card.dart';

class MerchantDetailEvent extends Equatable {
  const MerchantDetailEvent();
  @override
  List<Object?> get props => [];
}

class MerchantDetailStarted extends MerchantDetailEvent {
  const MerchantDetailStarted({required this.merchantId});
  final String merchantId;
  @override
  List<Object?> get props => [merchantId];
}

class MerchantDetailCardSelected extends MerchantDetailEvent {
  const MerchantDetailCardSelected({required this.card});
  final Card card;
  @override
  List<Object?> get props => [card];
}

class MerchantDetailDealIndexChanged extends MerchantDetailEvent {
  const MerchantDetailDealIndexChanged({required this.dealIndex});
  final int dealIndex;
  @override
  List<Object?> get props => [dealIndex];
}

class MerchantDetailFavoriteToggled extends MerchantDetailEvent {
  const MerchantDetailFavoriteToggled();
}

class MerchantDetailSubscribeToggled extends MerchantDetailEvent {
  const MerchantDetailSubscribeToggled();
}
