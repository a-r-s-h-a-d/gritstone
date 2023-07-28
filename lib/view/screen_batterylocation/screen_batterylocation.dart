import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:gritstone/controller/locationbattery_controller.dart';
import 'package:gritstone/services/location_service.dart';
import 'package:gritstone/utils/styles/textstyles.dart';
import 'package:provider/provider.dart';

class ScreenBatteryLocation extends StatelessWidget {
  const ScreenBatteryLocation({super.key});

  @override
  Widget build(BuildContext context) {
    Position? position;
    int? batteryLevel;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller =
          Provider.of<LocationBatteryController>(context, listen: false);
      controller.getStoredLocationData();
      controller.updateLocationData();
      position = await getLocation();
      batteryLevel =
          (await BatteryInfoPlugin().androidBatteryInfo)!.batteryLevel;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location & Battery'),
      ),
      body: Consumer<LocationBatteryController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.battery_full_outlined,
                    size: 30,
                  ),
                  Center(
                    child: Text(
                      batteryLevel.toString(),
                      style: ktextstyle18xBold,
                    ),
                  ),
                  const Icon(
                    Icons.location_on,
                    size: 60,
                  ),
                  Text(
                    'latitude:${position?.latitude.toString() ?? " "}\nlongitude : ${position?.longitude.toString() ?? " "}',
                    style: ktextstyle14xw600,
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.battery_full_outlined,
                    size: 30,
                  ),
                  Center(
                    child: Text(
                      controller.locationBatteryList.first.batteryLevel
                          .toString(),
                      style: ktextstyle18xBold,
                    ),
                  ),
                  const Icon(
                    Icons.location_on,
                    size: 60,
                  ),
                  Text(
                    controller.locationName,
                    style: ktextstyle18xBold,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
