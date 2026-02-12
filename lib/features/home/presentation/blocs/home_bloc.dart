import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/home/data/mappers/home_mapper.dart';
import 'package:fpt_ojt/features/home/domain/entities/merchant_offer.dart';
import 'package:fpt_ojt/features/home/domain/usecases/add_favorite_merchant_uc.dart';
import 'package:fpt_ojt/features/home/domain/usecases/get_home_uc.dart';
import 'package:fpt_ojt/features/home/domain/usecases/subscribe_to_merchant_uc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_event.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetHomeUc getHomeUc,
    required SubscribeToMerchantUc subscribeToMerchantUc,
    required AddFavoriteMerchantUc addFavoriteMerchantUc,
  }) : _getHomeUc = getHomeUc,
       _subscribeToMerchantUc = subscribeToMerchantUc,
       _addFavoriteMerchantUc = addFavoriteMerchantUc,
       super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<SubscribeToMerchantToggled>(_onSubscribeToMerchantToggled);
    on<FavoriteMerchantToggled>(_onFavoriteMerchantToggled);
  }

  final GetHomeUc _getHomeUc;
  final SubscribeToMerchantUc _subscribeToMerchantUc;
  final AddFavoriteMerchantUc _addFavoriteMerchantUc;

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        categoriesStatus: HomeLoadStatus.loading,
        agenciesStatus: HomeLoadStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _getHomeUc(const NoParams());

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            categoriesStatus: HomeLoadStatus.failure,
            agenciesStatus: HomeLoadStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (homeData) {
        final entities = homeData.toEntities();

        emit(
          state.copyWith(
            categoriesStatus: HomeLoadStatus.success,
            agenciesStatus: HomeLoadStatus.success,
            categories: entities.categories,
            merchantOffers: entities.offers,
            productDeals: entities.productDeals,
            hasCard: !homeData.userCardEmpty,
          ),
        );
      },
    );
  }

  Future<void> _onSubscribeToMerchantToggled(
    SubscribeToMerchantToggled event,
    Emitter<HomeState> emit,
  ) async {
    // Update the local state immediately (optimistic update)
    final updatedOffers = state.merchantOffers.map((offer) {
      if (offer.merchantAgencyId == event.merchantAgencyId) {
        return MerchantOffer(
          merchantAgencyId: offer.merchantAgencyId,
          merchantAgencyName: offer.merchantAgencyName,
          merchantDealName: offer.merchantDealName,
          imageUrl: offer.imageUrl,
          totalDiscount: offer.totalDiscount,
          favorite: offer.favorite,
          location: offer.location,
          subscribed: !(offer.subscribed ?? false),
          distance: offer.distance,
        );
      }
      return offer;
    }).toList();

    emit(state.copyWith(merchantOffers: updatedOffers));

    // Make API call in background
    await _subscribeToMerchantUc(
      SubscribeToMerchantParams(merchantAgencyId: event.merchantAgencyId),
    );
  }

  Future<void> _onFavoriteMerchantToggled(
    FavoriteMerchantToggled event,
    Emitter<HomeState> emit,
  ) async {
    // Update the local state immediately (optimistic update)
    final updatedOffers = state.merchantOffers.map((offer) {
      if (offer.merchantAgencyId == event.merchantAgencyId) {
        return MerchantOffer(
          merchantAgencyId: offer.merchantAgencyId,
          merchantAgencyName: offer.merchantAgencyName,
          merchantDealName: offer.merchantDealName,
          imageUrl: offer.imageUrl,
          totalDiscount: offer.totalDiscount,
          favorite: !(offer.favorite ?? false),
          location: offer.location,
          subscribed: offer.subscribed,
          distance: offer.distance,
        );
      }
      return offer;
    }).toList();

    emit(state.copyWith(merchantOffers: updatedOffers));

    // Make API call in background
    await _addFavoriteMerchantUc(
      AddFavoriteMerchantParams(merchantAgencyId: event.merchantAgencyId),
    );
  }
}
