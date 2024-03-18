import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<bool> requestPermission() async {
    final permission = await location.requestPermission();
    return permission == PermissionStatus.granted;
  }

  Future<PermissionStatus> hasPermission() async {
    return location.hasPermission();
  }

  Future<LocationData> getCurrentLocation() async {
    final serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      final result = await location.requestService;
        if (result != true) {
            throw Exception('GPS service not enabled');
          }
       }

    final locationData = await location.getLocation();
    return locationData;
  }
}
