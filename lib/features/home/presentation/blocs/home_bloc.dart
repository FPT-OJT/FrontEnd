import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_event.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/location/domain/usecases/current_coordinate.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_merchant_categories.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_nearest_merchant_agencies.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetMerchantCategoriesUseCase getMerchantCategoriesUseCase,
    required GetNearestMerchantAgenciesUseCase
    getNearestMerchantAgenciesUseCase,
    required CurrentCoordinateUseCase currentCoordinateUseCase,
  }) : _getMerchantCategoriesUseCase = getMerchantCategoriesUseCase,
       _getNearestMerchantAgenciesUseCase = getNearestMerchantAgenciesUseCase,
       _currentCoordinateUseCase = currentCoordinateUseCase,
       super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
  }

  final GetMerchantCategoriesUseCase _getMerchantCategoriesUseCase;
  final GetNearestMerchantAgenciesUseCase _getNearestMerchantAgenciesUseCase;
  final CurrentCoordinateUseCase _currentCoordinateUseCase;

  static const int _defaultCategoryLimit = 10;
  static const int _defaultPage = 1;
  static const int _defaultAgencyLimit = 3;

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        categoriesStatus: LoadStatus.loading,
        agenciesStatus: LoadStatus.loading,
        errorMessage: null,
      ),
    );

    await Future.wait([_loadCategories(emit), _loadNearestAgencies(emit)]);
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
          categoriesStatus: LoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          categoriesStatus: LoadStatus.success,
          categories: categories,
        ),
      ),
    );
  }

  Future<void> _loadNearestAgencies(Emitter<HomeState> emit) async {
    final currentCoordinate = await _currentCoordinateUseCase(const NoParams());
    final coordinate = currentCoordinate.getOrElse(
      (failure) => const Coordinate(latitude: 0, longitude: 0),
    );
    final result = await _getNearestMerchantAgenciesUseCase(
      GetNearestMerchantAgenciesParams(
        limit: _defaultAgencyLimit,
        latitude: coordinate.latitude,
        longitude: coordinate.longitude,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          agenciesStatus: LoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (agencies) => emit(
        state.copyWith(
          agenciesStatus: LoadStatus.success,
          nearestMerchantAgencies: agencies,
        ),
      ),
    );
  }
}
