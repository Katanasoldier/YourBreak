import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:yourbreak/models/timer_structure.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:yourbreak/pages/home.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Hive.initFlutter();
  Hive.registerAdapter(ComplexityAdapter());
  Hive.registerAdapter(PeriodTypeAdapter());
  Hive.registerAdapter(TimerPeriodAdapter());
  Hive.registerAdapter(TimerStructureAdapter());

  await Hive.openBox<TimerStructure>('user_timers');
  await Hive.openBox<TimerStructure>('preset_timers');

  await (await SharedPreferences.getInstance()).setBool('hasRunBefore', false); // TEMPORARY! REMOVE BEFORE PRODUCTION
  await checkAndInsertPresets();


  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(500, 500),
    minimumSize: Size(500, 500),
    maximumSize: Size(1280, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });


  runApp(
    ScreenUtilInit(
      designSize: Size(500, 500),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inria Sans'
        ),
        home: Home(),
      ),
    ),
  );
}


Future<void> checkAndInsertPresets() async {

  final prefs = await SharedPreferences.getInstance();

  final bool hasRunBefore = prefs.getBool('hasRunBefore') ?? false;
  if(!hasRunBefore){

    final presetsBox = Hive.box<TimerStructure>('preset_timers');

    final presetsJson = await rootBundle.loadString('assets/presets.json');
    final List<dynamic> presetsList = jsonDecode(presetsJson);
 
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

    await prefs.setBool('hasRunBefore', true);

  }
}