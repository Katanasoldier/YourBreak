import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:yourbreak/models/timer_structure.dart';

import 'package:yourbreak/templates/timer_picker_components/timer_picker_column_buttons/timer_picker_column_button.dart';


/// Compares the passed timerName in a switch, 
/// and returns the case.
/// Contains text color gradients for differently named timers,
/// to easily distuingish them.
/// For example, Pomodoro has a orangey red gradient.
/// If the name isn't in the switch, it will return by default PureColors.white
List<Color> getTimerTitleGradient(String timerName) {
  switch(timerName) {
    case "Pomodoro":
      return [
        Color(0xFFFF3131),
        Color(0xFFFF7441)
      ];
    case "20-20-20":
      return [
        Color(0xFF7091FF),
        Color(0xFF6CE9FF)
      ];
    default:
      return [
        PureColors.white,
        PureColors.white
      ];
  }
}

/// A simple header to be used within TimerPickerColumn.
/// Mainly made to reduce boilerplate within TimerPickerColumn, because for both
/// the top header and the 'Empty' header the same widget is used.
/// Takes in a:
/// - fontSize : double
/// - headerText : String
/// - color : Color?
class Header extends StatelessWidget {

  final double fontSize; 
  final String headerText;
  final Color? color;

  const Header({

    super.key,

    required this.fontSize,

    required this.headerText,

    this.color,

  });

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? PureColors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

/// Displays all available timers inside the selected box (user, preset) inside a column.
/// Takes in a:
/// - fontSize : double
/// - headerText : String
/// - timerType : String, 'user' or 'preset', this is the aforementioned Box, and they're
/// called a box because timers are stored within a Hive Box.
/// - timerButtonOnPressed : Function, allows defining custom click behaviour for 
/// each timer button (TimerPickerColumnButton)
/// - editButtons : bool?, decides whether to allow the player to edit or delete each timer.
class TimerPickerColumn extends StatelessWidget {

  final double fontSize; 
  final String headerText;
  final String timerType;
  final Function timerButtonOnPressed;
  final bool? editButtons;

  const TimerPickerColumn({

    super.key,

    required this.fontSize,

    required this.headerText,

    required this.timerType,

    required this.timerButtonOnPressed,

    this.editButtons,

  });

  @override
  Widget build(BuildContext context) {
    // The value listenable builder listens to any changes inside the selected Box (timerType HiveBox)
    // This is so, that if a user deletes a timer, he'll see the changes immediately, and
    // when the user deletes the last timer in the box, then the 'Empty' header will be visible again.
    return ValueListenableBuilder(
      valueListenable: Hive.box<TimerStructure>('${timerType}_timers').listenable(),
      builder: (_, Box<TimerStructure> box, _) {
        return box.values.isEmpty
          ? Stack( // If no timers, show 'Empty' in the center.
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Header(fontSize: fontSize, headerText: headerText)
              ),
              Center(
                child: Header(fontSize: fontSize, headerText: "Empty", color: PureColors.grey.withValues(alpha: 0.2))
              )
            ],
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Header(fontSize: fontSize, headerText: headerText),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {

                    final double maxListViewWidth = constraints.maxWidth;
                    final double maxListViewHeight = constraints.maxHeight;

                    final double listElementHeight = maxListViewHeight * 0.175;
                    final double listElementWidth = maxListViewWidth * 0.95;
                    
                    
                    final scrollController = ScrollController();

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: RawScrollbar(
                            thickness: 5,
                            interactive: true,
                            minOverscrollLength: 5,
                            thumbColor: PureColors.white,
                            radius: Radius.circular(4),
                            thumbVisibility: true,
                            controller: scrollController,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              physics: ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  for (final timer in box.values)
                                  TimerPickerColumnButton(
                                    key: ValueKey(timer.key),
                                    timer: timer,
                                    mainTextGradient: getTimerTitleGradient(timer.name),
                                    onPressed: timerButtonOnPressed,
                                    listElementHeight: listElementHeight,
                                    listElementWidth: listElementWidth,
                                    editButtons: editButtons,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                )
              )
            ],
          );
      }
    );
  } 
}