import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/card.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_deal_detail.dart';

class MerchantDetailState extends Equatable {
  const MerchantDetailState();
  @override
  List<Object?> get props => [];
}

class MerchantDetailInitial extends MerchantDetailState {
  const MerchantDetailInitial();
  @override
  List<Object?> get props => [];
}
class MerchantDetailLoading extends MerchantDetailState {
  const MerchantDetailLoading();
  @override
  List<Object?> get props => [];
}

class MerchantDetailLoaded extends MerchantDetailState {
  const MerchantDetailLoaded({
    required this.merchantDetail,
    this.selectedCard,
    this.selectedDealIndex = 0,
  });
  final MerchantDetailWithCardDeals merchantDetail;
  final Card? selectedCard;
  final int selectedDealIndex;

  MerchantDetailLoaded copyWith({
    MerchantDetailWithCardDeals? merchantDetail,
    Card? selectedCard,
    int? selectedDealIndex,
  }) => MerchantDetailLoaded(
    merchantDetail: merchantDetail ?? this.merchantDetail,
    selectedCard: selectedCard ?? this.selectedCard,
    selectedDealIndex: selectedDealIndex ?? this.selectedDealIndex,
  );
  @override
  List<Object?> get props => [merchantDetail, selectedCard, selectedDealIndex];
}

class MerchantDetailError extends MerchantDetailState {
  const MerchantDetailError({required this.error});
  final String error;
  @override
  List<Object?> get props => [error];
}