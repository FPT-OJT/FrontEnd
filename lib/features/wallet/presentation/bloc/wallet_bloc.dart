import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/wallet/domain/usecases/get_my_apps.dart';
import 'package:fpt_ojt/features/wallet/domain/usecases/get_my_cards.dart';
import 'package:fpt_ojt/features/wallet/domain/usecases/get_my_fav_merchants.dart';
import 'package:fpt_ojt/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:fpt_ojt/features/wallet/presentation/bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({
    required GetMyCards getMyCards,
    required GetMyApps getMyApps,
    required GetMyFavMerchants getMyFavMerchants,
  }) : _getMyCards = getMyCards,
       _getMyApps = getMyApps,
       _getMyFavMerchants = getMyFavMerchants,
       super(const WalletState()) {
    on<LoadCreditCards>(_onLoadCreditCards);
    on<LoadPaymentApps>(_onLoadPaymentApps);
    on<LoadFavoriteMerchants>(_onLoadFavoriteMerchants);
  }

  final GetMyCards _getMyCards;
  final GetMyApps _getMyApps;
  final GetMyFavMerchants _getMyFavMerchants;

  Future<void> _onLoadCreditCards(
    LoadCreditCards event,
    Emitter<WalletState> emit,
  ) async {
    if (state.creditCardStatus == WalletLoadStatus.loading) {
      return;
    }

    emit(state.copyWith(creditCardStatus: WalletLoadStatus.loading));

    final result = await _getMyCards(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          creditCardStatus: WalletLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (cards) => emit(
        state.copyWith(
          creditCardStatus: WalletLoadStatus.success,
          creditCards: cards,
        ),
      ),
    );
  }

  Future<void> _onLoadPaymentApps(
    LoadPaymentApps event,
    Emitter<WalletState> emit,
  ) async {
    if (state.paymentAppsStatus == WalletLoadStatus.loading) {
      return;
    }

    emit(state.copyWith(paymentAppsStatus: WalletLoadStatus.loading));

    final result = await _getMyApps(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          paymentAppsStatus: WalletLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (apps) => emit(
        state.copyWith(
          paymentAppsStatus: WalletLoadStatus.success,
          paymentApps: apps,
        ),
      ),
    );
  }

  Future<void> _onLoadFavoriteMerchants(
    LoadFavoriteMerchants event,
    Emitter<WalletState> emit,
  ) async {
    if (state.favoriteMerchantsStatus == WalletLoadStatus.loading) {
      return;
    }

    emit(state.copyWith(favoriteMerchantsStatus: WalletLoadStatus.loading));

    final result = await _getMyFavMerchants(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          favoriteMerchantsStatus: WalletLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (merchants) => emit(
        state.copyWith(
          favoriteMerchantsStatus: WalletLoadStatus.success,
          favoriteMerchants: merchants,
        ),
      ),
    );
  }
}
