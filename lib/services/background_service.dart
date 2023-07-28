import 'dart:async';
import 'dart:ui';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:gritstone/model/db/locationbattery.dart';
import 'package:gritstone/services/location_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
      ));

  service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter<LocationBattery>(LocationBatteryAdapter());

  await Hive.openBox<LocationBattery>('locationDataBox');

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 2), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        //function call

        var position = await getLocation();
        var batteryLevel =
            (await BatteryInfoPlugin().androidBatteryInfo)!.batteryLevel;

        var locationBattery = LocationBattery(
            latitude: position.latitude,
            longitude: position.longitude,
            batteryLevel: batteryLevel ?? 0);

        var box = Hive.box<LocationBattery>('locationDataBox');
        await box.clear();
        await box.add(locationBattery);
      }
    }
  });
}
