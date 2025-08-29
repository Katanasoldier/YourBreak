import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'timer_structure.g.dart';


// Quick explanation of the structure:
// Each timer has a structure of TimerStructure
// A TimerStructure has the following fields:
// 1. name - String
// 2. complexity - a value of the Complexity enum (simple or complex)
// 3. pattern - a list of `Period`s
// And a 'totalTime' getter, that sums the 'periodTime' of each 'Period' inside the timer's 'Pattern'
//
// Period - a time block that is supposed to be executed when running.
// A timer's pattern isn't limited to a set amount of `Period`s
// Each Period consists of:
// 1. periodTime - int (stored as seconds)
// 2. periodType - a value of the PeriodType enum (work, shortBreak, longBreak)


/// Describes the complexity of the timer via 2 fields:
/// - simple
/// - complex
@HiveType(typeId: 0)
enum Complexity {
  @HiveField(0)
  simple,

  @HiveField(1)
  complex
}


/// Describes the type of a period via:
/// - work
/// - shortBreak (break)
/// - longBreak (rest)
@HiveType(typeId: 1)
enum PeriodType {
  @HiveField(0)
  work,
  
  @HiveField(1)
  shortBreak, // or Break, when shown in the app.

  @HiveField(2)
  longBreak // or Rest, when shown in the app.
}


/// Describes the structure of a period via:
/// - periodTime : int (stored as seconds)
/// - periodType : a value of the PeriodType enum
@HiveType(typeId: 2)
class TimerPeriod {

  // Meant to symbolise seconds.
  @HiveField(0)
  int periodTime;

  @HiveField(1)
  PeriodType periodType;

  TimerPeriod({
    required this.periodTime,
    required this.periodType
  });

}


/// Structure of each timer.
/// Contains the following fields:
/// - name : String
/// - complexity : value of the Complexity enum
/// - pattern : list of Periods
/// And a getter 'totalTime' that returns the sum of each Period's periodType that is inside Pattern.
@HiveType(typeId: 3)
class TimerStructure extends HiveObject {

  /// Stores the name of the timer.
  @HiveField(0)
  String name;

  /// Stores the value of the Complexity enum.
  @HiveField(1)
  Complexity complexity;

  /// Stores Periods in a list.
  @HiveField(2)
  List<TimerPeriod> pattern;

  TimerStructure({
    required this.name,
    required this.complexity,
    required this.pattern,
  });

  /// Allows easy access to the total time of each Period's periodTime summed together.
  int get totalTime => pattern.fold(0, (sum, item) => sum + item.periodTime);

}