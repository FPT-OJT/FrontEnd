import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/card/domain/usecases/add_card_to_user_usecase.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/add_details/detail_card_sheet_event.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/add_details/detail_card_sheet_state.dart';

class DetailCardSheetBloc
    extends Bloc<DetailCardSheetEvent, DetailCardSheetState> {
  DetailCardSheetBloc({required AddCardToUserUsecase addCardToUserUsecase})
    : _addCardToUserUsecase = addCardToUserUsecase,
      super(const DetailCardSheetState()) {
    on<OnCardAddEvent>(_onCardAdd);
  }

  final AddCardToUserUsecase _addCardToUserUsecase;

  Future<void> _onCardAdd(
    OnCardAddEvent event,
    Emitter<DetailCardSheetState> emit,
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
      (userCardId) => emit(
        state.copyWith(
          detailStatus: DetailCardLoadStatus.success,
          userCardId: userCardId,
        ),
      ),
    );
  }
}
