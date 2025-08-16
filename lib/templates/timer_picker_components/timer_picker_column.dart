import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:yourbreak/models/timer_structure.dart';

import 'package:yourbreak/templates/buttons/timer_picker_column_buttons/timer_picker_column_button.dart';



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






class TimerPickerColumn extends StatefulWidget {

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
  TimerPickerColumnState createState() => TimerPickerColumnState();

}


class TimerPickerColumnState extends State<TimerPickerColumn> with TickerProviderStateMixin {


  int? hoveredIndex;


  late final AnimationController pageAnimationController =
  AnimationController(
    vsync: this,
    duration: AnimationDurations.pageTransition,
    reverseDuration: AnimationDurations.pageTransition
  );


  @override
  void dispose() {

    pageAnimationController.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<TimerStructure>('${widget.timerType}_timers').listenable(),
      builder: (_, Box<TimerStructure> box, _) {
        return box.values.isEmpty
          ? Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Header(fontSize: widget.fontSize, headerText: widget.headerText)
              ),
              Center(
                child: Header(fontSize: widget.fontSize, headerText: "Empty", color: PureColors.grey.withValues(alpha: 0.2))
              )
            ],
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Header(fontSize: widget.fontSize, headerText: widget.headerText),
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
                                  for (final timer in box.values.toList())
                                  TimerPickerColumnButton(
                                    timer: timer,
                                    mainTextGradient: getTimerTitleGradient(timer.name),
                                    onPressed: widget.timerButtonOnPressed,
                                    listElementHeight: listElementHeight,
                                    listElementWidth: listElementWidth,
                                    pageAnimationController: pageAnimationController,
                                    editButtons: widget.editButtons,
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