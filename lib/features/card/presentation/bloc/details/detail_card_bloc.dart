import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/card/domain/usecases/add_card_to_user_usecase.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/details/detail_card_event.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/details/detail_card_state.dart';

class DetailCardBloc extends Bloc<DetailCardEvent, DetailCardState> {
  DetailCardBloc({required AddCardToUserUsecase addCardToUserUsecase})
    : _addCardToUserUsecase = addCardToUserUsecase,
      super(const DetailCardState()) {
    on<OnCardAddEvent>(_onCardAdd);
  }

  final AddCardToUserUsecase _addCardToUserUsecase;

  Future<void> _onCardAdd(
    OnCardAddEvent event,
    Emitter<DetailCardState> emit,
  ) async {
    if (state.detailStatus == DetailCardLoadStatus.loading) {
      return;
    }

    emit(state.copyWith(detailStatus: DetailCardLoadStatus.loading));

    final result = await _addCardToUserUsecase(
      AddCardToUserParams(cardId: event.cardId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          detailStatus: DetailCardLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          detailStatus: DetailCardLoadStatus.success,
          isCurrentCardInUser: success,
        ),
      ),
    );
  }
}
