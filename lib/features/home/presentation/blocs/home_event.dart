import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeRefreshNearestMerchantAgencies extends HomeEvent {
  const HomeRefreshNearestMerchantAgencies(this.coordinate);
  final Coordinate coordinate;
}
