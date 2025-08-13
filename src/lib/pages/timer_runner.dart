import 'package:flutter/material.dart';
import 'package:yourbreak/constants/font_size_constants.dart';
import 'package:yourbreak/models/timer_structure.dart';
import 'package:yourbreak/templates/base_mixins/page_animation_controller_mixin.dart';
import 'package:yourbreak/templates/base_visuals.dart';
import 'package:yourbreak/templates/circular_timer.dart';



class TimerRunner extends StatefulWidget {

  final TimerStructure timer;

  const TimerRunner({
    super.key,

    required this.timer
  });

  @override
  TimerRunnerState createState() => TimerRunnerState();

}


class TimerRunnerState extends State<TimerRunner> with TickerProviderStateMixin, PageAnimationControllerMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.5, vertical: 2),
              child: Stack( // Main center column
                children: [
                  FittedBox(
                    child: PageHeader(
                      fontSize: FontSizes.pageHeader,
                      text: "Pomodoro : Placeholder",
                      pageAnimationController: functionalPageAnimationController,
                      margin: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 275,
                      height: 275,
                      margin: EdgeInsets.symmetric(vertical: 25),
                      child: CircularTimer(
                        timer: widget.timer,
                        size: 275
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.5),
                      height: 80,
                      child: Column(
                        children: [
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          TopBar()
        ]
      )
    );
  }

}