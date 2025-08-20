import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/templates/mixins/slide_animations_mixin.dart';

/// Provides the default standardized page header.
/// Takes in:
/// - text : String
/// - fontSize : double
/// - margin : EdgeInsets, defaults to horizontal 15
/// - fontColor : Color, defaults to PageHeaderColors.headerText
class PageHeader extends StatefulWidget {

  final String text;
  final double fontSize;

  final EdgeInsets margin;
  final Color fontColor;

  const PageHeader({
    super.key,
    required this.text,
    required this.fontSize,

    this.margin = const EdgeInsets.symmetric(horizontal: 15),
    this.fontColor = PageHeaderColors.headerText
  });

  @override
  State<PageHeader> createState() => PageHeaderState();

}

class PageHeaderState extends State<PageHeader> with SingleTickerProviderStateMixin, VerticalSlideAnimationsMixin {

  @override
  double get startVerticalSlideAnimationValue => -1;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: verticalSlideAnimation,
      builder: (context, child) =>
      Transform.translate(
        offset: Offset(
          0,
          // Multiplies the y-offset by the screen height to ensure the button slides in and out of view correctly.
          verticalSlideAnimation.value.dy * MediaQuery.of(context).size.height,
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