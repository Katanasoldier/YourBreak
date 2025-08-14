import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';
import 'package:yourbreak/models/timer_structure.dart';
import 'package:yourbreak/templates/base_mixins/page_animation_controller_mixin.dart';
import 'package:yourbreak/templates/base_visuals.dart';
import 'package:yourbreak/templates/buttons/return_button.dart';
import 'package:yourbreak/templates/timer_runner_components/circular_timer.dart';
import 'package:yourbreak/templates/timer_runner_components/timer_control_button.dart';



class TimerRunner extends StatefulWidget {

  final TimerStructure timer;

  const TimerRunner({
    super.key,

    required this.timer
  });

  @override
  TimerRunnerState createState() => TimerRunnerState();

}


class TimerRunnerState extends State<TimerRunner> with TickerProviderStateMixin, PageAnimationControllerMixin, PageAnimationControllerMixin {

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
                alignment: Alignment.topCenter,
                children: [
                  FittedBox(
                    child: PageHeader(
                      fontSize: FontSizes.pageHeader*0.6,
                      text: "Pomodoro : Placeholder",
                      pageAnimationController: functionalPageAnimationController,
                      margin: const EdgeInsets.only(top: 37.5, left: 20, right: 20),
                      fontColor: PureColors.white.withValues(alpha: 0.85),
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
                      margin: EdgeInsets.only(bottom: 7.5),
                      height: 87.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 35,
                            child: TimerControlButton(),
                          ),
                          SizedBox(
                            width: 150,
                            height: 35,
                            child: ReturnButton(
                              pageAnimationController: functionalPageAnimationController
                            ),
                          ),
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