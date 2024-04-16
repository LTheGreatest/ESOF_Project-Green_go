```import 'dart:async';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/controller/location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';

@GenerateNiceMocks([MockSpec<StreamSubscription<Position>>()])

import 'location_test.mocks.dart';

class MockPosition extends Mock implements Position {}
class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

void main() {
  late LocationService locationService;
  late MockGeolocatorPlatform mockGeolocator;
  late MockStreamSubscription mockPositionStream;

  setUp(() {
    mockGeolocator = MockGeolocatorPlatform();
    mockPositionStream = MockStreamSubscription();
    locationService = LocationService();
    locationService.setPositionStream(mockPositionStream);
  });

  group('LocationService', () {
    test('determinePosition() returns correct position', () async {
    final position = MockPosition();
    when(mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
    when(mockGeolocator.checkPermission()).thenAnswer((_) async => LocationPermission.always);
    when(mockGeolocator.getCurrentPosition()).thenAnswer((_) async => position);

    final result = await locationService.determinePosition();

    expect(result, equals(position));
    });

    test('checkIfLocationServiceIsEnabled() returns true if location service is enabled', () async {
      when(mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);

      final result = await locationService.checkIfLocationServiceIsEnabled();

      expect(result, isTrue);
    });

    test('checkLocationPermission() returns correct value based on permission status', () async {
      when(mockGeolocator.checkPermission()).thenAnswer((_) async => LocationPermission.denied);

      final result = await locationService.checkLocationPermission();

      expect(result, isFalse);
    });

    test('requestLocationPermission() requests permission and returns correct value', () async {
      when(mockGeolocator.checkPermission()).thenAnswer((_) async => LocationPermission.denied);
      when(mockGeolocator.requestPermission()).thenAnswer((_) async => LocationPermission.always);

      final result = await locationService.requestLocationPermission();

      expect(result, isTrue);
    });
  });
}
