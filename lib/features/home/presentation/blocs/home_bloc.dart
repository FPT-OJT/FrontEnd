import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/home/data/mappers/home_mapper.dart';
import 'package:fpt_ojt/features/home/domain/usecases/get_home_uc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_event.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetHomeUc getHomeUc})
    : _getHomeUc = getHomeUc,
      super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
  }

  final GetHomeUc _getHomeUc;

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
            hasCard: homeData.hasCard,
          ),
        );
      },
    );
  }
}
