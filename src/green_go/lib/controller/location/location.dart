import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  late StreamSubscription<Position> _positionStream;
  double currentLongitude = 0;
  double currentLatitude = 0;

  void setPositionStream(StreamSubscription<Position> posStream){
    _positionStream = posStream;
  }

  Future<Position> determinePosition() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled return an error message
      return Future.error('Location services are disabled.');
    }
    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }
    // If permissions are granted, return the current location
    return await Geolocator.getCurrentPosition();
  }
  
  Future<bool> checkIfLocationServiceIsEnabled() async {
    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      // You can fetch location data here or alert the user that location services are turned on.
      if (kDebugMode) {
        print('Location services are enabled');
      }
      return true;
    } else {
      // You could try to prompt the user to turn on location services here or handle it differently.
      if (kDebugMode) {
        print('Location services are disabled');
      }
      return false;
    }
  }
  
  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied.
      if (kDebugMode) {
        print("Location permissions are denied");
      }
      return false;
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever.
      if (kDebugMode) {
        print("Location permissions are permanently denied");
      }
      return false;
    } else {
      // Permissions are granted (either can be whileInUse, always, restricted).
      if (kDebugMode) {
        print("Location permissions are granted");
      }
      return true;
    }
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      // Permissions are denied or denied forever, let's request it!
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print("Location permissions are still denied");
        }
        return false;
      } else if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print("Location permissions are permanently denied");
        }
        return false;
      } else {
        // Permissions are granted (either can be whileInUse, always, restricted).
        if (kDebugMode) {
          print("Location permissions are granted after requesting");
        }
        return true;
      }
    }
    return true;
  }

  void getLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position position) {
        currentLatitude = position.latitude; 
        currentLongitude = position.longitude;
      });
  }

  void stopListening() {
    _positionStream.cancel();
  }

  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    if(startLatitude < -90 || startLatitude > 90 || startLongitude < -180 || startLongitude > 180 || endLatitude < -90 || endLatitude > 90 || endLongitude < -180 || endLongitude > 180 ){
      return 0;
    }
    else{
      return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    }
  }
}
