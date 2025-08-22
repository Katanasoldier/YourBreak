import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/size_constants.dart';
import 'package:yourbreak/templates/mixins/interactive_animations_mixin.dart';


import 'package:yourbreak/templates/generic_buttons/button_base.dart';
import 'package:yourbreak/templates/generic_buttons/square_button/headers.dart';
import 'package:yourbreak/templates/mixins/scale_animations_mixin.dart';


/// The square button, used for picking main options in the application,
/// and for navigating to other pages.
/// 
/// It contains a main text, an optional support text, an optional description and an optional image.
/// The main text can contain an optional gradient, and the order of the main and support text can be inverted.
/// The image can be an SVG, and has the option to fill the entire button or not.
/// 
/// Must provide a onPressed.
class SquareButton extends StatefulWidget {
  
  // Text fields
    final String mainText;
    final String? supportText;
    final String? description;

  // Text setting fields
    final List<Color>? mainTextGradient;
    final bool? invertTextOrder;

  // Image setting fields
    final String? iconName;
    final bool? iconFillButton;

  // Callback
  final VoidCallback onPressed;


  const SquareButton({

    super.key,

    required this.mainText,
    this.supportText,
    this.description,

    this.mainTextGradient,
    this.invertTextOrder,

    this.iconName,
    this.iconFillButton,


    required this.onPressed,
  });


  @override
  SquareButtonState createState() => SquareButtonState();

}


class SquareButtonState extends State<SquareButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, ScaleAnimationsMixin {

  @override
  double get hoverSize => 1.075;

  // ------------------------------------------------------------
  // Scale as in transform.scale().
  // Starts with 0 and ends with 1 to give the button an effect
  // of growing in when loaded.

  @override
  bool get forwardScaleOnInitState => true;

  @override
  double get startScaleAnimationValue => 0;

  @override
  double get endScaleAnimationValue => 1;

  // ------------------------------------------------------------

  late final Animation<Offset> _mainTextSlideAnimation = 
    Tween<Offset>(
      begin: Offset(0, 0),
      end: widget.supportText != null ? (widget.invertTextOrder == true ? Offset(0, 0.323) : Offset(0, -0.323)) : Offset(0,0)
    ).animate(CurvedAnimation(
      parent: hoverController,
      curve: AnimationCurves.hover
    )
  );

  late final Animation<Offset> _supportTextSlideAnimation = 
    Tween<Offset>(
      begin: widget.invertTextOrder == true ? Offset(0, -4) : Offset(0, 4),
      end: widget.invertTextOrder == true ? Offset(0, -0.77) : Offset(0, 0.77)
    ).animate(CurvedAnimation(
      parent: hoverController,
      curve: AnimationCurves.hover
    )
  );


  @override
  Widget build(BuildContext context) {
    return SizedBox(

      width: WidgetSizeConstants.squarebutton.width,
      height: WidgetSizeConstants.squarebutton.height,
      
      child: ButtonBase(
        onPressed: widget.onPressed,
        
        rebuildListeners: [
          hoverSizeAnimation,
          clickSizeAnimation,
          scaleAnimationController,
        ],
        mouseRegionBasedControllers: [
          hoverController,
        ],
      
        scaleAnimations: [
          hoverSizeAnimation,
          clickSizeAnimation,
          scaleAnimation
        ],
      
        hoverController: hoverController,
        clickController: clickController,
      
        child: LayoutBuilder(
          builder: (context, constraints) {
        
            final double maxButtonWidth = constraints.maxWidth;
            final double maxButtonHeight = constraints.maxHeight;
        
            // Makes the buttonWidth smaller if it isn't supposed to fill the whole button.
            final double imageSize = (widget.iconFillButton == true ? maxButtonWidth : maxButtonWidth * 0.85);
        
            final double mainTextFontSize = maxButtonHeight * 0.22;
            final double supportTextFontSize = maxButtonHeight * 0.14;
        
        
            return Stack(
              clipBehavior: Clip.none, // To allow the description to be positioned lower than the button.
              alignment: Alignment.center,
              children: [
                OutlinedButton(
                  onPressed: null, // Handled by ButtonBase
                  clipBehavior: Clip.hardEdge,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(maxButtonHeight * 0.12),
                    ),
                    padding: EdgeInsets.all(0),
                    side: BorderSide(
                      color: SquareButtonColors.border,
                      width: (maxButtonWidth * 0.025),
                    ),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: widget.iconFillButton == true
                          ? const EdgeInsets.all(0) // No padding, allows the icon to fill the whole button.
                          : const EdgeInsets.all(20),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg/${widget.iconName}.svg',
                            width: imageSize,
                            height: imageSize,
                          ),
                        ),
                      ),
                      Center(
                        child: Headers(
                          mainText: widget.mainText,
                          supportText: widget.supportText,
                          
                          mainTextFontSize: mainTextFontSize,
                          supportTextFontSize: supportTextFontSize,
                        
                          invertTextOrder: widget.invertTextOrder,
                        
                          mainTextGradient: widget.mainTextGradient,
                        
                          mainTextSlideAnimation: _mainTextSlideAnimation,
                          supportTextSlideAnimation: _supportTextSlideAnimation,
                        ),
                      )
                    ],
                  ),
                ),
                if(widget.description!=null)
                Positioned(
                  bottom: -33, // 33 down from the bottom of the button.
                  child: Text(
                    widget.description!,
                    style: TextStyle(
                      color: SquareButtonColors.description,
                      fontSize: maxButtonWidth * 0.077,
                      fontWeight: FontWeight.w400,
                      height: 1.07
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}