import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'location_state.freezed.dart';

enum LoadStatus { initial, loading, success, failure }

@freezed
abstract class LocationState with _$LocationState {
  const factory LocationState({
    @Default(LoadStatus.initial) LoadStatus status,
    Coordinate? current,
    String? errorMessage,
  }) = _LocationState;
  factory LocationState.initial() => const LocationState();
  factory LocationState.loading() =>
      const LocationState(status: LoadStatus.loading);
  factory LocationState.success(Coordinate current) =>
      LocationState(status: LoadStatus.success, current: current);
  factory LocationState.failure(String errorMessage) =>
      LocationState(status: LoadStatus.failure, errorMessage: errorMessage);
}
