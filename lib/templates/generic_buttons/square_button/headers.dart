import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';


class MainTextWidget extends StatelessWidget {

  final String mainText;
  final double mainTextFontSize;
  final List<Color>? mainTextGradient;

  const MainTextWidget({

    super.key,

    required this.mainText,

    required this.mainTextFontSize,

    this.mainTextGradient,
    
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: mainTextGradient ?? const [
          SquareButtonColors.mainText,
          SquareButtonColors.mainText,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        mainText,
        style: TextStyle(
          fontSize: mainTextFontSize,
          fontWeight: FontWeight.w700,
          height: 0.92,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}



class SupportTextWidget extends StatelessWidget {

  final String? supportText;

  final double? supportTextFontSize;


  const SupportTextWidget({

    super.key,

    this.supportText,

    this.supportTextFontSize,

  });


  @override
  Widget build(BuildContext context) {
    return Text(
      supportText!,
      style: TextStyle(
        fontSize: supportTextFontSize,
        fontWeight: FontWeight.w400,
        height: 0.92,
        color: SquareButtonColors.supportText,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}



class Headers extends StatelessWidget {


  final String mainText;
  final String? supportText;

  final double mainTextFontSize;
  final double? supportTextFontSize;

  final bool? invertTextOrder;

  final List<Color>? mainTextGradient;

  final Animation<Offset>? mainTextSlideAnimation;
  final Animation<Offset>? supportTextSlideAnimation;


  const Headers({
    super.key,

    required this.mainText,
    this.supportText,

    required this.mainTextFontSize,
    this.supportTextFontSize,

    this.invertTextOrder,

    this.mainTextGradient,

    this.mainTextSlideAnimation,
    this.supportTextSlideAnimation,
  });


  @override
  Widget build(BuildContext context) {

    
    List<Widget> children = [];

    Widget mainTextWidget = MainTextWidget(mainText: mainText, mainTextFontSize: mainTextFontSize, mainTextGradient: mainTextGradient);
    if(mainTextSlideAnimation != null){
      mainTextWidget = SlideTransition(
        position: mainTextSlideAnimation!,
        child: mainTextWidget,
      );
    }


    late Widget supportTextWidget;
    if(supportText != null){
      supportTextWidget = SupportTextWidget(supportText: supportText, supportTextFontSize: supportTextFontSize);
      if(supportTextSlideAnimation != null){
        supportTextWidget = SlideTransition(
          position: supportTextSlideAnimation!,
          child: supportTextWidget
        );
      }
    }


    if (invertTextOrder == true) {
      if (supportText != null) children.add(supportTextWidget);
      children.add(mainTextWidget);
    } else {
      children.add(mainTextWidget);
      if (supportText != null) children.add(supportTextWidget);
    }


    return Stack(
      alignment: Alignment.center,
      children: children,
    );
  }
}