import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/templates/base_mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/base_mixins/opacity_animation_mixin.dart';

import 'package:yourbreak/templates/base_mixins/page_animations_mixin.dart';

import 'package:yourbreak/templates/buttons/button_base.dart';


/// The standardized button for going back to the previous page, usually situated at the bottom of pages.
/// It slides in from the bottom, and slides out also to the bottom.
class ReturnButton extends StatefulWidget {

  // Requires the page's animation controller so it can trigger exitPage animations
  // in other widgets that animate in the same page.
  final AnimationController pageAnimationController;

  const ReturnButton({

    super.key,

    required this.pageAnimationController,

  });

  @override
  State<StatefulWidget> createState() => ReturnButtonState();

}


class ReturnButtonState extends State<ReturnButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, OpacityAnimationMixin, VerticalSlidePageAnimationsMixin {

  // Controls the active slide animation (_activeSlideAnimation)
  bool _exiting = false;

  // Returns the slide animation based on whether the button is exiting or entering the page.

  // This is required because Transform.translate can only take in a value from 1 animation at a time.
  // By using a getter, we can dynamically provide the correct animation (enter or exit)
  // every time the widget rebuilds.
  Animation<Offset> get _activeSlideAnimation =>
        _exiting ? exitSlideAnimation : enterSlideAnimation;

  // ------------------------------------------------------

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

  // Override the pageAnimationController to use the active/correct one provided by the widget.
  @override
  AnimationController get pageAnimationController => widget.pageAnimationController;

  // ------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      onPressed: () async {
        
        // Sets the exiting bool to true, so the activeSlideAnimation
        // will return exitSlideAnimation, so the button slides out.
        setState(() => _exiting = true); 
        
        // await until the controller finishes to not pop the page too early
        await widget.pageAnimationController.forward();
            
        Navigator.of(context).pop();
      
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
          enterSlideAnimation,
          exitSlideAnimation
        ]),
        builder: (context, child) {
          return Transform.translate( // Translates the button based on the offset of the active slide animation.
            offset: Offset(
              0,
              // Multiplies the y-offset by the screen height to ensure the button slides in and out of view correctly.
              _activeSlideAnimation.value.dy * MediaQuery.of(context).size.height,
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
    );
  }
}