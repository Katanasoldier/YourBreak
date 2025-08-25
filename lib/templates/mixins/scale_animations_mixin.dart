import 'package:flutter/material.dart';
import 'package:yourbreak/constants/animation_constants.dart';

/// Mixin that allows widget to add a scale animation.
/// Provides an animation controller and 2 getters:
/// - startScaleAnimationValue : defaults to 1
/// - endScaleAnimationValue : defaults to 1.1
/// The animation DOESN'T play automatically on state initialization, but can be
/// changed by setting forwardScaleOnInitState to true.
mixin ScaleAnimationsMixin<T extends StatefulWidget> on State<T> {
  
  late final AnimationController scaleAnimationController;

  /// Decides whether to forward the controller in initState.
  bool get forwardScaleOnInitState => false;

  // Default, can be overidden.
  double get startScaleAnimationValue => 1;
  double get endScaleAnimationValue => 1.1;

  Animation<double> get scaleAnimation => Tween<double>(
      begin: startScaleAnimationValue,
      end: endScaleAnimationValue
    ).animate(CurvedAnimation(
      parent: scaleAnimationController,
      curve: AnimationCurves.scale
    )
  );

  @override
  void initState() {

    super.initState();

    scaleAnimationController = AnimationController(
      vsync: this as TickerProvider,
      duration: AnimationDurations.scale,
    );

    if (forwardScaleOnInitState) scaleAnimationController.forward();

  }

  @override
  void dispose() {
    
    scaleAnimationController.dispose();

    super.dispose();

  }

}