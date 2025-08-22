import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/size_constants.dart';

import 'package:yourbreak/templates/mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/mixins/opacity_animation_mixin.dart';

import 'package:yourbreak/templates/generic_buttons/button_base.dart';



/// A button for TimerCreator, that when clicked is supposed to bring up a pop up
/// with the ability to add new periods to the currently edited/created timer.
/// The required onPressed it provides is supposed to encompass the aforementioned popup enabling logic.
/// 
/// It animates like a standard button (hover, click) and starts out with half of the opacity, on
/// hover it animates the opacity to 1.0.
class CreatePeriodButton extends StatefulWidget {

  final Function? onPressed;

  const CreatePeriodButton({
    super.key,

    required this.onPressed
  });

  @override
  CreatePeriodButtonState createState() => CreatePeriodButtonState();

}


class CreatePeriodButtonState extends State<CreatePeriodButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, OpacityAnimationMixin {

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
    return SizedBox(
      width: WidgetSizeConstants.genericRectangleButton.width,
      height: WidgetSizeConstants.genericRectangleButton.height,
      child: ButtonBase(
        onPressed: widget.onPressed, 
      
        rebuildListeners: [
          hoverSizeAnimation,
          clickSizeAnimation,
        ],
      
        mouseRegionBasedControllers: [
          hoverController,
          opacityController
        ],
      
        scaleAnimations: [
          hoverSizeAnimation,
          clickSizeAnimation
        ],
      
        clickController: clickController,
      
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.5),
                child: FittedBox(
                  child: Text(
                    "New Time Period",
                    style: TextStyle(
                      fontSize: FontSizes.genericRectangleButton,
                      color: PureColors.white.withValues(alpha: opacityAnimation.value),
                      fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

}