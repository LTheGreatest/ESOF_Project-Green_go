import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/controller/location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';

import 'location_test.mocks.dart';

@GenerateNiceMocks([MockSpec<StreamSubscription<Position>>()])

void main() {
  StreamSubscription<Position> positionStream = MockStreamSubscription();
}