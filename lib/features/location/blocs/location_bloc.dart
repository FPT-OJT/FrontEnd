import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/location/blocs/location_event.dart';
import 'package:fpt_ojt/features/location/blocs/location_state.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/location/domain/usecases/coordinate_stream.dart';
import 'package:fpt_ojt/features/location/domain/usecases/current_coordinate.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({
    required CurrentCoordinateUseCase currentCoordinateUseCase,
    required CoordinateStreamUseCase coordinateStreamUseCase,
  }) : _currentCoordinateUseCase = currentCoordinateUseCase,
       _coordinateStreamUseCase = coordinateStreamUseCase,
       super(const LocationState()) {
    on<LocationStarted>(_onLocationStarted);
    on<LocationStopped>(_onLocationStopped);
    on<LocationRequested>(_onLocationRequested);
    on<LocationFailed>(_onLocationFailed);
  }
  final CurrentCoordinateUseCase _currentCoordinateUseCase;
  final CoordinateStreamUseCase _coordinateStreamUseCase;
  final int coordinateUpdateDuration = 20;
  final int coordinateUpdateDistanceFilterInMeters = 10;
  Future<void> _onLocationStarted(
    LocationStarted event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationState.loading());
    // initial coordinate
    final currentCoordinate = await _currentCoordinateUseCase.call(
      const NoParams(),
    );
    currentCoordinate.fold(
      (failure) => emit(LocationState.failure(failure.message)),
      (coordinate) => emit(LocationState.success(coordinate)),
    );

    final result = await _coordinateStreamUseCase.call(
      CoordinateStreamParams(
        timeLimit: Duration(seconds: coordinateUpdateDuration),
        distanceFilterInMeters: coordinateUpdateDistanceFilterInMeters,
      ),
    );
    // listen to stream and emit new state
    await result.fold(
      (failure) async {
        emit(LocationState.failure(failure.message));
      },
      (stream) async {
        await emit.forEach<Coordinate>(
          stream,
          onData: (coordinate) {
            debugPrint('coordinate: $coordinate');
            return LocationState.success(coordinate);
          },
          onError: (error, _) {
            debugPrint('error: $error');
            return state;
          },
        );
      },
    );
  }

  Future<void> _onLocationStopped(
    LocationStopped event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationState.initial());
  }

  Future<void> _onLocationRequested(
    LocationRequested event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationState.loading());
    final result = await _currentCoordinateUseCase.call(const NoParams());
    result.fold(
      (failure) => emit(LocationState.failure(failure.message)),
      (coordinate) => emit(LocationState.success(coordinate)),
    );
  }

  Future<void> _onLocationFailed(
    LocationFailed event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationState.failure(event.error));
  }
}
