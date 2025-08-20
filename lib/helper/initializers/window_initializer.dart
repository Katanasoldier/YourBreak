import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yourbreak/pages/home.dart';

/// The size of the window the app was designed for.
const designSize = Size(500, 500);

const WindowOptions yourbreakWindowOptions = WindowOptions(
  size: designSize,
  minimumSize: designSize,
  maximumSize: Size(1280, 720),
  center: true,
  backgroundColor: Colors.transparent,
  skipTaskbar: false,
  titleBarStyle: TitleBarStyle.hidden,
);

/// Initializes the app's window with [yourbreakWindowOptions].
/// Ensures the windowManager is initialized, then configures,
/// shows and focuses the window.
void initializeWindow() async {

  await windowManager.ensureInitialized();
  
  windowManager.waitUntilReadyToShow(yourbreakWindowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

}

/// Meant to be only used within main.dart's runApp() function.
/// Returns the app for runApp(), with MaterialApp as the base,
/// and the home page as the home parameter, and a custom Theme
/// where the font is Inria Sans.
Widget yourbreakApp() {
  return ScreenUtilInit(
    designSize: designSize,
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) => MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inria Sans'
      ),
      home: Home(),
    ),
  );
}