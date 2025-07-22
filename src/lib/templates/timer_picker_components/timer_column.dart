import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:yourbreak/models/timer_structure.dart';

import 'package:yourbreak/templates/timer_picker_components/column_button.dart';



List<TimerStructure> getTimers(String timerType) {

  final timersBox = Hive.box<TimerStructure>('${timerType}_timers');

  return timersBox.values.toList();

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






class TimerColumn extends StatefulWidget {

  final double fontSize; 
  final String headerText;
  final String timerType;
  final bool? editButtons;

  const TimerColumn({

    super.key,

    required this.fontSize,

    required this.headerText,

    required this.timerType,

    this.editButtons,

  });

  @override
  TimerColumnState createState() => TimerColumnState();

}


class TimerColumnState extends State<TimerColumn> with TickerProviderStateMixin {


  int? hoveredIndex;


  late final List<TimerStructure> timerList;


  late final AnimationController pageAnimationController =
  AnimationController(
    vsync: this,
    duration: AnimationDurations.pageTransition,
    reverseDuration: AnimationDurations.pageTransition
  );


  @override
  void initState() {

    super.initState();

    timerList = getTimers(widget.timerType);

  }


  @override
  void dispose() {

    pageAnimationController.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context) {
    return timerList.isEmpty
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
                        physics: BouncingScrollPhysics(),
                        //clipBehavior: Clip.none,
                        child: Column(
                          children: [
                            for (final timer in timerList)
                            ColumnButton(
                              timer: timer,
                              mainTextGradient: [
                                Color(0xFFFF3131),
                                Color(0xFFFF7441)
                              ],
                              onPressed: () {},
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
}