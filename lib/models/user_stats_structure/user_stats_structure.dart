import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'user_stats_structure.g.dart';

/// Structure of basic user stats.
/// Stores:
/// - loginStreak : double
/// - workPeriodStreak : double
/// - totalProductiveTime : double
@HiveType(typeId: 0)
class UserStatsStructure extends HiveObject {

  /// Counts how many days in a row the user logged in.
  @HiveField(0)
  double loginStreak;

  /// How many times in a row the user completed a full work period,
  /// in 1 continuous running timer 
  @HiveField(1)
  double workPeriodStreak;

  /// Total time spent in work periods.
  /// This means that if a user runs a timer
  /// on a work period for 5 minutes, this increases
  /// by 5 minutes. ShortBreak (Break) and LongBreak (Rest) don't count.
  @HiveField(2)
  int totalProductiveTime;


  UserStatsStructure({
    required this.loginStreak,
    required this.workPeriodStreak,
    required this.totalProductiveTime
  });

}