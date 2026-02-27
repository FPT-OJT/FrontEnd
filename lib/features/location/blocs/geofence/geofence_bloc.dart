import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/di/init_dependencies.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_event.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_state.dart';
import 'package:fpt_ojt/features/location/domain/usecases/init_geofence.dart';
import 'package:fpt_ojt/features/location/utils/geofence_observer.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_merchant_deal.dart';
import 'package:fpt_ojt/features/shared/utils/permission_service.dart';

class GeofenceBloc extends Bloc<GeofenceEvent, GeofenceState> {
  GeofenceBloc(this._initGeofenceUseCase, this._getMerchantDealUseCase)
    : super(const GeofenceState()) {
    on<GeofenceStarted>(_onStarted);
    on<GeofenceEntered>(_onEntered);
    on<GeofenceExited>(_onExited);
    on<GeofenceFetchDealDetails>(_onFetchDealDetails);
    on<GeofenceCloseDealDetails>(_onCloseDealDetails);
  }
  bool isFetchingDealDetails = false;

  final InitGeofenceUseCase _initGeofenceUseCase;
  final GetMerchantDealUseCase _getMerchantDealUseCase;
  Future<void> _onStarted(
    GeofenceStarted event,
    Emitter<GeofenceState> emit,
  ) async {
    emit(state.copyWith(status: GeofenceLoadStatus.loading));
    await PermissionService.requestGeofencePermissions();
    // ignore: void_checks
    final result = await _initGeofenceUseCase.call(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GeofenceLoadStatus.failure,
          message: failure.message,
        ),
      ),
      (geofences) {
        debugPrint('geofences: $geofences');
        return emit(
          state.copyWith(
            status: GeofenceLoadStatus.success,
            geofences: geofences,
          ),
        );
      },
    );
    serviceLocator<GeofenceObserver>().start();
  }

  Future<void> _onEntered(
    GeofenceEntered event,
    Emitter<GeofenceState> emit,
  ) async {
    if (state.activeAgencyId == event.agencyId) return;

    emit(state.copyWith(activeAgencyId: event.agencyId));

    try {
      emit(state.copyWith(message: 'You are in ${event.agencyId}'));
    } on Exception catch (_) {
      emit(state.copyWith(message: 'Cannot load agency information'));
    }
    add(GeofenceFetchDealDetails(agencyId: event.agencyId));
  }

  Future<void> _onFetchDealDetails(
    GeofenceFetchDealDetails event,
    Emitter<GeofenceState> emit,
  ) async {
    if (isFetchingDealDetails) return;
    isFetchingDealDetails = true;
    final result = await _getMerchantDealUseCase.call(event.agencyId);
    isFetchingDealDetails = false;
    result.fold(
      (failure) => emit(state.copyWith(message: failure.message)),
      (deals) => emit(state.copyWith(selectedDeals: deals,isOpenDealDetails: true)),
    );
  }

  Future<void> _onExited(
    GeofenceExited event,
    Emitter<GeofenceState> emit,
  ) async {
    if (state.activeAgencyId != event.agencyId) return;

    emit(
      state.copyWith(
        activeAgencyId: null,
        message: 'You have left the agency',
        selectedDeals: [],
        isOpenDealDetails: false,
      ),
    );
  }

  Future<void> _onCloseDealDetails(
    GeofenceCloseDealDetails event,
    Emitter<GeofenceState> emit,
  ) async {
    emit(state.copyWith(isOpenDealDetails: false));
  }
}
