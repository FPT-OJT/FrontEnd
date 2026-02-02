import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_event.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_merchant_categories.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_nearest_merchant_agencies.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetMerchantCategoriesUseCase getMerchantCategoriesUseCase,
    required GetNearestMerchantAgenciesUseCase
    getNearestMerchantAgenciesUseCase,
  }) : _getMerchantCategoriesUseCase = getMerchantCategoriesUseCase,
       _getNearestMerchantAgenciesUseCase = getNearestMerchantAgenciesUseCase,
       super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<HomeCoordinateUpdated>(_onCoordinateUpdated);
  }

  final GetMerchantCategoriesUseCase _getMerchantCategoriesUseCase;
  final GetNearestMerchantAgenciesUseCase _getNearestMerchantAgenciesUseCase;

  static const int _defaultCategoryLimit = 10;
  static const int _defaultPage = 1;
  static const int _defaultAgencyLimit = 3;

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

    await Future.wait([_loadCategories(emit)]);
  }

  Future<void> _loadCategories(Emitter<HomeState> emit) async {
    final result = await _getMerchantCategoriesUseCase(
      const GetMerchantCategoriesParams(
        page: _defaultPage,
        limit: _defaultCategoryLimit,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          categoriesStatus: HomeLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          categoriesStatus: HomeLoadStatus.success,
          categories: categories,
        ),
      ),
    );
  }

  Future<void> _onCoordinateUpdated(
    HomeCoordinateUpdated event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        currentCoordinate: event.coordinate,
        agenciesStatus: HomeLoadStatus.loading,
      ),
    );

    final result = await _getNearestMerchantAgenciesUseCase(
      GetNearestMerchantAgenciesParams(
        limit: _defaultAgencyLimit,
        latitude: event.coordinate.latitude,
        longitude: event.coordinate.longitude,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          agenciesStatus: HomeLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (agencies) => emit(
        state.copyWith(
          agenciesStatus: HomeLoadStatus.success,
          nearestMerchantAgencies: agencies,
        ),
      ),
    );
  }
}
