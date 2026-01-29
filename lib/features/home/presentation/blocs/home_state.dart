import 'package:fpt_ojt/features/merchants/domain/entities/merchant_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

enum HomeStatus { initial, loading, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    @Default([]) List<MerchantCategory> categories,
    String? errorMessage,
  }) = _HomeState;
}
