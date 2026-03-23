import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadCreditCards extends WalletEvent {
  const LoadCreditCards();
}

class LoadPaymentApps extends WalletEvent {
  const LoadPaymentApps();
}

class LoadFavoriteMerchants extends WalletEvent {
  const LoadFavoriteMerchants();
}
