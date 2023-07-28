// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locationbattery.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationBatteryAdapter extends TypeAdapter<LocationBattery> {
  @override
  final int typeId = 1;

  @override
  LocationBattery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationBattery(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      batteryLevel: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocationBattery obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.batteryLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationBatteryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
