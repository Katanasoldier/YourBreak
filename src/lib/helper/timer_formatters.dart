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

/// Returns the color associated with the passed period type name.
Color getPeriodColor(String periodTypeName){
  switch(periodTypeName){
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
/// xh ym zs where:
/// x - Hours, y - Minutes, z - Seconds.
String formatSeconds(int seconds) {

  String formattedString = "";

  // Hours
  if (seconds >= 3600) {
    formattedString += '${seconds ~/ 3600}h ';
    seconds %= 3600;
  }

  // Minutes
  if (seconds >= 60) {
    formattedString += '${seconds ~/ 60}m ';
    seconds %= 60;
  }

  // Seconds
  if (seconds != 0) {
    formattedString += '${seconds}s';
  }

  // Trimming prevents any whitespace from taking unnecessary space
  // and causing the text to shrink or overflow.
  return formattedString.trimRight();

}