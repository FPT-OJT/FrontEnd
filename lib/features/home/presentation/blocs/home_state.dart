import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomeLoadStatus { initial, loading, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeLoadStatus.initial) HomeLoadStatus categoriesStatus,
    @Default(HomeLoadStatus.initial) HomeLoadStatus agenciesStatus,
    @Default([]) List<MerchantCategory> categories,
    @Default([]) List<MerchantAgency> nearestMerchantAgencies,
    String? errorMessage,
    Coordinate? currentCoordinate,
  }) = _HomeState;
}
