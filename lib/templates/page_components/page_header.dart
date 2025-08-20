import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';

import 'package:yourbreak/templates/mixins/page_animations_mixin.dart';


/// Provides the default standardized page header.
/// Takes in:
/// - text : String
/// - fontSize : double
/// - pageAnimationController : AnimationController
/// - margin : EdgeInsets, defaults to horizontal 15
/// - fontColor : Color, defaults to PageHeaderColors.headerText
class PageHeader extends StatefulWidget {

  final String text;
  final double fontSize;
  final AnimationController pageAnimationController;

  final EdgeInsets margin;
  final Color fontColor;

  const PageHeader({
    super.key,
    required this.text,
    required this.fontSize,
    required this.pageAnimationController,

    this.margin = const EdgeInsets.symmetric(horizontal: 15),
    this.fontColor = PageHeaderColors.headerText
  });

  @override
  State<PageHeader> createState() => PageHeaderState();

}


class PageHeaderState extends State<PageHeader> with SingleTickerProviderStateMixin, VerticalSlidePageAnimationsMixin {

  /// If true, the slide animation will switch the the exit version, else to the enter.

    bool _exiting = false;

    Animation get _activeSlideAnimation => _exiting
      ? exitSlideAnimation
      : enterSlideAnimation;


  /// Assigned to pageAnimationController as a listener,
  /// assigns exiting based on the value of isForwardOrCompleted of the pageAnimationController.
  void _pageControllerListener() {
    setState(() {
      _exiting = widget.pageAnimationController.isForwardOrCompleted;
    });
  }



  @override
  void initState() {
    super.initState();

    widget.pageAnimationController.addListener(_pageControllerListener);
  }

  @override
  void dispose() {
    widget.pageAnimationController.removeListener(_pageControllerListener);

    super.dispose();
  }


  /// Allows SlideAnimationMixin to get the current pageAnimationController to parent it's animations to.
  @override
  AnimationController get pageAnimationController => widget.pageAnimationController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _activeSlideAnimation,
      builder: (context, child) =>
      Transform.translate(
        offset: Offset(
          0,
          // Multiplies the y-offset by the screen height to ensure the button slides in and out of view correctly.
          // The value here is inverted or else it will slide down instead of up when exiting.
          -_activeSlideAnimation.value.dy * MediaQuery.of(context).size.height,
        ),
        child: Container(
          margin: widget.margin,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: widget.fontColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

}