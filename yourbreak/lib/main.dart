import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  runApp(const MainApp());s
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
