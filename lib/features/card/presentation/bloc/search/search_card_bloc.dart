import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/card/domain/usecases/search_cards_usecase.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/search/search_card_event.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/search/search_card_state.dart';

class SearchCardBloc extends Bloc<SearchCardEvent, SearchCardState> {
  SearchCardBloc({required SearchCardsUsecase searchCardsUsecase})
    : _searchCardsUsecase = searchCardsUsecase,
      super(const SearchCardState()) {
    on<OnTextChangedEvent>(_onTextChanged);
  }

  final SearchCardsUsecase _searchCardsUsecase;

  Future<void> _onTextChanged(
    OnTextChangedEvent event,
    Emitter<SearchCardState> emit,
  ) async {
    if (state.searchStatus == SearchCardLoadStatus.loading) {
      return;
    }

    emit(state.copyWith(searchStatus: SearchCardLoadStatus.loading));

    final result = await _searchCardsUsecase(
      SearchCardsParams(keyword: event.keyword, limit: 10),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          searchStatus: SearchCardLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (cards) => emit(
        state.copyWith(
          searchStatus: SearchCardLoadStatus.success,
          cards: cards,
        ),
      ),
    );
  }
}
