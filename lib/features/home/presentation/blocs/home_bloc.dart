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
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/location/domain/usecases/coordinate_stream.dart';
import 'package:fpt_ojt/features/location/domain/usecases/current_coordinate.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetHomeUc getHomeUc,
    required SubscribeToMerchantUc subscribeToMerchantUc,
    required AddFavoriteMerchantUc addFavoriteMerchantUc,
    required CoordinateStreamUseCase coordinateStreamUseCase,
    required CurrentCoordinateUseCase currentCoordinateUseCase,
  }) : _getHomeUc = getHomeUc,
       _subscribeToMerchantUc = subscribeToMerchantUc,
       _addFavoriteMerchantUc = addFavoriteMerchantUc,
       _coordinateStreamUseCase = coordinateStreamUseCase,
       _currentCoordinateUseCase = currentCoordinateUseCase,
       super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<SubscribeToMerchantToggled>(_onSubscribeToMerchantToggled);
    on<FavoriteMerchantToggled>(_onFavoriteMerchantToggled);
    on<HomeRefreshRequested>(_onHomeRefreshRequested);
  }

  final GetHomeUc _getHomeUc;
  final SubscribeToMerchantUc _subscribeToMerchantUc;
  final AddFavoriteMerchantUc _addFavoriteMerchantUc;
  final CoordinateStreamUseCase _coordinateStreamUseCase;
  final CurrentCoordinateUseCase _currentCoordinateUseCase;
  StreamSubscription<Coordinate>? _positionSubscription;

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

    final currentCoordinate = await _currentCoordinateUseCase.call(
      const NoParams(),
    );
    final coordinate = currentCoordinate.getOrElse(
      (failure) => const Coordinate(latitude: 0, longitude: 0),
    );
    final result = await _getHomeUc(
      GetHomeParams(lat: coordinate.latitude, long: coordinate.longitude),
    );

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

        // Start listening to position stream after initial load
        _startLocationTracking();
      },
    );
  }

  void _startLocationTracking() {
    // Cancel existing subscription if any
    _positionSubscription?.cancel();

    // Start listening to position stream with 10m distance filter
    _coordinateStreamUseCase(
      const CoordinateStreamParams(
        timeLimit: Duration(seconds: 10),
        distanceFilterInMeters: 30,
      ),
    ).then((streamResult) {
      streamResult.fold(
        (failure) {
          // Handle error if needed
        },
        (stream) {
          _positionSubscription = stream.listen((coordinate) {
            add(HomeRefreshRequested());
          });
        },
      );
    });
  }

  Future<void> _onHomeRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentCoordinate = await _currentCoordinateUseCase.call(
      const NoParams(),
    );
    final coordinate = currentCoordinate.getOrElse(
      (failure) => const Coordinate(latitude: 0, longitude: 0),
    );
    final result = await _getHomeUc(
      GetHomeParams(lat: coordinate.latitude, long: coordinate.longitude),
    );

    result.fold(
      (failure) {
        // If failed, do nothing -> still use old data
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

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }
}
