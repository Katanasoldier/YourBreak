import 'package:flutter/material.dart';

import 'package:yourbreak/helper/initializers/hive/hive_initializer.dart';
import 'package:yourbreak/helper/initializers/window_initializer.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // --------------------
  // Custom initializers.

  await initializeHive();

  initializeWindow();

  // --------------------

  runApp(yourbreakApp());

}