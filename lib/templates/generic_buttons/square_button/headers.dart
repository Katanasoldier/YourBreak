import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';


/// Creates the main text inside a SquareButton.
/// Takes in:
/// - mainText : text to be displayed
/// - mainTextFontSize : double
/// - mainTextGradient : a list of colors, allows the text to have a gradient effect
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


/// Creates the support text inside a SquareButton, usually below the MainText,
/// but with the invertedText option set inside the SquareButton, the supportText will appear above the MainText.
/// The support text does not have the ability to have it's text color a gradient, unlike MainText.
/// Takes in:
/// - supportText : text to be displayed
/// - supportTextFontSize : double
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



/// Creates the headers required to properly label a SquareButton.
/// Creates 2 headers by usual, but can create only 1 by not passing a supportText value.
/// Takes in:
/// - mainText : String
/// - supportText : optional, String
/// - mainTextFontSize : double
/// - supportTextFontSize : optional, double
/// - invertTextOrder : optional, bool. When true, the support text will appear above the mainText.
/// - mainTextGradient : optional, a list of colors
/// - mainTextSlideAnimation : Offset Animation, animates the position of mainText and makes it slide in.
/// - supportTextSlideAnimation : Offset Animation, animates the position of supportText and makes it slide in.
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

    // If invertTextOrder is true, first add the supportText, else mainText.
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