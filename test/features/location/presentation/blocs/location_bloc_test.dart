import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/location/blocs/location_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/location_event.dart';
import 'package:fpt_ojt/features/location/blocs/location_state.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:fpt_ojt/features/location/domain/usecases/coordinate_stream.dart';
import 'package:fpt_ojt/features/location/domain/usecases/current_coordinate.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<CurrentCoordinateUseCase>(),
  MockSpec<CoordinateStreamUseCase>(),
])
import 'location_bloc_test.mocks.dart';

void main() {
  late MockCurrentCoordinateUseCase mockCurrentCoordinateUseCase;
  late MockCoordinateStreamUseCase mockCoordinateStreamUseCase;
  late LocationBloc bloc;

  setUp(() {
    provideDummy<Either<Failure, Stream<Coordinate>>>(Left(Failure('dummy')));
    provideDummy<Either<Failure, Coordinate>>(Left(Failure('dummy')));

    mockCurrentCoordinateUseCase = MockCurrentCoordinateUseCase();
    mockCoordinateStreamUseCase = MockCoordinateStreamUseCase();
    bloc = LocationBloc(
      currentCoordinateUseCase: mockCurrentCoordinateUseCase,
      coordinateStreamUseCase: mockCoordinateStreamUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('LocationBloc', () {
    const tCoordinate = Coordinate(latitude: 10.0, longitude: 10.0);
    const tErrorMessage = 'Error';

    group('LocationStarted', () {
      blocTest<LocationBloc, LocationState>(
        'emits [loading, success] when stream emits coordinate',
        build: () {
          when(
            mockCurrentCoordinateUseCase.call(any),
          ).thenAnswer((_) async => const Right(tCoordinate));
          when(
            mockCoordinateStreamUseCase.call(any),
          ).thenAnswer((_) async => Right(Stream.value(tCoordinate)));
          return bloc;
        },
        act: (bloc) => bloc.add(const LocationStarted()),
        expect: () => [
          LocationState.loading(),
          LocationState.success(tCoordinate),
        ],
        verify: (_) {
          verify(mockCoordinateStreamUseCase.call(any)).called(1);
        },
      );

      blocTest<LocationBloc, LocationState>(
        'emits [loading, success, failure] when stream returns failure',
        build: () {
          when(
            mockCurrentCoordinateUseCase.call(any),
          ).thenAnswer((_) async => const Right(tCoordinate));
          when(
            mockCoordinateStreamUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure(tErrorMessage)));
          return bloc;
        },
        act: (bloc) => bloc.add(const LocationStarted()),
        expect: () => [
          LocationState.loading(),
          LocationState.success(tCoordinate),
          LocationState.failure(tErrorMessage),
        ],
      );
    });

    group('LocationStopped', () {
      blocTest<LocationBloc, LocationState>(
        'emits [initial] when stopped',
        build: () => bloc,
        act: (bloc) => bloc.add(const LocationStopped()),
        expect: () => [LocationState.initial()],
      );
    });

    group('LocationRequested', () {
      blocTest<LocationBloc, LocationState>(
        'emits [loading, success] when usecase returns coordinate',
        build: () {
          when(
            mockCurrentCoordinateUseCase.call(any),
          ).thenAnswer((_) async => const Right(tCoordinate));
          return bloc;
        },
        act: (bloc) => bloc.add(const LocationRequested()),
        expect: () => [
          LocationState.loading(),
          LocationState.success(tCoordinate),
        ],
        verify: (_) {
          verify(mockCurrentCoordinateUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<LocationBloc, LocationState>(
        'emits [loading, failure] when usecase returns failure',
        build: () {
          when(
            mockCurrentCoordinateUseCase.call(any),
          ).thenAnswer((_) async => Left(Failure(tErrorMessage)));
          return bloc;
        },
        act: (bloc) => bloc.add(const LocationRequested()),
        expect: () => [
          LocationState.loading(),
          LocationState.failure(tErrorMessage),
        ],
      );
    });

    group('LocationFailed', () {
      blocTest<LocationBloc, LocationState>(
        'emits [failure] with error message',
        build: () => bloc,
        act: (bloc) => bloc.add(const LocationFailed(tErrorMessage)),
        expect: () => [LocationState.failure(tErrorMessage)],
      );
    });
  });
}
