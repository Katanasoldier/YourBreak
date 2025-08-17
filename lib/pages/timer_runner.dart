import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';

import 'package:yourbreak/models/timer_structure.dart';

import 'package:yourbreak/templates/mixins/page_animation_controller_mixin.dart';

import 'package:yourbreak/templates/page_components.dart';

import 'package:yourbreak/templates/generic_buttons/return_button.dart';
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

  AnimationController? timerAnimationController;

  final GlobalKey<TimerControlButtonState> _timerControlButtonKey = GlobalKey();

  // ------------------------------------------------------------

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
                      text: widget.timer.name,
                      pageAnimationController: functionalPageAnimationController,
                      margin: const EdgeInsets.only(top: 35, left: 20, right: 20),
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
                        size: 275,
                        onTimerControllerReady: (passedTimerAnimationController) {
                          setState(() {
                            timerAnimationController = passedTimerAnimationController;
                          });
                          // To prevent an issue where the new period starts and the button's action is pause,
                          // forcing the user to click pause before accessing resume.
                          _timerControlButtonKey.currentState?.setAction(TimerControlButtonActions.resume);
                        },
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
                            child: timerAnimationController != null
                              ? TimerControlButton(
                                  key: _timerControlButtonKey,
                                  timerAnimationController: timerAnimationController!
                                )
                              : null
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