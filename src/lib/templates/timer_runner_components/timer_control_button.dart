import 'package:flutter/material.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/helper/timer_formatters.dart';
import 'package:yourbreak/templates/base_mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/base_mixins/opacity_animation_mixin.dart';
import 'package:yourbreak/templates/buttons/button_base.dart';



/// Contains all the actions the button can
/// perform including their functions.
enum _TimerControlButtonActions {

  start,
  resume,
  pause;

  /// Performs instructions assigned to the selected action.
  void perform(AnimationController timerAnimationController) {
    
    // Start and Resume both have the same actions
    if (this != _TimerControlButtonActions.pause) {
      timerAnimationController.forward();
      return;
    }
    
    // If it's pause, then stop the controller.
    timerAnimationController.stop();

  }

}


/// Inner widget meant to only be used within TimerRunner
/// Gives the ability to start, pause or resume running countdown timers.
/// Takes in a required timerAnimationController that is the controller inside
/// the active CircularTimer widget.
class TimerControlButton extends StatefulWidget {

  final AnimationController timerAnimationController;

  const TimerControlButton({
    super.key,

    required this.timerAnimationController
  });

  @override
  TimerControlButtonState createState() => TimerControlButtonState();

}


class TimerControlButtonState extends State<TimerControlButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, OpacityAnimationMixin {

  // We override the default opacity animation because it starts from 1,
  // but this requires it to start from 0.5.
  @override
  Animation<double> get opacityAnimation => Tween<double>(
    begin: 0.5,
    end: 1.0
  ).animate(CurvedAnimation(
    parent: opacityController,
    curve: AnimationCurves.opacity
  ));


  var currentAction = _TimerControlButtonActions.start;


  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      onPressed: () {
        
        currentAction.perform(widget.timerAnimationController);

        // Start and Resume both lead to pause,
        // and rebuild the button to display the correct action name.
        setState(() {
          if (currentAction != _TimerControlButtonActions.pause) {
            currentAction = _TimerControlButtonActions.pause;
          } else { // If it's pause
            currentAction = _TimerControlButtonActions.resume;
          }
        });

      },

      rebuildListeners: [hoverSizeAnimation, clickSizeAnimation, opacityAnimation],
      mouseRegionBasedControllers: [hoverController, opacityController],

      scaleAnimations: [hoverSizeAnimation, clickSizeAnimation],

      child: AnimatedBuilder(
        animation: opacityAnimation,
        builder: (context, child) => Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(
              color: PureColors.white.withValues(alpha: opacityAnimation.value),
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: Center(
            child: Text(
              capitalize(currentAction.name),
              style: TextStyle(
                fontSize: 14,
                color: PureColors.white.withValues(alpha: opacityAnimation.value),
                fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      )
    );
  }

}