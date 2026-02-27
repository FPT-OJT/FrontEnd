import 'package:fpt_ojt/features/location/domain/entities/geofence.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_deal_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'geofence_state.freezed.dart';

enum GeofenceLoadStatus { initial, loading, success, failure }

@freezed
abstract class GeofenceState with _$GeofenceState {
  const factory GeofenceState({
    @Default(GeofenceLoadStatus.initial) GeofenceLoadStatus status,
    
    @Default([]) List<AgencyGeofence> geofences,

    String? activeAgencyId,

    @Default(false) bool isOpenDealDetails,
    @Default([]) List<MerchantDealDetail> selectedDeals,


    String? message,
  }) = _GeofenceState;
}
