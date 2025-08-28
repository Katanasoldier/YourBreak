import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:yourbreak/helper/initializers/hive/model_inits/model_init.dart';
import 'package:yourbreak/helper/initializers/hive/onboarding_prefs.dart';
import 'package:yourbreak/models/timer_structure/timer_structure.dart';

/// !!! TO BE USED ONLY INSIDE `hive_initializer` !!!
/// Meant to initialize the `TimerStructure` model.
class TimerStructureInit implements ModelInit {

  /// Runs all initialization based functions.
  /// Registers adapters, opens boxes, and if possible
  /// inserts preset timers from preset.json.
  @override
  Future<void> init() async {

    _registerAdapters();

    _openBoxes();

    // Insert presets only on the first launch of the application.
    // If already hasRunBefore, then return, because functions after this are
    // only meant to run on the first launch.
    if (await getHasRunBefore()) return;

    //----------------------------
    // First launch only functions.

    _insertPresetTimers();

  }

  // --------------------------------------------------------------------------------

  /// Registers all Timer types adapters.
  void _registerAdapters() {
    Hive.registerAdapter(ComplexityAdapter());
    Hive.registerAdapter(PeriodTypeAdapter());
    Hive.registerAdapter(TimerPeriodAdapter());
    Hive.registerAdapter(TimerStructureAdapter());
  }

  /// Opens all timer boxes to allow other files to access their contents.
  void _openBoxes() async {
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

}