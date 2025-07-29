import 'package:flutter/material.dart';
import 'package:yourbreak/constants/animation_constants.dart';

/// This mixin provides the standard pageAnimationController to be used on pages to control
/// their compatible inner widget's pageAnimations.
/// 
/// Compatible inner widgets as in widgets inside a page that listen to a page's pageAnimationController
/// to animate in sync with other compatible widgets to give a full page animation effect.
mixin PageAnimationControllerMixin<T extends StatefulWidget> on State<T> {
  
  /// Functional to not interfere with other mixin's pageAnimationController properties and to avoid overwriting anything.
  late final functionalPageAnimationController = AnimationController(
    vsync: this as TickerProvider,
    duration: AnimationDurations.pageTransition
  );

  @override
  void dispose() {
    functionalPageAnimationController.dispose();
    super.dispose();
  }

}