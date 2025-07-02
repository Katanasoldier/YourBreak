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


class ControlButtonState extends State<ControlButton> with SingleTickerProviderStateMixin {


  late final AnimationController _hoverController = 
  AnimationController(
    vsync: this,
    duration: AnimationDurations.controlButtonHover,
    reverseDuration: AnimationDurations.controlButtonHover
  );


  late final Animation<double> _backgroundOpacityHoverAnimation = 
  Tween<double>(
    begin: 0.0,
    end: maxBackgroundOpacity
  ).animate(CurvedAnimation(
    parent: _hoverController,
    curve: AnimationCurves.hover,
    reverseCurve: AnimationCurves.hover,
  ));



  late final double maxBackgroundOpacity = (widget.iconName == "close" ? 1.0 : 0.2);



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
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => _hoverController.forward(),
        onExit: (_) => _hoverController.reverse(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: widget.iconName == "close"
                ? BorderRadius.zero
                : const BorderRadius.only(bottomLeft: Radius.circular(8)),
            onTap: widget.onPressed,
            child: AnimatedBuilder(
              animation: _hoverController,
              builder: (context, child) { 
                return Stack(
                  children: [
                    Opacity(
                      opacity: _backgroundOpacityHoverAnimation.value,
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
                        width: 11,
                        height: 11,
                        child: SvgPicture.asset( // For extra polish, add a higher opacity effect on hover.
                          'assets/svg/${widget.iconName}.svg',
                          fit: BoxFit.contain,
                          colorFilter: widget.iconName == "minimize" ? ColorFilter.mode(
                            Color(0xFFB7D2DE),
                            BlendMode.src
                          ) : null,
                        ),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}