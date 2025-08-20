import 'package:flutter/material.dart';

/// Contains standardized animation controller durations for different animations.
class AnimationDurations {
  static const Duration hover = Duration(milliseconds: 200);
  static const Duration click = Duration(milliseconds: 125);
  static const Duration opacity = Duration(milliseconds: 200);
  static const Duration controlButtonHover = Duration(milliseconds: 100);
  static const Duration pageTransition = Duration(milliseconds: 500);
  static const Duration scroll = Duration(milliseconds: 200);
  static const Duration blur = Duration(milliseconds: 200);
  static const Duration scale = Duration(milliseconds: 450);
  static const Duration verticalSlide = Duration(milliseconds: 450);
}

/// Contains standardized animation curves for different animations.
class AnimationCurves {
  static const Curve hover = Curves.easeOutQuad;
  static const Curve click = Curves.easeOutQuad;
  static const Curve pageTransition = Curves.easeInOutQuad;
  static const Curve opacity = Curves.easeOutQuint;
  static const Curve slideInOutPage = Curves.easeInOutCubic;
  static const Curve scroll = Curves.fastEaseInToSlowEaseOut;
  static const Curve blur = Curves.fastOutSlowIn;
  static const Curve popupOpacity = Curves.fastOutSlowIn;
  static const Curve scale = Curves.easeOutQuad;
  static const Curve verticalSlide = Curves.easeOutQuad;
}