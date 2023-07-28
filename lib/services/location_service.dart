import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestLocationPermission() async {
  PermissionStatus permissionStatus =
      await Permission.locationWhenInUse.request();
  return permissionStatus.isGranted;
}

// Future<bool> requestBackgroundLocationPermission() async {
//   PermissionStatus permissionStatus = await Permission.location.request();
//   return permissionStatus.isGranted;
// }

Future<Position> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled on the device
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // Check the location permission status
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Request location permissions if not granted
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
  }

  // If permissions are permanently denied, inform the user
  if (permission == LocationPermission.deniedForever) {
    throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  try {
    // Fetch the current position
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    return await geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 20),
      distanceFilter: 15,
    ));
  } catch (e) {
    return Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now(),
        accuracy: 10,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0);
  }
}
