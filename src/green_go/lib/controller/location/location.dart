import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  double currentLongitude = 0;
  double currentLatitude = 0;

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
  
  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    //calculates the distance between two coordinates
    if(startLatitude < -90 || startLatitude > 90 || startLongitude < -180 || startLongitude > 180 || endLatitude < -90 || endLatitude > 90 || endLongitude < -180 || endLongitude > 180 ){
      return 0;
    }
    else{
      return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    }
  }
}
