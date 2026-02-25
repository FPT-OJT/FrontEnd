import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';

sealed class MerchantSearchEvent extends Equatable {
  const MerchantSearchEvent();

  @override
  List<Object?> get props => [];
}

class MerchantSearchStarted extends MerchantSearchEvent {
  const MerchantSearchStarted();
}

class MerchantSearchQueryChanged extends MerchantSearchEvent {
  const MerchantSearchQueryChanged({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class MerchantSearchResultTapped extends MerchantSearchEvent {
  const MerchantSearchResultTapped({required this.agency});

  final MerchantAgency agency;

  @override
  List<Object?> get props => [agency];
}
