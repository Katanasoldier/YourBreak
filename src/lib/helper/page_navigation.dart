import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yourbreak/constants/animation_constants.dart';


/// Standardized function to push a new page into view.
/// Currently the new page slides from the right,
/// with the ability to drag it away 'iOS' style.
/// Takes in a required context and newPage, with newPage
/// being the page that is supposed to be loaded.
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

/// Standardized function for popping the current page.
void popCurrentPage(BuildContext context) {
  
  Navigator.pop(context);

}