// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_structure.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerPeriodAdapter extends TypeAdapter<TimerPeriod> {
  @override
  final int typeId = 2;

  @override
  TimerPeriod read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerPeriod(
      periodTime: fields[0] as int,
      periodType: fields[1] as PeriodType,
    );
  }

  @override
  void write(BinaryWriter writer, TimerPeriod obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.periodTime)
      ..writeByte(1)
      ..write(obj.periodType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerPeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimerStructureAdapter extends TypeAdapter<TimerStructure> {
  @override
  final int typeId = 3;

  @override
  TimerStructure read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerStructure(
      name: fields[0] as String,
      complexity: fields[1] as Complexity,
      pattern: (fields[2] as List).cast<TimerPeriod>(),
    );
  }

  @override
  void write(BinaryWriter writer, TimerStructure obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.complexity)
      ..writeByte(2)
      ..write(obj.pattern);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerStructureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ComplexityAdapter extends TypeAdapter<Complexity> {
  @override
  final int typeId = 0;

  @override
  Complexity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Complexity.simple;
      case 1:
        return Complexity.complex;
      default:
        return Complexity.simple;
    }
  }

  @override
  void write(BinaryWriter writer, Complexity obj) {
    switch (obj) {
      case Complexity.simple:
        writer.writeByte(0);
        break;
      case Complexity.complex:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplexityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PeriodTypeAdapter extends TypeAdapter<PeriodType> {
  @override
  final int typeId = 1;

  @override
  PeriodType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PeriodType.work;
      case 1:
        return PeriodType.shortBreak;
      case 2:
        return PeriodType.longBreak;
      default:
        return PeriodType.work;
    }
  }

  @override
  void write(BinaryWriter writer, PeriodType obj) {
    switch (obj) {
      case PeriodType.work:
        writer.writeByte(0);
        break;
      case PeriodType.shortBreak:
        writer.writeByte(1);
        break;
      case PeriodType.longBreak:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
