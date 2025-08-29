// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_structure.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatsStructureAdapter extends TypeAdapter<UserStatsStructure> {
  @override
  final int typeId = 0;

  @override
  UserStatsStructure read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStatsStructure(
      loginStreak: fields[0] as double,
      lastStreakDate: fields[1] as DateTime,
      workPeriodStreak: fields[2] as double,
      totalProductiveTime: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserStatsStructure obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.loginStreak)
      ..writeByte(1)
      ..write(obj.lastStreakDate)
      ..writeByte(2)
      ..write(obj.workPeriodStreak)
      ..writeByte(3)
      ..write(obj.totalProductiveTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatsStructureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
