import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';

/// A mixin for any widgets that will animate their opacity.
mixin OpacityAnimationMixin<T extends StatefulWidget> on State<T> {

  // Default end opacity value, can be overidden.
  double get endOpacity => 0;
  
  // Duration for the opacity animation, can be overidden.
  Duration get opacityDuration => AnimationDurations.opacity;


  late final AnimationController opacityController = AnimationController(
    vsync: this as TickerProvider,
    duration: opacityDuration,
  );

  // Default opacity animation, can be overidden to include a different begin value.
  Animation<double> get opacityAnimation => Tween<double>(
    begin: 1,
    end: endOpacity
  ).animate(CurvedAnimation(
    parent: opacityController,
    curve: AnimationCurves.opacity
  ));
  

  @override
  void dispose() {
    opacityController.dispose();

    super.dispose();
  }
}