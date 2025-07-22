import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/animation_constants.dart';


class ButtonActionOption extends StatefulWidget{

  final String? text;
  final Color? color;

  final double fontSize;
  final double borderRadius;
  final double borderWidth;

  const ButtonActionOption({
    super.key,

    this.text,
    this.color,
    
    required this.fontSize,
    required this.borderRadius,
    required this.borderWidth
  });

  @override
  ButtonActionOptionState createState() => ButtonActionOptionState();

}


class ButtonActionOptionState extends State<ButtonActionOption> with TickerProviderStateMixin {


  late final AnimationController _hoverController = AnimationController(
    vsync: this,
    duration: AnimationDurations.hover,
    reverseDuration: AnimationDurations.hover
  );

  late final AnimationController _clickController = AnimationController(
    vsync: this,
    duration: AnimationDurations.click,
    reverseDuration: AnimationDurations.click
  );


  late final Animation<double> _buttonHoverSizeAnimation =
    Tween<double>(
      begin: 1.0,
      end: 1.125
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: AnimationCurves.hover
    )
  ); 

  late final Animation<double> _buttonClickSizeAnimation = 
    Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _clickController,
      curve: AnimationCurves.click,
    )
  );


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _hoverController.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hoverController, _clickController]),
      builder: (context, child) =>
      Transform.scale(
        scale: _buttonHoverSizeAnimation.value * _buttonClickSizeAnimation.value,
        child: MouseRegion(
          onEnter: (_) => _hoverController.forward(),
          onExit: (_) => _hoverController.reverse(),
          child: OutlinedButton(
            onPressed: () => _clickController,
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
        ),
      ),
    );
  }

}