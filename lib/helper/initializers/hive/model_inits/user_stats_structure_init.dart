import 'package:hive/hive.dart';
import 'package:yourbreak/helper/initializers/hive/model_inits/model_init.dart';
import 'package:yourbreak/models/user_stats_structure/user_stats_structure.dart';

/// !!! TO BE USED ONLY INSIDE `hive_initializer` !!!
/// Meant to initialize the `UserStatsStructure` model.
class UserStatsStructureInit implements ModelInit {

  /// Runs all initialization based functions.
  /// Registers the adapter and opens `user_stats` box.
  /// Checks for `default_user` entry inside `user_stats`, and if
  /// it's found, then it calls `extendLoginStreak()` on it,
  /// else it calls `_putDefaultUser`.
  @override
  Future<void> init() async {

    _registerAdapter();

    await _openBox();

    final UserStatsStructure? defaultUser = Hive.box<UserStatsStructure>("user_stats").get("default_user");

    if (defaultUser != null) {
      defaultUser.extendLoginStreak();
    } else {
      _putDefaultUser();
    }

  }

  // --------------------------------------------------------------------------------

  /// Registers `UserStatsStructureAdapter`
  void _registerAdapter() async => Hive.registerAdapter(UserStatsStructureAdapter());

  /// Opens `user_stats` box to allow other files to access it's content.
  Future<void> _openBox() async => await Hive.openBox<UserStatsStructure>('user_stats');

  /// Puts a default entry into the `user_stats` box called `default_user`.
  /// Sets the `loginStreak` to 1,
  /// Sets the `lastStreakDate` to Date.now,
  /// so when later `extendLoginStreak()` is called,
  /// it can actually extend it.
  void _putDefaultUser() {
    Hive.box<UserStatsStructure>("user_stats").put(
      "default_user",
      UserStatsStructure(
        loginStreak: 1,
        lastStreakDate: DateTime.now(),
        workPeriodStreak: 0,
        totalProductiveTime: 0
      )
    );
  }

}