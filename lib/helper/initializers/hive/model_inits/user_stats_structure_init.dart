import 'package:hive/hive.dart';
import 'package:yourbreak/helper/initializers/hive/model_inits/model_init.dart';
import 'package:yourbreak/helper/initializers/hive/onboarding_prefs.dart';
import 'package:yourbreak/models/user_stats_structure/user_stats_structure.dart';

/// !!! TO BE USED ONLY INSIDE `hive_initializer` !!!
/// Meant to initialize the `UserStatsStructure` model.
class UserStatsStructureInit implements ModelInit {

  /// Runs all initialization based functions.
  /// Registers the adapter and opens `user_stats` box.
  /// If the application is first ran, it also puts `default_user`
  /// in `user_stats`.
  /// In the end, on each app start, runs `extendLoginStreak()`.
  @override
  Future<void> init() async {
    
    _registerAdapter();

    _openBox();

    if (!await getHasRunBefore()) {
      _putDefaultUser();
    }
    
    Hive.box<UserStatsStructure>("user_stats").get("default_user")!.extendLoginStreak();

  }

  // --------------------------------------------------------------------------------

  /// Registers `UserStatsStructureAdapter`
  void _registerAdapter() => Hive.registerAdapter(UserStatsStructureAdapter());

  /// Opens `user_stats` box to allow other files to access it's content.
  void _openBox() async {
    await Hive.openBox<UserStatsStructure>('user_stats');
  }

  /// Puts a default entry into the `user_stats` box
  /// called `default_user`.
  /// Sets the `lastStreakDate` to the year 1900,
  /// so when later `extendLoginStreak()` is called,
  /// it can actually extend it.
  void _putDefaultUser() {
    Hive.box("user_stats").put(
      "default_user",
      UserStatsStructure(
        loginStreak: 0,
        lastStreakDate: DateTime(1900),
        workPeriodStreak: 0,
        totalProductiveTime: 0
      )
    );
  }

}