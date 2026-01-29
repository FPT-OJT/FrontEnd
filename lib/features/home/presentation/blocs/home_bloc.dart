import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_event.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_state.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/getMerchantCategories.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetMerchantCategoriesUseCase getMerchantCategoriesUseCase})
    : _getMerchantCategoriesUseCase = getMerchantCategoriesUseCase,
      super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
  }
  final GetMerchantCategoriesUseCase _getMerchantCategoriesUseCase;
  final int defaultLimit = 10;
  final int defaultPage = 1;

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState(status: HomeStatus.loading));
    final result = await _getMerchantCategoriesUseCase.call(
      GetMerchantCategoriesParams(page: defaultPage, limit: defaultLimit),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(status: HomeStatus.success, categories: categories),
      ),
    );
  }
}
