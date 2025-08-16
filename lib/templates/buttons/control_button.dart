import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:yourbreak/constants/animation_constants.dart';

import 'package:yourbreak/constants/color_constants.dart';

import 'package:yourbreak/templates/base_mixins/opacity_animation_mixin.dart';

import 'package:yourbreak/templates/buttons/button_base.dart';


/// The control button widget used throughout the application.
/// It contains predefined opacity, color and border settings for only 2 versions of the button:
/// - Close
/// - Minimize
/// Not meant to be used for any other purpose than those listed above.
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


class ControlButtonState extends State<ControlButton> with TickerProviderStateMixin, OpacityAnimationMixin {

  /*
    Close button opacity: 1.0
    Minimize button opacity: 0.2
  */
  @override
  double get endOpacity => (widget.iconName == "close" ? 1.0 : 0.2);

  // Overriding the default opacity duration to be shorter for control buttons.
  @override
  Duration get opacityDuration => const Duration(milliseconds: 150);

  // The default opacity animation begins from 1, but control buttons are meant
  // to be transparent by default, so we override it to start from 0, and in the
  // process the end value is also set to the endOpacity value.
  @override
  Animation<double> get opacityAnimation => Tween<double>(
    begin: 0,
    end: endOpacity
  ).animate(CurvedAnimation(
    parent: opacityController,
    curve: AnimationCurves.opacity
  ));


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonBase(
            
        onPressed: widget.onPressed,
            
        rebuildListeners: [opacityAnimation],
        mouseRegionBasedControllers: [opacityController],
            
        child: AnimatedBuilder(
          animation: opacityController,
          builder: (context, child) { 
            return Stack(
              children: [
                Opacity(
                  opacity: opacityAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.iconName == "close"
                          ? ControlButtonColors.closeBackground
                          : ControlButtonColors.minimizeBackground,

                      // The minimize button has a rounded bottom left corner to not overflow
                      // while inside top_bar.dart's controlButtonFrame.
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
                    child: SvgPicture.asset(
                      'assets/svg/${widget.iconName}.svg',

                      // This prevents the svg from being too transparent when the application is opened.
                      colorFilter: widget.iconName == "minimize" ? ColorFilter.mode(
                        PureColors.white,
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
    );
  }
}