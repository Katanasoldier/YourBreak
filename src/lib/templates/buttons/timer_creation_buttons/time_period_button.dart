import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';

import 'package:yourbreak/templates/base_mixins/interactive_animations_mixin.dart';

import 'package:yourbreak/helper/timer_formatters.dart';
import 'package:yourbreak/templates/base_mixins/opacity_animation_mixin.dart';

import 'package:yourbreak/templates/buttons/button_base.dart';


/// Button intended for visualising timer periods inside the TimerCreator
/// by showing them in a button.
/// 
/// Displays the period type and period time.
/// 
/// Takes in a required periodName (raw, without formatting) and a periodTime (in seconds).
/// Only scales up on hover, no click or other animations.
class TimePeriodButton extends StatefulWidget {

  /// Requires an unformatted period name!
  final String periodName;
  /// Requires raw seconds!
  final int periodTime;

  /// Function that will be called when the widget's
  /// RemoveButton is clicked.
  final Function onRemove;

  const TimePeriodButton({
    super.key,

    required this.periodName,
    required this.periodTime,

    required this.onRemove
  });

  @override
  TimePeriodButtonState createState() => TimePeriodButtonState();

}


class TimePeriodButtonState extends State<TimePeriodButton> with TickerProviderStateMixin, InteractiveAnimationsMixin {

  late final String formattedPeriodName = formatPeriodName(widget.periodName);
  late final Color periodColor = getPeriodColor(widget.periodName);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 225,
      height: 35,
      child: ButtonBase(
        onPressed: null,
      
        rebuildListeners: [hoverSizeAnimation],
        mouseRegionBasedControllers: [hoverController],
        scaleAnimations: [hoverSizeAnimation],
      
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: periodColor,
              width: 2.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            borderRadius: BorderRadius.circular(12.5),
            color: periodColor.withValues(alpha: 0.1)
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 4),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 7.5,
                  children: [
                    Text(
                        formattedPeriodName,
                        style: TextStyle(
                          fontSize: 15,
                          color: PureColors.white,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    Container( // Divider
                      height: 20,
                      width: 2,
                      decoration: BoxDecoration(
                        color: PureColors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    Text(
                      formatSeconds(widget.periodTime),
                      style: TextStyle(
                        fontSize: 15,
                        color: PureColors.white,
                        fontWeight: FontWeight.w700
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RemoveButton(onPressed: widget.onRemove),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}


class RemoveButton extends StatefulWidget {

  final Function onPressed;

  const RemoveButton({
    super.key,

    required this.onPressed
  });

  @override
  RemoveButtonState createState() => RemoveButtonState();

}

class RemoveButtonState extends State<RemoveButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, OpacityAnimationMixin {

  @override
  Animation<double> get opacityAnimation => Tween<double>(
    begin: 0.5,
    end: 1
  ).animate(CurvedAnimation(
    parent: opacityController,
    curve: AnimationCurves.opacity
  ));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 23.5,
      height: 23.5,
      child: ButtonBase(
        onPressed: widget.onPressed,
      
        rebuildListeners: [hoverSizeAnimation, clickSizeAnimation, opacityAnimation],
        mouseRegionBasedControllers: [hoverController, opacityController],
      
        scaleAnimations: [hoverSizeAnimation, clickSizeAnimation],
      
        child: AnimatedBuilder(
          animation: opacityAnimation,
          builder: (context, child) => Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: PureColors.red.withValues(alpha: opacityAnimation.value),
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
                borderRadius: BorderRadius.circular(7.5),
                color: PureColors.red.withValues(alpha: 0.1)
              ),
            child: Padding(
              padding: EdgeInsets.all(3),
              child: Opacity(
                opacity: opacityAnimation.value,
                child: SvgPicture.asset(
                  'assets/svg/x.svg',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}