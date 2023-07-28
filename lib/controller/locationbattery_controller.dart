import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gritstone/model/db/locationbattery.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocationBatteryController with ChangeNotifier {
  List<LocationBattery> locationBatteryList = [];
  double latitude = 0;
  double longitude = 0;
  String locationName = 'Unknown Location';
  bool isLoading = true;
  bool hasError = false;

  final Duration geocodingThrottleDuration =
      const Duration(seconds: 10); // Throttle duration
  Timer? _geocodingTimer;

  Future<void> getStoredLocationData() async {
    final locationBox = Hive.box<LocationBattery>('locationDataBox');
    locationBatteryList = locationBox.values.toList();
    isLoading = true;
    notifyListeners();
  }

  Future<void> updateLocationData() async {
    isLoading = true;
    final locationBattery = locationBatteryList.isNotEmpty
        ? locationBatteryList.first
        : LocationBattery(latitude: 0, longitude: 0, batteryLevel: 0);

    latitude = locationBattery.latitude;
    longitude = locationBattery.longitude;

    // Throttle geocoding requests
    if (_geocodingTimer != null && _geocodingTimer!.isActive) {
      _geocodingTimer!.cancel();
    }

    _geocodingTimer = Timer(geocodingThrottleDuration, () async {
      print('Performing geocoding...');
      await _performGeocoding();
    });
  }

  Future<void> _performGeocoding() async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks.first;
        locationName = placemark.name ?? 'Unknown Location';
      } else {
        locationName = 'Unknown Location';
      }
    } catch (e) {
      locationName = 'Error occurred while fetching location data';
      hasError = true;
      // Handle the exception properly (e.g., log the error or show a message)
    }

    isLoading = false;
    notifyListeners();
    print('Geocoding complete.');
  }
}
