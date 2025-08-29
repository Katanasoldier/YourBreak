import 'package:hive_flutter/hive_flutter.dart';
import 'package:yourbreak/helper/initializers/hive/model_inits/model_init.dart';
import 'package:yourbreak/helper/initializers/hive/onboarding_prefs.dart';
import 'model_inits.dart';

/// Contains all files specialized in initializing
/// a specific model.
/// Allows `initializeHive` to easily iterate through
/// each file in a loop and in a typesafe way call each one's init().
final List<ModelInit> modelInitFiles = [
  TimerStructureInit(),
  UserStatsStructureInit()
];

// --------------------------------------------------------
// Init function for main.dart

/// Initializes Hive and all ModelInit files.
/// Sets hasRunBefore to true in the end.
Future<void> initializeHive() async {

  await Hive.initFlutter();

  for (final file in modelInitFiles) {
    await file.init();
  }

  setHasRunBefore(false); //TODO: Change to true before production!

}