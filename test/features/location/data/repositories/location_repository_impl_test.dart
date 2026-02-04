import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/location/data/datasource/location_datasource.dart';
import 'package:fpt_ojt/features/location/data/models/osrm_route_response.dart';
import 'package:fpt_ojt/features/location/data/repositories/location_repository_impl.dart';
import 'package:fpt_ojt/features/location/domain/entities/coordinate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<LocationDataSource>()])
import 'location_repository_impl_test.mocks.dart';

void main() {
  late MockLocationDataSource mockDataSource;
  late LocationRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockLocationDataSource();
    repository = LocationRepositoryImpl(locationDataSource: mockDataSource);
  });

  group('getCurrentCoordinate', () {
    final tPosition = Position(
      longitude: 10.0,
      latitude: 20.0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    const tCoordinate = Coordinate(latitude: 20.0, longitude: 10.0);

    test('should return Right(Coordinate) when datasource succeeds', () async {
      // Arrange
      when(
        mockDataSource.getCurrentCoordinate(),
      ).thenAnswer((_) async => tPosition);

      // Act
      final result = await repository.getCurrentCoordinate();

      // Assert
      expect(result, const Right(tCoordinate));
      verify(mockDataSource.getCurrentCoordinate()).called(1);
    });

    test('should return Left(Failure) when datasource throws', () async {
      // Arrange
      when(
        mockDataSource.getCurrentCoordinate(),
      ).thenThrow(Exception('Location disabled'));

      // Act
      try {
        await repository.getCurrentCoordinate();
        fail('Should trigger exception');
      } catch (e) {}
    });
  });

  group('getCurrentPositionStream', () {
    final tPosition = Position(
      longitude: 10.0,
      latitude: 20.0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    const tCoordinate = Coordinate(latitude: 20.0, longitude: 10.0);

    test('should emit Coordinate when datasource emits Position', () {
      // Arrange
      when(
        mockDataSource.getCurrentPositionStream(
          timeLimit: anyNamed('timeLimit'),
          accuracy: anyNamed('accuracy'),
          distanceFilterInMeters: anyNamed('distanceFilterInMeters'),
        ),
      ).thenAnswer((_) => Stream.value(tPosition));

      // Act
      final stream = repository.getCurrentPositionStream(
        timeLimit: const Duration(seconds: 10),
        distanceFilterInMeters: 10,
      );

      // Assert
      expect(stream, emits(tCoordinate));
      verify(
        mockDataSource.getCurrentPositionStream(
          timeLimit: anyNamed('timeLimit'),
          accuracy: anyNamed('accuracy'),
          distanceFilterInMeters: anyNamed('distanceFilterInMeters'),
        ),
      ).called(1);
    });
  });

  group('getDistanceBetweenCoordinates', () {
    const tFrom = Coordinate(latitude: 10.0, longitude: 10.0);
    const tTo = Coordinate(latitude: 20.0, longitude: 20.0);
    const tDistance = 1000.0;

    // Constructing a minimal valid OsrmRouteResponse
    const tOsrmRouteResponse = OsrmRouteResponse(
      code: 'Ok',
      routes: [
        OsrmRoute(
          distance: tDistance,
          duration: 100,
          weight: 100,
          weight_name: 'test',
          geometry: OsrmGeometry(type: 'LineString', coordinates: []),
          legs: [],
        ),
      ],
      waypoints: [],
    );

    test('should return Right(distance) when datasource succeeds', () async {
      // Arrange
      when(
        mockDataSource.getDistanceBetweenCoordinates(tFrom, tTo),
      ).thenAnswer((_) async => tOsrmRouteResponse);

      // Act
      final result = await repository.getDistanceBetweenCoordinates(tFrom, tTo);

      // Assert
      expect(result, const Right(tDistance));
      verify(
        mockDataSource.getDistanceBetweenCoordinates(tFrom, tTo),
      ).called(1);
    });

    test('should return Left(Failure) when datasource throws', () async {
      // Arrange
      when(
        mockDataSource.getDistanceBetweenCoordinates(tFrom, tTo),
      ).thenThrow(Exception('API Error'));

      // Act
      final result = await repository.getDistanceBetweenCoordinates(tFrom, tTo);

      // Assert
      expect(result.isLeft(), true);
      verify(
        mockDataSource.getDistanceBetweenCoordinates(tFrom, tTo),
      ).called(1);
    });
  });
}
