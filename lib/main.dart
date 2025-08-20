import 'package:flutter/material.dart';

import 'package:yourbreak/helper/initializers/hive_initializer.dart';
import 'package:yourbreak/helper/initializers/window_initializer.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  // --------------------
  // Custom initializers.

  initializeHive();

  initializeWindow();

  // --------------------

  runApp(yourbreakApp());

}