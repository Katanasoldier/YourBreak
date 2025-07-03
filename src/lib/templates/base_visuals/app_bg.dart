import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';

/// The background widget used throughout the whole application.

class AppBg extends StatelessWidget {
  
  const AppBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: backgroundGradient(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

}