import 'package:flutter/material.dart';

class AnimationDurations {
  static const Duration hover = Duration(milliseconds: 200);
  static const Duration click = Duration(milliseconds: 125);
  static const Duration opacity = Duration(milliseconds: 500);
  static const Duration controlButtonHover = Duration(milliseconds: 100);
  static const Duration pageTransition = Duration(milliseconds: 500);
}

class AnimationCurves {
  static const Curve hover = Curves.easeOutQuad;
  static const Curve click = Curves.easeOutQuad;
  static const Curve pageTransition = Curves.easeOutCubic;
  static const Curve opacity = Curves.easeOutQuint;
  static const Curve slideInOutPage = Curves.easeInOutCubic;
}