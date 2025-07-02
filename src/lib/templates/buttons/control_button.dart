import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';

class ControlButton extends StatefulWidget {

  final String iconName;
  final VoidCallback onPressed;

  const ControlButton({
    super.key,
    required this.iconName,
    required this.onPressed,
  });

  @override
  ControlButtonState createState() => ControlButtonState();

}

// REMEMBER TO ADD ON CLICK HIGHER OPACITY EFFECT !!!

class ControlButtonState extends State<ControlButton> with SingleTickerProviderStateMixin {


  late final AnimationController _hoverController = 
  AnimationController(
    vsync: this,
    duration: AnimationDurations.controlButonHover,
    reverseDuration: AnimationDurations.controlButonHover
  );


  late final Animation<double> _opacityAnimation = 
  Tween<double>(
    begin: 0.0,
    end: maxOpacity
  ).animate(CurvedAnimation(
    parent: _hoverController,
    curve: AnimationCurves.opacity,
    reverseCurve: AnimationCurves.opacity,
  ));


  late final double maxOpacity = (widget.iconName == "close" ? 1.0 : 0.2);



  @override
  void initState() {

    super.initState();

    _hoverController.reverse();

  }


  @override
  void dispose() {

    _hoverController.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              borderRadius: widget.iconName == "close"
                  ? BorderRadius.zero
                  : const BorderRadius.only(bottomLeft: Radius.circular(8)),
              onTap: widget.onPressed,
              child: Stack(
                children: [
                  Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.iconName == "close"
                            ? ControlButtonColors.closeBackground
                            : ControlButtonColors.minimizeBackground,
                        borderRadius: widget.iconName == "close"
                            ? BorderRadius.zero
                            : const BorderRadius.only(bottomLeft: Radius.circular(5.9)),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: SvgPicture.asset(
                        'assets/svg/${widget.iconName}.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}