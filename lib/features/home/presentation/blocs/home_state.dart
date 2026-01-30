import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum LoadStatus { initial, loading, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(LoadStatus.initial) LoadStatus categoriesStatus,
    @Default(LoadStatus.initial) LoadStatus agenciesStatus,
    @Default([]) List<MerchantCategory> categories,
    @Default([]) List<MerchantAgency> nearestMerchantAgencies,
    String? errorMessage,
  }) = _HomeState;
}
