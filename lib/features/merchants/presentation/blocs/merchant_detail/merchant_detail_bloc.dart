import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_is_merchant_favorite.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_is_merchant_subscribed.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_merchant_agency_detail.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/toggle_favorite_merchant.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/toggle_subscribe_merchant.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_event.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_state.dart';

class MerchantDetailBloc
    extends Bloc<MerchantDetailEvent, MerchantDetailState> {
  MerchantDetailBloc({
    required GetMerchantAgencyDetailUseCase getMerchantAgencyDetailUseCase,
    required GetIsMerchantFavoriteUseCase getIsMerchantFavoriteUseCase,
    required GetIsMerchantSubscribedUseCase getIsMerchantSubscribedUseCase,
    required ToggleFavoriteMerchantUseCase toggleFavoriteMerchantUseCase,
    required ToggleSubscribeMerchantUseCase toggleSubscribeMerchantUseCase,
  }) : _getMerchantAgencyDetailUseCase = getMerchantAgencyDetailUseCase,
       _getIsMerchantFavoriteUseCase = getIsMerchantFavoriteUseCase,
       _getIsMerchantSubscribedUseCase = getIsMerchantSubscribedUseCase,
       _toggleFavoriteMerchantUseCase = toggleFavoriteMerchantUseCase,
       _toggleSubscribeMerchantUseCase = toggleSubscribeMerchantUseCase,
       super(const MerchantDetailInitial()) {
    on<MerchantDetailStarted>(_onMerchantDetailStarted);
    on<MerchantDetailCardSelected>(_onMerchantDetailCardSelected);
    on<MerchantDetailDealIndexChanged>(_onMerchantDetailDealIndexChanged);
    on<MerchantDetailFavoriteToggled>(_onFavoriteToggled);
    on<MerchantDetailSubscribeToggled>(_onSubscribeToggled);
  }

  final GetMerchantAgencyDetailUseCase _getMerchantAgencyDetailUseCase;
  final GetIsMerchantFavoriteUseCase _getIsMerchantFavoriteUseCase;
  final GetIsMerchantSubscribedUseCase _getIsMerchantSubscribedUseCase;
  final ToggleFavoriteMerchantUseCase _toggleFavoriteMerchantUseCase;
  final ToggleSubscribeMerchantUseCase _toggleSubscribeMerchantUseCase;

  Future<void> _onMerchantDetailStarted(
    MerchantDetailStarted event,
    Emitter<MerchantDetailState> emit,
  ) async {
    emit(const MerchantDetailLoading());
    final result = await _getMerchantAgencyDetailUseCase.call(event.merchantId);
    await result.fold(
      (failure) async => emit(MerchantDetailError(error: failure.message)),
      (merchantDetail) async {
        // Load favorite and subscribe status in parallel
        final results = await Future.wait([
          _getIsMerchantFavoriteUseCase.call(event.merchantId),
          _getIsMerchantSubscribedUseCase.call(event.merchantId),
        ]);
        final isFavorite = results[0].getOrElse((_) => false);
        final isSubscribed = results[1].getOrElse((_) => false);
        emit(
          MerchantDetailLoaded(
            merchantDetail: merchantDetail,
            isFavorite: isFavorite,
            isSubscribed: isSubscribed,
          ),
        );
      },
    );
  }

  Future<void> _onMerchantDetailCardSelected(
    MerchantDetailCardSelected event,
    Emitter<MerchantDetailState> emit,
  ) async {
    if (state is MerchantDetailLoaded) {
      final loadedState = state as MerchantDetailLoaded;
      emit(
        loadedState.copyWith(selectedCard: event.card, selectedDealIndex: 0),
      );
    }
  }

  Future<void> _onMerchantDetailDealIndexChanged(
    MerchantDetailDealIndexChanged event,
    Emitter<MerchantDetailState> emit,
  ) async {
    if (state is MerchantDetailLoaded) {
      final loadedState = state as MerchantDetailLoaded;
      emit(loadedState.copyWith(selectedDealIndex: event.dealIndex));
    }
  }

  Future<void> _onFavoriteToggled(
    MerchantDetailFavoriteToggled event,
    Emitter<MerchantDetailState> emit,
  ) async {
    if (state is! MerchantDetailLoaded) return;
    final loadedState = state as MerchantDetailLoaded;

    // Optimistic update
    emit(loadedState.copyWith(isFavorite: !loadedState.isFavorite));

    final result = await _toggleFavoriteMerchantUseCase.call(
      loadedState.merchantDetail.agencyId,
    );

    // Revert on failure
    result.fold(
      (_) => emit(loadedState),
      (_) {},
    );
  }

  Future<void> _onSubscribeToggled(
    MerchantDetailSubscribeToggled event,
    Emitter<MerchantDetailState> emit,
  ) async {
    if (state is! MerchantDetailLoaded) return;
    final loadedState = state as MerchantDetailLoaded;

    // Optimistic update
    emit(loadedState.copyWith(isSubscribed: !loadedState.isSubscribed));

    final result = await _toggleSubscribeMerchantUseCase.call(
      loadedState.merchantDetail.agencyId,
    );

    // Revert on failure
    result.fold(
      (_) => emit(loadedState),
      (_) {},
    );
  }
}
