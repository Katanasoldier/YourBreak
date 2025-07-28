import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';


/// The base mixin for any widgets that will change in response to user input.
mixin InteractiveAnimationsMixin<T extends StatefulWidget> on State<T> {

  // Default animation parameters that can be overidden by inheriting classes.
  
    // Sizes
    double get hoverSize => 1.05;
    double get clickSize => 0.8;


  // AnimationControllers.

    late final AnimationController hoverController = AnimationController(
      vsync: this as TickerProvider,
      duration: AnimationDurations.hover,
    );

    late final AnimationController clickController = AnimationController(
      vsync: this as TickerProvider,
      duration: AnimationDurations.click,
    );


  /* 
    Below are functions that when called will return an OverridableAnimation.

    They are here so that any widgets that will be based on this class can
    override them if needed, and change them to fit their requirements.
  */

    Animation get hoverSizeAnimation => Tween<double>(
      begin: 1,
      end: hoverSize
    ).animate(CurvedAnimation(
      parent: hoverController,
      curve: AnimationCurves.hover
    ));

    Animation get clickSizeAnimation => Tween<double>(
      begin: 1,
      end: clickSize
    ).animate(CurvedAnimation(
      parent: clickController,
      curve: AnimationCurves.click
    ));

  
  @override
  void dispose() {
    hoverController.dispose();
    clickController.dispose();

    super.dispose();
  }
}