import 'package:hive/hive.dart';
import 'package:yourbreak/helper/initializers/hive/model_inits/model_init.dart';
import 'package:yourbreak/models/user_stats_structure/user_stats_structure.dart';

/// !!! TO BE USED ONLY INSIDE `hive_initializer` !!!
/// Meant to initialize the `UserStatsStructure` model.
class UserStatsStructureInit implements ModelInit {

  /// Runs all initialization based functions.
  /// Registers the adapter and opens `user_stats` box.
  @override
  Future<void> init() async {
    
    _registerAdapter();

    _openBox();

  }

  // --------------------------------------------------------------------------------

  /// Registers `UserStatsStructureAdapter`
  void _registerAdapter() => Hive.registerAdapter(UserStatsStructureAdapter());

  /// Opens `user_stats` box to allow other files to access it's content.
  void _openBox() async {
    await Hive.openBox<UserStatsStructure>('user_stats');
  }

}