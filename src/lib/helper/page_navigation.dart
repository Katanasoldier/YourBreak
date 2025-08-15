import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yourbreak/constants/animation_constants.dart';



void navigateTo(BuildContext context, Widget newPage) {
  
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.rightToLeft,

      duration: AnimationDurations.pageTransition,
      reverseDuration: AnimationDurations.pageTransition,

      isIos: true,

      curve: AnimationCurves.pageTransition,

      child: newPage
    )
  );

}

void popCurrentPage(BuildContext context) {
  
  Navigator.pop(context);

}