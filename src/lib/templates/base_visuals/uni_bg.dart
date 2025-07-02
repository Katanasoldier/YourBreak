import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';

class UniBg extends StatelessWidget {
  
  const UniBg({super.key});

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