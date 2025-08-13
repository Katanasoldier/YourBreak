import 'package:flutter/material.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/templates/base_mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/base_mixins/opacity_animation_mixin.dart';
import 'package:yourbreak/templates/buttons/button_base.dart';



class TimerControlButton extends StatefulWidget {
  

  const TimerControlButton({
    super.key
  });

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



  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      onPressed: null,

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
              "Start",
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