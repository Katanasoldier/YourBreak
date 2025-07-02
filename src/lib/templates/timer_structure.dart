import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'timer_structure.g.dart';

@HiveType(typeId: 0)
enum Complexity {
  @HiveField(0)
  simple,

  @HiveField(1)
  complex
}


@HiveType(typeId: 1)
enum PeriodType {
  @HiveField(0)
  work,
  
  @HiveField(1)
  shortBreak,

  @HiveField(2)
  longBreak
}


@HiveType(typeId: 2)
class TimerPeriod {
  @HiveField(0)
  int periodTime;

  @HiveField(1)
  PeriodType periodType;

  /*@HiveField(2)
  String periodType;*/ //For a future update

  TimerPeriod({
    required this.periodTime,
    required this.periodType
  });
}


@HiveType(typeId: 3)
class TimerStructure extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  Complexity complexity;

  @HiveField(2)
  List<TimerPeriod> pattern;

  TimerStructure({
    required this.name,
    required this.complexity,
    required this.pattern,
  });

  int get totalTime => pattern.fold(0, (sum, item) => sum + item.periodTime);
}