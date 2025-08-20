import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:yourbreak/models/timer_structure.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

// --------------------------------------------------------
// hasRunBefore functions

/// Sets the SharedPreferences' hasRunBefore to the passed state.
/// Takes in a required state (bool, true or false) that will
/// be assigned to hasRunBefore.
void setHasRunBefore(bool state) async {
  await (await SharedPreferences.getInstance()).setBool('hasRunBefore', state);
}

/// Returns the value of hasRunBefore, bool.
/// If there isn't a hasRunBefore, it will return false as default.
Future<bool> getHasRunBefore() async {
  return (await SharedPreferences.getInstance()).getBool("hasRunBefore") ?? false;
}

// --------------------------------------------------------
// Init function for main.dart

/// Initializes Hive, everything related to hive Timers,
/// also sets hasRunBefore to false, and if it's the app's
/// first launch, also initializes defaults, presets and sets hasRunBefore.
void initializeHive() async {

  await Hive.initFlutter();

  _registerTimerAdapters();

  _openTimerBoxes();

  // Insert presets only on the first launch of the application.
  // If already hasRunBefore, then return, because functions after this are
  // only meant to run on the first launch.
  if (await getHasRunBefore()) return;

  //----------------------------
  // First launch only functions.

  await _insertPresetTimers();

  setHasRunBefore(false); // TODO: TEMPORARY! Change to true before release!

}

// --------------------------------------------------------
// Sub-functions, meant to be only used within initHive().

// Timer section. (functions related to Timers, e.g: open timer boxes, insert timer presets, etc.)

/// Registers all Timer types adapters. (Inside models/timer_structure.dart)
void _registerTimerAdapters() {
  Hive.registerAdapter(ComplexityAdapter());
  Hive.registerAdapter(PeriodTypeAdapter());
  Hive.registerAdapter(TimerPeriodAdapter());
  Hive.registerAdapter(TimerStructureAdapter());
}

/// Opens all timer boxes to allow other files to access their contents.
void _openTimerBoxes() async {
  await Hive.openBox<TimerStructure>('user_timers');
  await Hive.openBox<TimerStructure>('preset_timers');
}

/// Inserts preset timers as found in 'assets/presets.json'.
/// Inserts them only into the 'preset_timers' box.
Future<void> _insertPresetTimers() async {

  final Box<TimerStructure> presetsBox = Hive.box<TimerStructure>('preset_timers');

  final List<dynamic> presetsList = jsonDecode(await rootBundle.loadString('assets/presets.json'));

  for (final preset in presetsList) {

    final pattern = (preset['pattern'] as List<dynamic>).map((item) {
      return TimerPeriod(
        periodTime: item['periodTime'] as int,
        periodType: PeriodType.values.firstWhere((e) => e.name == item['periodType'])
      );
    }).toList();

    final structure = TimerStructure(
      name: preset['name'],
      complexity: Complexity.values.firstWhere((e) => e.name == preset['complexity']),
      pattern: pattern,
    );

    await presetsBox.put(structure.name.toLowerCase(), structure);

  }

}