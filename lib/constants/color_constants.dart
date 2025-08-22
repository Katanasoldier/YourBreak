import 'package:flutter/material.dart';

/// Contains standardized colors to be used throughout the app.
class PureColors {
  static const Color white = Color(0xFFEEEEEE);
  static const Color grey = Color(0x80EEEEEE);
  static const Color darkGrey = Color(0xFF444444);
  static const Color red = Color(0xFFEE5F5F);
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

  /// Color of the frame holding the control buttons.
  static Color holdingFrame = PureColors.blue.withValues(alpha: 0.1);

  static const Color closeBackground = Color(0xFFE81123);
  
  static const Color minimizeBackground = PureColors.grey;

}

class PopUpColors {

  static Color appWideBlur = PureColors.darkGrey.withValues(alpha: 0.05);

  static Color background = PureColors.white.withValues(alpha: 0.1);
  static Color frame = PureColors.white.withValues(alpha: 0.5);

}

/// Returns the gradient for the background of the whole app.
List<Color> backgroundGradient() {
  return const [
    Color(0xFF0B0822),
    Color(0xFF091E31),
  ];
}