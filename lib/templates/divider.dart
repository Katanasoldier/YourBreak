import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';

/// Really basic divider widget.
/// Takes in a:
/// - width : required, double
/// - height : required, double
/// - color : optional, default PureColors.white
/// and returns a container matching those parameters.
class BasicDivider extends StatelessWidget {

  final double width;
  final double height;

  final Color color;


  const BasicDivider({
    super.key,

    required this.width,
    required this.height,

    this.color = PureColors.white
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20)
      ),
    );
  }

}