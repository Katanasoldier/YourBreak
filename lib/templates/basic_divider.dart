import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';

/// Really basic divider widget.
/// Takes in a:
/// - width : required, double
/// - height : required, double
/// - colorAlpha : optional, default 0.5. Decides the alpha of the color.
/// - color : optional, default PureColors.white
/// and returns a container matching those parameters.
class BasicDivider extends StatelessWidget {

  final double width;
  final double height;

  final double colorAlpha;
  final Color color;


  const BasicDivider({
    super.key,

    required this.width,
    required this.height,

    this.colorAlpha = 0.5,
    this.color = PureColors.white
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: colorAlpha),
        borderRadius: BorderRadius.circular(20)
      ),
    );
  }

}