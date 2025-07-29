import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';

// A collection of functions specialized for all widgets
// using data from a Timer (TimerStructure)


/// Formats the passed period name to a more user-friendly format.
/// For example:
/// - "work" becomes "Work"
/// - "shortBreak" becomes "Break"
/// - "longBreak" becomes "Rest"
String formatPeriodName(String periodName){
  switch(periodName){
    case 'work':
      return 'Work';
    case 'shortBreak':
      return 'Break';
    case 'longBreak':
      return 'Rest';
    default:
      return periodName;
  }
}

/// Capitalizes the first letter of the passed string and returns it.
String capitalize(String string){
  return string[0].toUpperCase() + string.substring(1);
}

/// Returns the color associated with the passed period name.
Color getPeriodColor(String periodName){
  switch(periodName){
    case 'work':
      return PureColors.orange;
    case 'shortBreak':
      return PureColors.green;
    case 'longBreak':
      return PureColors.blue;
    default:
      return PureColors.white;
  }
}

/// Formats time given in seconds into a easy to read format.
/// Takes in an integer representing seconds and returns a string of the format:
/// - "Xm Ys" if the time is more than 60 seconds, where X is the number of minutes and Y is the number of seconds.
/// - "Xs" if the time is less than 60 seconds, where X is the number of seconds.
String formatSeconds(int seconds) {

  if (seconds >= 60) {

    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    return remainingSeconds == 0
      ? '${minutes}m'
      : '${minutes}m ${remainingSeconds}s';
  }

  return '${seconds}s';

}