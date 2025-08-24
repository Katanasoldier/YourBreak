import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';

/// Really basic divider widget.
/// Takes in a:
/// - width : required, double
/// - height : required, double
/// - fontAlpha : optional, default 0.5. Decides the alpha of the font color.
/// - color : optional, default PureColors.white
/// and returns a container matching those parameters.
class BasicDivider extends StatelessWidget {

  final double width;
  final double height;

  final double fontAlpha;
  final Color color;


  const BasicDivider({
    super.key,

    required this.width,
    required this.height,

    this.fontAlpha = 0.5,
    this.color = PureColors.white
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: fontAlpha),
        borderRadius: BorderRadius.circular(20)
      ),
    );
  }

}