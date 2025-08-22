import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/size_constants.dart';
import 'package:yourbreak/helper/page_navigation.dart';

import 'package:yourbreak/templates/mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/mixins/opacity_animation_mixin.dart';
import 'package:yourbreak/templates/mixins/slide_animations_mixin.dart';

import 'package:yourbreak/templates/generic_buttons/button_base.dart';



/// The standardized button for going back to the previous page, usually situated at the bottom of pages.
/// It slides in from the bottom.
/// Can take in an optional onPressed, that will be called instead of the default logic on button click.
class ReturnButton extends StatefulWidget {

  // Optional, will override the default click logic.
  final Function? onPressed;

  const ReturnButton({

    super.key,

    this.onPressed

  });

  @override
  State<StatefulWidget> createState() => ReturnButtonState();

}


class ReturnButtonState extends State<ReturnButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, OpacityAnimationMixin, VerticalSlideAnimationsMixin {

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

  void defaultClickLogic() => popCurrentPage(context);

  // ------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: WidgetSizeConstants.genericRectangleButton.width,
      height: WidgetSizeConstants.genericRectangleButton.height,
      child: ButtonBase(
        onPressed: widget.onPressed ?? defaultClickLogic,
      
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
                    child: OutlinedButton(
                      clipBehavior: Clip.hardEdge,
                      onPressed: null, // Handled by ButtonBase.
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(maxSize * 0.07),
                        ),
                        padding: EdgeInsets.zero,
                        side: BorderSide(
                          color: ReturnButtonColors.border,
                          width: maxSize * 0.015,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: Colors.transparent,
                      ),
                      child: IgnorePointer(
                        child: Center(
                          child: Text(
                            'Go Back',
                            style: TextStyle(
                              fontSize: maxSize * 0.125,
                              color: ReturnButtonColors.mainText,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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