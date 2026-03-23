import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/card/domain/usecases/delete_user_card_usecase.dart';
import 'package:fpt_ojt/features/card/domain/usecases/edit_user_card_usecase.dart';
import 'package:fpt_ojt/features/card/domain/usecases/get_user_card_detail_usecase.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_event.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_state.dart';
import 'package:fpt_ojt/features/card/presentation/constants/card_text.dart';

class SettingCardBloc extends Bloc<SettingCardEvent, SettingCardState> {
  SettingCardBloc({
    required GetUserCardDetailUsecase getUserCardDetailUsecase,
    required EditUserCardUsecase editUserCardUsecase,
    required DeleteUserCardUsecase deleteUserCardUsecase,
  }) : _getUserCardDetailUsecase = getUserCardDetailUsecase,
       _editUserCardUsecase = editUserCardUsecase,
       _deleteUserCardUsecase = deleteUserCardUsecase,
       super(const SettingCardState()) {
    on<OnCardSettingLoadEvent>(_onCardSettingLoad);
    on<OnCardSettingUpdateEvent>(_onCardSettingUpdate);
    on<OnCardSettingDataChangedEvent>(_onCardSettingDataChanged);
    on<OnCardSettingDeleteEvent>(_onCardSettingDelete);
  }

  final GetUserCardDetailUsecase _getUserCardDetailUsecase;
  final EditUserCardUsecase _editUserCardUsecase;
  final DeleteUserCardUsecase _deleteUserCardUsecase;

  Future<void> _onCardSettingLoad(
    OnCardSettingLoadEvent event,
    Emitter<SettingCardState> emit,
  ) async {
    emit(state.copyWith(settingStatus: SettingCardStateStatus.loading));

    final result = await _getUserCardDetailUsecase(
      GetUserCardDetailParams(userCardId: event.cardId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          settingStatus: SettingCardStateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (cardDetail) {
        String? warningMessage;

        // Check if expiry date is less than 30 days from now
        if (cardDetail.expiryDate != null) {
          final now = DateTime.now();
          final daysUntilExpiry = cardDetail.expiryDate!.difference(now).inDays;

          if (daysUntilExpiry < 0) {
            warningMessage = CardText.expiredNow;
          } else if (daysUntilExpiry < 30) {
            warningMessage = CardText.expiredSoon;
          }
        }

        emit(
          state.copyWith(
            settingStatus: SettingCardStateStatus.success,
            cardDetail: cardDetail,
            warningMessage: warningMessage,
          ),
        );
      },
    );
  }

  Future<void> _onCardSettingUpdate(
    OnCardSettingUpdateEvent event,
    Emitter<SettingCardState> emit,
  ) async {
    emit(state.copyWith(settingStatus: SettingCardStateStatus.updating));

    final result = await _editUserCardUsecase(
      EditUserCardParams(
        cardId: event.cardId,
        firstPaymentDate: event.firstPaymentDate,
        expiryDate: event.expiryDate,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          settingStatus: SettingCardStateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) =>
          emit(state.copyWith(settingStatus: SettingCardStateStatus.updated)),
    );
  }

  void _onCardSettingDataChanged(
    OnCardSettingDataChangedEvent event,
    Emitter<SettingCardState> emit,
  ) {
    emit(state.copyWith(isDataChanged: true));
  }

  Future<void> _onCardSettingDelete(
    OnCardSettingDeleteEvent event,
    Emitter<SettingCardState> emit,
  ) async {
    emit(state.copyWith(settingStatus: SettingCardStateStatus.deleting));

    final result = await _deleteUserCardUsecase(
      DeleteUserCardParams(userCardId: event.userCardId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          settingStatus: SettingCardStateStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) =>
          emit(state.copyWith(settingStatus: SettingCardStateStatus.deleted)),
    );
  }
}
