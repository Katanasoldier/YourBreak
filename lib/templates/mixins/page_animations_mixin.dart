import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';


/// A mixin for any widgets that have animations tied to a shared AnimationController, and are supposed to shrink and fade out.
mixin FadeShrinkPageAnimationsMixin<T extends StatefulWidget> on State<T> {

  // Any widgets extending their state with this mixin are required to override this pageAnimationController, by setting it to their pageAnimationController.
  late final AnimationController pageAnimationController;


  // Default end values, can be overidden.
  double get endPageSize => 0.5;
  double get endPageAnimationOpacity => 0;


  // Simple page animations, any widget with this mixin will size down and fade out (can be overidden).

  Animation<double> get pageSizeAnimation => Tween<double>(
      begin: 1,
      end: endPageSize
    ).animate(CurvedAnimation(
      parent: pageAnimationController,
      curve: AnimationCurves.pageTransition
    )
  );

  Animation<double> get pageOpacityAnimation => Tween<double>(
      begin: 1,
      end: endPageAnimationOpacity
    ).animate(CurvedAnimation(
      parent: pageAnimationController,
      curve: AnimationCurves.opacity
    )
  );
}


/// A mixin for any widgets that have animations tied to a shared AnimationController, and are supposed to slide.
mixin VerticalSlidePageAnimationsMixin<T extends StatefulWidget> on State<T> {

  // Any widgets extending their state with this mixin are required to override this pageAnimationController, by setting it to their pageAnimationController.
  late final AnimationController pageAnimationController;

  // Animates the widget sliding in when loaded.
  late final AnimationController enterSlideController = AnimationController(
    vsync: this as TickerProvider,
    duration: AnimationDurations.pageTransition,
  );


  // BASED ON OFFSET! Positive values mean down, negative mean up!
    // This value specifies, from how high up or low to slide in from.
    double get startEnterSlideYOffset => 1;

    // This value specifies, from how high up or low to slide out to.
    double get endExitSlideYOffset => 1;


  // Any widget with this mixin will slide in on load, and out in sync with other page animations. (can be overidden).

  Animation<Offset> get enterSlideAnimation => Tween<Offset>(
      begin: Offset(0, startEnterSlideYOffset),
      end: Offset(0, 0)
    ).animate(CurvedAnimation(
      parent: enterSlideController,
      curve: AnimationCurves.slideInOutPage
    )
  );

  Animation<Offset> get exitSlideAnimation => Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, endExitSlideYOffset)
    ).animate(CurvedAnimation(
      parent: pageAnimationController,
      curve: AnimationCurves.slideInOutPage
    )
  );


  @override
  void initState() {

    super.initState();

    enterSlideController.forward();

  }

  @override
  void dispose() {

    enterSlideController.dispose();

    super.dispose();

  }
}