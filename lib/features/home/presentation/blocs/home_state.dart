import 'package:fpt_ojt/features/home/domain/entities/merchant_category.dart';
import 'package:fpt_ojt/features/home/domain/entities/merchant_offer.dart';
import 'package:fpt_ojt/features/home/domain/entities/product_deal.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomeLoadStatus { initial, loading, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeLoadStatus.initial) HomeLoadStatus categoriesStatus,
    @Default(HomeLoadStatus.initial) HomeLoadStatus agenciesStatus,
    @Default([]) List<MerchantCategory> categories,
    @Default([]) List<MerchantOffer> merchantOffers,
    @Default([]) List<ProductDeal> productDeals,
    @Default(false) bool hasCard,
    String? errorMessage,
    Coordinate? currentCoordinate,
  }) = _HomeState;
}
