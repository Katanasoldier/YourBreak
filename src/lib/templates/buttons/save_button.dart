import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/templates/base_mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/base_mixins/opacity_animation_mixin.dart';

import 'package:yourbreak/templates/base_mixins/page_animations_mixin.dart';

import 'package:yourbreak/templates/buttons/button_base.dart';


/// Button for saving different configurations.
/// 
/// Provides an onPressed that allows for a customized logic
/// to save anything this button is supposed to save.
class SaveButton extends StatefulWidget {

  // Requires the page's animation controller so it can trigger exitPage animations
  // in other widgets that animate in the same page.
  final AnimationController pageAnimationController;

  final VoidCallback? onPressed;

  const SaveButton({

    super.key,

    required this.pageAnimationController,
    required this.onPressed

  });

  @override
  SaveButtonState createState() => SaveButtonState();

}


class SaveButtonState extends State<SaveButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, OpacityAnimationMixin, VerticalSlidePageAnimationsMixin {

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

  // ------------------------------------------------------

  // Override the pageAnimationController to use the active/correct one provided by the widget.
  @override
  AnimationController get pageAnimationController => widget.pageAnimationController;

  // Will listen and update _exiting accordingly if pageAnimationController is forwarded.
  // This is so that this button will also animate if another widget forwards pageAnimationController.
  void externalPageAnimationControllerTriggerListener() {
    if (pageAnimationController.isForwardOrCompleted) setState(() => _exiting = true);
  }


  @override
  void initState() {
    super.initState();
    pageAnimationController.addListener(externalPageAnimationControllerTriggerListener);
  }

  @override
  void dispose() {
    pageAnimationController.removeListener(externalPageAnimationControllerTriggerListener);
    super.dispose();
  }

  // ------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      onPressed: () async {
        
        // Sets the exiting bool to true, so the activeSlideAnimation
        // will return exitSlideAnimation, so the button slides out.
        setState(() => _exiting = true); 
        
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
                            fontSize: maxSize * 0.125,
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
    );
  }
}