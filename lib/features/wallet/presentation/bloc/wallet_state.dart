import 'package:fpt_ojt/features/wallet/domain/entities/wallet_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_state.freezed.dart';

enum WalletLoadStatus { initial, loading, success, failure }

@freezed
abstract class WalletState with _$WalletState {
  const factory WalletState({
    @Default(WalletLoadStatus.initial) WalletLoadStatus creditCardStatus,
    @Default(WalletLoadStatus.initial) WalletLoadStatus paymentAppsStatus,
    @Default(WalletLoadStatus.initial) WalletLoadStatus favoriteMerchantsStatus,
    @Default([]) List<WalletItem> creditCards,
    @Default([]) List<WalletItem> paymentApps,
    @Default([]) List<WalletItem> favoriteMerchants,
    String? errorMessage,
  }) = _WalletState;
}
