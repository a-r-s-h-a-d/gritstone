import 'package:hive_flutter/hive_flutter.dart';

part 'locationbattery.g.dart';

@HiveType(typeId: 1)
class LocationBattery extends HiveObject {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  @HiveField(2)
  int batteryLevel;

  LocationBattery({
    required this.latitude,
    required this.longitude,
    required this.batteryLevel,
  });
}
