import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';

import 'package:yourbreak/models/timer_structure/timer_structure.dart';


/// Widget that allows the user to input a custom time into:
/// - hours
/// - minutes
/// - seconds
/// 
/// Can take in an optional preexisting Period, for example could be used when editing an
/// existing timer, to build off of a ready Period.
/// 
/// Designed to only be used within the PeriodTime popup found in TimerCreator.
/// Contains a reset() function that should be called when the popup containing
/// this widget has been refreshed or rebuilt.
class TimerTimeChooser extends StatefulWidget {

  final TimerPeriod? preexistingPeriod;

  const TimerTimeChooser({
    super.key,

    this.preexistingPeriod
  });

  @override
  TimerTimeChooserState createState() => TimerTimeChooserState();

}


class TimerTimeChooserState extends State<TimerTimeChooser> with TickerProviderStateMixin {

  /// We use a List to represent the time, to more easily handle number overflow,
  /// that means when a user inputs 71 seconds, it will automatically format
  /// it to 1 minute and 11 seconds.
  /// And a list allows us to traverse it by indexes of numbers,
  /// so it's easier to for example check if there is a smaller index available,
  /// to handle said overflow, without creating more functions.

  /// It works in this way:
  /// If there is a smaller (smallest is hour) time type (widget.timeType - 1 >= 0, since 0 is
  /// the starting index of the list), then increase that by one, remove 60 from the parsedValue
  /// and assign parsedValue to your widget.timeType.

  /// [0] represents hours, [1] minutes and [2] seconds.
  ValueNotifier<List<int>> timeStructure = ValueNotifier([
    0, /// Hours
    0, /// Minutes
    0 /// Seconds
  ]);

  // -------------------------------------------------------------------------------
  // Functions section.

  /// Sets the [timeStructure] indexes appropriately with the passed
  /// [preexistingPeriod]'s periodTime property.
  void setPresetTimeStructure(TimerPeriod preexistingPeriod) {

    final copyStructure = [...timeStructure.value];

    // ---------------------------------

    int totalTime = preexistingPeriod.periodTime;

    // Hours
    copyStructure[0] = totalTime ~/ 3600;

    int remainder = totalTime % 3600;

    // Minutes
    copyStructure[1] = remainder ~/60;

    // Seconds
    copyStructure[2] = remainder % 60;
    
    // ---------------------------------

    timeStructure.value = copyStructure;

  }


  /// Calculates each of the [timeStructure]'s indexes and returns
  /// the totalTime as an int.
  int getTotalTime() {

    int totalTime = 0;

    // Hours
    totalTime += timeStructure.value[0] * 3600;

    // Minutes
    totalTime += timeStructure.value[1] * 60;

    // Seconds
    totalTime += timeStructure.value[2];


    return totalTime;

  }

  //-----------------------------------------------------------
  // Reset function.

  void reset() {
    setState(() {
      timeStructure.value = [...List.filled(3, 0)];
    });
  }

  // -------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    
    if (widget.preexistingPeriod != null) setPresetTimeStructure(widget.preexistingPeriod!);
  }

  // build.

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      height: 37.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: PureColors.white.withValues(alpha: 0.75),
          width: 2
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimeTextGroup(timeType: 0, timeStructure: timeStructure),
            timeDivider(),
            TimeTextGroup(timeType: 1, timeStructure: timeStructure),
            timeDivider(),
            TimeTextGroup(timeType: 2, timeStructure: timeStructure)
          ]
        ),
      )
    );
  }

  /// Divider to be used between TimeTextGroups.
  Widget timeDivider() {
    return Container(
      width: 2,
      height: 25,
      color: PureColors.white.withValues(alpha: 0.5),
      margin: EdgeInsets.symmetric(horizontal: 5),
    );
  }

}


/// Displays the time and the time's unit together.
/// Must pass:
/// - timeType
/// - timeStructure
/// 
/// The time is provided by the timeStructure, and this widget
/// contains the necessary functions to extract and process it.
/// 
/// It also automatically updates the timeStructure with any new valid
/// value the user inputs into the textfield. When timeStructure is updated it
/// also updates any other TimeTextGroup's with the same timeStructure object.
/// This is so that if the user inputs an overflowing number (above 59), then if there
/// is a bigger time unit, then it will increase that by 1 and leave the change in this.
/// 
/// Example:
/// If a user inputs 71 into seconds, then minutes will increase by 1,
/// and seconds will remain with 11, since 71 - 60 = 11.
class TimeTextGroup extends StatefulWidget {

  final int timeType;
  final ValueNotifier<List<int>> timeStructure;

  const TimeTextGroup({
    super.key,
    
    required this.timeType,
    required this.timeStructure
  });

  @override
  TimeTextGroupState createState() => TimeTextGroupState();

}

class TimeTextGroupState extends State<TimeTextGroup> with SingleTickerProviderStateMixin {

  // Text section.

    late final String timeUnitSymbol = switch (widget.timeType) {
      0 => "h", // Hours,
      1 => "m", // Minutes,
      2 => "s", // Seconds,
      _ => "n/a" // Not Available, most likely an error.
    };

    // Text style subsection.

      // To prevent boilerplate for both the textfield text and time unit text.
      final TextStyle commonStyle = TextStyle(
        fontSize: 17,
        color: PureColors.white,
        fontWeight: FontWeight.w700,
      );

  //-----------------------------------------------------------

    final TextEditingController _textEditingController = TextEditingController();

    String previousValue = "";

    bool isText = false;

    /// Runs every time the passed timeStructure's value is changed.
    /// Reads the value from the proper timeType, provided in widget.timeType,
    /// if the value is smaller than 10, it adds a 0 at the start to keep 2 digits
    /// at all times, if the value is a double digit, then it just passes it directly
    /// to the text property of the text controller.
    void _timeStructureValueChanged() {
      final String time = widget.timeStructure.value[widget.timeType].toString();
      setState(() {
        _textEditingController.text = widget.timeStructure.value[widget.timeType] < 10
          ? '0$time'
          : time;
      });
    }


    /// Runs each time the text inside the text controller is changed.
    /// 
    /// It automatically trims whitespace to prevent bugs, only accepts
    /// number characters (checks via regex) and locks the max character count at 2, 
    /// blocking any further attempts by reverting to the last valid value.
    void _textChanged() {
      setState(() {
        // To remove any whitespace to avoid any bugs later on.
        _textEditingController.text.trim();

        isText = _textEditingController.text.isNotEmpty;

        if (isText) {

          final int textLength = _textEditingController.text.length;

          if (textLength > 2) {
            
            // If the user tries to input more than 2 characters, 
            // overwrite the new one by reverting to the last valid value.
            _textEditingController.text = previousValue;

          } else if (textLength < 2 || _textEditingController.text != previousValue) {
            
            // Checks if the characters are only numbers, if not, it reverts the text
            // to the previous valid value.
            if (RegExp(r'^[0-9]+$').hasMatch(_textEditingController.text)) {
              previousValue = _textEditingController.text;
            } else {
              _textEditingController.text = previousValue;
            }

          }
        }
      });
    }

  // Node subsection.

    final FocusNode textFocusNode = FocusNode();

    bool isFocused = false;

    /// Tracks the focus of the textfield
    /// If focus is lost, it checks whether the textfield isn't empty.
    /// If it is, it updates the textfield to the previous valid value,
    /// else it calls [updateTimeStructure].
    void _focusChanged() {
      setState(() {
        isFocused = textFocusNode.hasFocus;

        if (!isFocused) {
          
          // If the user leaves an empty string, revert back to the last valid value.
          if (!isText) _textEditingController.text = previousValue;

          updateTimeStructure(_textEditingController.text);

        } else {
          // So the user doesn't have to manually delete the value with their keyboard to enter a new one.
          _textEditingController.text = "";
        }

      });
    }


  //-----------------------------------------------------------
  // Time value formatting function.

  /// Updates the time structure.
  /// Formats the value from the textfield by parsing it to an int,
  /// and checking whether it's above 59, if it is, it also increments the
  /// smaller timeType too (smaller = bigger, [0] = hours, [1] = minutes, [2] = seconds),
  /// in the end updating the timerStructure by changing it's value so it fires
  /// all listeners attached to it.
  void updateTimeStructure(String value) {

    // Required or else the notifier won't fire the listeners.
    final copyStructure = [...widget.timeStructure.value];


    int? parsedValue = int.tryParse(value);


    if (parsedValue != null) {
      if (parsedValue < 60) {
        copyStructure[widget.timeType] = parsedValue;
      } else {
        if (widget.timeType - 1 >= 0) {
          copyStructure[widget.timeType - 1]++;
          parsedValue -= 60;
        }
        copyStructure[widget.timeType] = parsedValue;
      }
    }

    widget.timeStructure.value = copyStructure;

  }

  //-----------------------------------------------------------
  // States section.

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(_textChanged);

    textFocusNode.addListener(_focusChanged);
    

    widget.timeStructure.addListener(_timeStructureValueChanged);

    // To trigger the listeners, so the text is filled with the accurate value.
    widget.timeStructure.value = [...widget.timeStructure.value];
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_textChanged);
    _textEditingController.dispose();

    textFocusNode.removeListener(_focusChanged);
    textFocusNode.dispose();

    widget.timeStructure.removeListener(_timeStructureValueChanged);

    super.dispose();
  }

  //-----------------------------------------------------------
  // build.

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            child: Theme(
              // Overrides the default TextFormField cursor and selection
              // colors to match the application's theme.
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: PureColors.white.withValues(alpha: 0.5),
                  selectionColor: PureColors.blue.withValues(alpha: 0.5)
                ),
              ),
              child: TextFormField(
                controller: _textEditingController,
                focusNode: textFocusNode,
            
                decoration: InputDecoration(
                  // Removes the underline that appears under the text.
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    )
                  ),
                  // Removes the underline that appears when the text field is focused.
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    )
                  ),
                  // Removes the padding allowing the text to be centered vertically.
                  contentPadding: EdgeInsets.all(0),
                  isCollapsed: true
              
                ),
                // User text style.
                style: commonStyle
              ),
            ),
          ),
          Stack( // Required or else .translate won't work.
            children: [
              Transform.translate( // So the time unit can be closer to the actual digits.
                offset: Offset(-2, 0),
                child: Text( // Time unit.
                  timeUnitSymbol,
                  style: commonStyle,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}