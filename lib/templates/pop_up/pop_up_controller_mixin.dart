import 'package:flutter/material.dart';
import 'package:yourbreak/constants/animation_constants.dart';

/// Mixins a popUpController into any class's state.
/// 
/// Required to animate and show pop ups correctly.
mixin PopUpControllerMixin<T extends StatefulWidget> on State<T> {

  late final AnimationController popUpController;


  @override
  void initState() {
    super.initState();

    popUpController = AnimationController(
      vsync: this as TickerProvider,
      duration: AnimationDurations.blur
    );

    // So the pop up is hidden by default.
    popUpController.reverse();
  }

  @override
  void dispose() {
    popUpController.dispose();

    super.dispose();
  }

}