import 'package:equatable/equatable.dart';

class MerchantDetailEvent extends Equatable {
  const MerchantDetailEvent();
  @override
  List<Object?> get props => [];
}

class MerchantDetailStarted extends MerchantDetailEvent {
  const MerchantDetailStarted({required this.merchantId});
  final String merchantId;
  @override
  List<Object?> get props => [merchantId];
}

