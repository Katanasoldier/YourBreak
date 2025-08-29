import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'user_stats_structure.g.dart';

/// Structure of basic user stats.
/// Stores:
/// - loginStreak : int
/// - lastStreakDate : DateTime
/// - workPeriodStreak : int
/// - totalProductiveTime : int
@HiveType(typeId: 4)
class UserStatsStructure extends HiveObject {

  /// Counts how many days in a row the user logged in.
  @HiveField(0)
  int loginStreak;

  /// Holds the DateTime when the streak was last extended.
  @HiveField(1)
  DateTime lastStreakDate;

  /// How many times in a row the user completed a full work period,
  /// in 1 continuous running timer 
  @HiveField(2)
  int workPeriodStreak;

  /// Total time spent in work periods.
  /// This means that if a user runs a timer
  /// on a work period for 5 minutes, this increases
  /// by 5 minutes. ShortBreak (Break) and LongBreak (Rest) don't count.
  @HiveField(3)
  int totalProductiveTime;


  UserStatsStructure({
    required this.loginStreak,
    required this.lastStreakDate,
    required this.workPeriodStreak,
    required this.totalProductiveTime
  });


  /// Measures how many days have passed since `lastStreakDate`, and
  /// if more than 1 day passed, reset the streak to 1, because if this ran
  /// that means the user logged on.
  /// If only 1 day passed, increment `loginStreak` by 1.
  /// 
  /// If 1 or more days have passed, set `lastStreakDate` to `DateTime.now()`.
  void extendLoginStreak() {

    final int difference = DateTime.now().difference(lastStreakDate).inDays;

    if (difference >= 1) {

      lastStreakDate = DateTime.now();
      
      if (difference == 1) {
        loginStreak++;
      } else {
        loginStreak = 1;
      }

    }

  }

}