import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';

import 'package:yourbreak/templates/base_mixins/interactive_animations_mixin.dart';

import 'package:yourbreak/helper/timer_formatters.dart';

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

  const TimePeriodButton({
    super.key,

    required this.periodName,
    required this.periodTime
  });

  @override
  TimePeriodButtonState createState() => TimePeriodButtonState();

}


class TimePeriodButtonState extends State<TimePeriodButton> with TickerProviderStateMixin, InteractiveAnimationsMixin {

  late final String formattedPeriodName;
  late final Color periodColor;


  @override
  void initState() {
    super.initState();

    formattedPeriodName = formatPeriodName(widget.periodName);
    periodColor = getPeriodColor(widget.periodName);
  }


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
      
        child: OutlinedButton(
          clipBehavior: Clip.hardEdge,
          onPressed: null, // Handled by ButtonBase.
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.5),
            ),
            padding: EdgeInsets.zero,
            side: BorderSide(
              color: periodColor,
              width: 2.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            backgroundColor: periodColor.withValues(alpha: 0.1),
            splashFactory: NoSplash.splashFactory,
            overlayColor: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 7.5,
            children: [
              // The style here is that the divider is perfectly in the middle,
              // and the text can be shorter or longer, but the divider is perfectly centered.
              //
              // This allows the layout to remain consistent and easy on the eyes with the rest
              // of the TimePeriodButtons. Without it, the lines would not align and it would
              // look pretty bad.
              //
              // To achieve this, we have to wrap the text in expanded, and set the textAlign to
              // either right or left. This makes both texts take up the same amount of space, and
              // allows the divider to stay centered.
              Expanded(
                child: Text(
                  formattedPeriodName,
                  style: TextStyle(
                    fontSize: 15,
                    color: PureColors.white,
                    fontWeight: FontWeight.w700
                  ),
                  textAlign: TextAlign.right,
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
              Expanded(
                child: Text(
                  formatSeconds(widget.periodTime),
                  style: TextStyle(
                    fontSize: 15,
                    color: PureColors.white,
                    fontWeight: FontWeight.w700
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}