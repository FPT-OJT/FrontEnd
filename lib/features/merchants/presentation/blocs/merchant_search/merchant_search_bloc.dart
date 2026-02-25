import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_recent_searches.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/push_recent_search.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/search_merchant_agencies.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_search/merchant_search_event.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_search/merchant_search_state.dart';
import 'package:stream_transform/stream_transform.dart';

class MerchantSearchBloc
    extends Bloc<MerchantSearchEvent, MerchantSearchState> {
  MerchantSearchBloc({
    required SearchMerchantAgenciesUseCase searchMerchantAgenciesUseCase,
    required GetRecentSearchesUseCase getRecentSearchesUseCase,
    required PushRecentSearchUseCase pushRecentSearchUseCase,
  }) : _searchUseCase = searchMerchantAgenciesUseCase,
       _getRecentUseCase = getRecentSearchesUseCase,
       _pushRecentUseCase = pushRecentSearchUseCase,
       super(const MerchantSearchState()) {
    on<MerchantSearchStarted>(_onStarted);
    on<MerchantSearchQueryChanged>(_onQueryChanged, transformer: _debounce());
    on<MerchantSearchResultTapped>(_onResultTapped);
  }

  final SearchMerchantAgenciesUseCase _searchUseCase;
  final GetRecentSearchesUseCase _getRecentUseCase;
  final PushRecentSearchUseCase _pushRecentUseCase;

  static EventTransformer<MerchantSearchQueryChanged> _debounce() =>
      (events, mapper) =>
          events.debounce(const Duration(milliseconds: 400)).switchMap(mapper);

  Future<void> _onStarted(
    MerchantSearchStarted event,
    Emitter<MerchantSearchState> emit,
  ) async {
    final result = await _getRecentUseCase(const NoParams());
    result.fold(
      (_) {},
      (recent) => emit(state.copyWith(recentSearches: recent)),
    );
  }

  Future<void> _onQueryChanged(
    MerchantSearchQueryChanged event,
    Emitter<MerchantSearchState> emit,
  ) async {
    final query = event.query.trim();
    emit(state.copyWith(query: event.query, clearError: true));

    if (query.isEmpty) {
      emit(state.copyWith(query: event.query, results: [], isLoading: false));
      return;
    }

    emit(state.copyWith(query: event.query, isLoading: true, results: []));

    final result = await _searchUseCase(
      SearchMerchantAgenciesParams(keyword: query),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (agencies) => emit(state.copyWith(isLoading: false, results: agencies)),
    );
  }

  Future<void> _onResultTapped(
    MerchantSearchResultTapped event,
    Emitter<MerchantSearchState> emit,
  ) async {
    await _pushRecentUseCase(event.agency);
    // Refresh recent list in state
    final result = await _getRecentUseCase(const NoParams());
    result.fold(
      (_) {},
      (recent) => emit(state.copyWith(recentSearches: recent)),
    );
  }
}
