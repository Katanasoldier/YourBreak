import 'package:flutter/material.dart';
import 'package:yourbreak/constants/animation_constants.dart';

/// Mixin that allows widget to add vertical slide animations.
/// Provides an animation controller and 2 getters that must be overridden
/// and assigned a value or else they'll default to 0:
/// - startVerticalSlideAnimationValue
/// - endVerticalSlideAnimationValue
/// The animation plays automatically on state initialization, but can be
/// stopped by setting forwardVerticalSlideOnInitState to false.
mixin VerticalSlideAnimationsMixin<T extends StatefulWidget> on State<T> {

  late final AnimationController verticalSlideAnimationController = AnimationController(
    vsync: this as TickerProvider,
    duration: AnimationDurations.verticalSlide,
  );

  /// Decides whether to forward the controller in initState.
  bool get forwardVerticalSlideOnInitState => true;

  // BASED ON OFFSET! Positive values mean down, negative mean up!
  // This value specifies, from how high up or low to slide in from.
  double get startVerticalSlideAnimationValue => 0;
  double get endVerticalSlideAnimationValue => 0;


  Animation<Offset> get verticalSlideAnimation => Tween<Offset>(
      begin: Offset(0, startVerticalSlideAnimationValue),
      end: Offset(0, endVerticalSlideAnimationValue)
    ).animate(CurvedAnimation(
      parent: verticalSlideAnimationController,
      curve: AnimationCurves.verticalSlide
    )
  );


  @override
  void initState() {

    super.initState();

    if (forwardVerticalSlideOnInitState) verticalSlideAnimationController.forward();

  }

  @override
  void dispose() {

    verticalSlideAnimationController.dispose();

    super.dispose();

  }

}