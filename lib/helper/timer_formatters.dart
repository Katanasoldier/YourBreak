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

/// Formats time given in seconds into a colon format.
/// Takes in an integer representing seconds and returns a string of the format:
/// x:y:zs where:
/// x - Hours, y - Minutes, z - Seconds.
/// Note: If x is 0, it won't show x as 0, but just skip to y and z.
String formatSeconds(int totalSeconds) {

  final int hours = totalSeconds ~/ 3600;
  final int minutes = (totalSeconds % 3600) ~/ 60;
  final int seconds = totalSeconds % 60;

  String formattedString;

  
  if (hours > 0) {
    formattedString = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  } else if (minutes > 0) {
    formattedString = '$minutes:${seconds.toString().padLeft(2, '0')}';
  } else {
    formattedString = seconds.toString();
  }

  // Add a 's' suffix to indicate that the time is shown in seconds.
  formattedString += 's';


  return formattedString;
}