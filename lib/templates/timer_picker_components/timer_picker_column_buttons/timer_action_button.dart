import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';

import 'package:yourbreak/templates/mixins/interactive_animations_mixin.dart';

import 'package:yourbreak/templates/generic_buttons/button_base.dart';


/// A button widget that is meant to be only used within the TimerPickerColumnButtons.
/// 
/// Allows to create buttons which main purpose is to execute a predefined action upon a TimerPickerColumnButton.
/// 
/// It is a simple button contains an optional text and color.
/// It requires a font size, border radius and border width to be set, because
/// it is used in a TimerPickerColumnButton, in which there are preset settings for these properties.
class TimerActionButton extends StatefulWidget{

  final String? text;
  final Color? color;

  final double fontSize;
  final double borderRadius;
  final double borderWidth;

  final VoidCallback? onPressed;

  const TimerActionButton({
    super.key,

    this.text,
    this.color,
    
    required this.fontSize,
    required this.borderRadius,
    required this.borderWidth,

    required this.onPressed
  });

  @override
  TimerActionButtonState createState() => TimerActionButtonState();

}


class TimerActionButtonState extends State<TimerActionButton> with TickerProviderStateMixin, InteractiveAnimationsMixin {

  @override
  double get hoverSize => 1.125;

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      onPressed: widget.onPressed,

      rebuildListeners: [hoverController, clickController],
      mouseRegionBasedControllers: [hoverController],

      scaleAnimations: [
        hoverSizeAnimation,
        clickSizeAnimation
      ],

      child: OutlinedButton(
        onPressed: null,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius)
            )
          ),
          side: WidgetStateProperty.all(
            BorderSide(
              color: widget.color ?? PureColors.white,
              width: widget.borderWidth,
              strokeAlign: BorderSide.strokeAlignInside
            )
          ),
          animationDuration: Duration.zero,
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent)
        ),
        child: Text(
          widget.text ?? "N/A",
          style: TextStyle(
            color: widget.color ?? PureColors.white,
            fontWeight: FontWeight.w700,
            fontSize: widget.fontSize,
            height: 0.92
          ),
        )
      ),
    );
  }
}