import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/animation_constants.dart';

/// Inner widget, meant to be only used within the home page.
/// Provides a column of 2 texts, where the 1st text scales bigger on hover.
/// Takes in a required:
/// - mainText : String, text of the 1st text that scales up.
/// - supportText : String, 2nd text, stays static
/// - mainTextGradient : Optional list of colors, ability to give mainText a gradient font color
class StatText extends StatefulWidget {

  final String mainText;
  final String supportText;
  final List<Color>? mainTextGradient;

  const StatText({
    super.key,
    required this.mainText,
    required this.supportText,
    this.mainTextGradient
  });

  @override
  State<StatefulWidget> createState() => StatTextState();
}

class StatTextState extends State<StatText> with TickerProviderStateMixin {


  late final AnimationController _hoverController = 
  AnimationController(
    vsync: this,
    duration: AnimationDurations.hover,
    reverseDuration: AnimationDurations.hover
  );


  late final Animation<double> hoverGrowAnimation = 
  Tween<double>(
    begin: 1.0,
    end: 1.1,
  ).animate(CurvedAnimation(
    parent: _hoverController,
    curve: AnimationCurves.hover,
  ));



  @override
  void initState(){
    super.initState();
  }


  @override
  void dispose() {

    _hoverController.dispose();

    super.dispose();
    
  }



  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _hoverController,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: widget.mainTextGradient ?? const [
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    widget.mainText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21 * hoverGrowAnimation.value,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              widget.supportText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: PureColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}