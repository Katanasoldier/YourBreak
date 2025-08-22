import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/size_constants.dart';
import 'package:yourbreak/templates/mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/mixins/opacity_animation_mixin.dart';
import 'package:yourbreak/templates/mixins/slide_animations_mixin.dart';

import 'package:yourbreak/templates/generic_buttons/button_base.dart';


/// Button for saving different configurations.
/// 
/// Provides an onPressed that allows for a customized logic
/// to save anything this button is supposed to save.
class SaveButton extends StatefulWidget {

  final VoidCallback? onPressed;

  const SaveButton({

    super.key,

    required this.onPressed

  });

  @override
  SaveButtonState createState() => SaveButtonState();

}

class SaveButtonState extends State<SaveButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, OpacityAnimationMixin, VerticalSlideAnimationsMixin {

  @override
  double get startVerticalSlideAnimationValue => 1;  

  @override
  Animation<double> get opacityAnimation => Tween<double>(
    begin: 0.4,
    end: 1.0
  ).animate(CurvedAnimation(
    parent: opacityController,
    curve: AnimationCurves.opacity
  ));

  @override
  Animation<double> get hoverSizeAnimation => Tween<double>(
    begin: 0.975,
    end: 1.1,
  ).animate(CurvedAnimation(
    parent: hoverController,
    curve: AnimationCurves.hover,
  ));

  // ------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: WidgetSizeConstants.genericRectangleButton.width,
      height: WidgetSizeConstants.genericRectangleButton.height,
      child: ButtonBase(
        onPressed: () async {
          
          widget.onPressed?.call();
        
        },
      
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
          clickSizeAnimation,
        ],
      
        hoverController: hoverController,
        clickController: clickController,
      
        child: AnimatedBuilder( // Rebuilds when opacity or slide animations run.
          animation: Listenable.merge([
            opacityAnimation,
            verticalSlideAnimation
          ]),
          builder: (context, child) {
            return Transform.translate( // Translates the button based on the offset of the active slide animation.
              offset: Offset(
                0,
                // Multiplies the y-offset by the screen height to ensure the button slides in and out of view correctly.
                verticalSlideAnimation.value.dy * MediaQuery.of(context).size.height,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
              
                  final double maxSize = constraints.maxWidth;
              
                  return Opacity(
                    opacity: opacityAnimation.value,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: SaveButtonColors.border,
                          width: maxSize * 0.015,
                        ),
                        borderRadius: BorderRadius.circular(maxSize * 0.07),
                      ),
                      child: IgnorePointer(
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: FontSizes.genericRectangleButton,
                              color: SaveButtonColors.mainText,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}