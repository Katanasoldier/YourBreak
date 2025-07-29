import 'package:flutter/material.dart';

/// This file contains color constants used throughout the application.

class PureColors {
  static const Color white = Color(0xFFEEEEEE);
  static const Color red = Color(0xFFEE5F5F);
  static const Color grey = Color(0x80EEEEEE);
  static const Color blue = Color(0xFF7fa7ff);
  static const Color green = Color(0xFFaff0aa);
  static const Color orange = Color(0xFFffbb55);
}


class PageHeaderColors {

  static const Color headerText = PureColors.white;

}

class SquareButtonColors {

  static const Color mainText = PureColors.white;
  static const Color supportText = PureColors.white;

  static const Color description = PureColors.grey;

  static const Color background = Colors.transparent;

  static const Color border = PureColors.white;

}

class ReturnButtonColors {

  static const Color mainText = PureColors.red;

  static const Color background = Colors.transparent;

  static const Color border = PureColors.red;

}

class SaveButtonColors {

  static const Color mainText = PureColors.green;

  static const Color border = PureColors.green;

}

class ControlButtonColors {

  static const Color closeBackground = Color(0xFFE81123);
  
  static const Color minimizeBackground = PureColors.grey;

}

List<Color> backgroundGradient() {
  return const [
    Color(0xFF0B0822),
    Color(0xFF091E31),
  ];
}