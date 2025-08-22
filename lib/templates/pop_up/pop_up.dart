import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';

import 'package:yourbreak/templates/mixins/opacity_animation_mixin.dart';



/// A widget that overlays over the current content.
/// Blurs what's behind it with a stronger blur directly
/// behind the popup's content, to make it easier to read.
/// 
/// Takes in a required popUpController (from the popUpController mixin)
/// and popUpContent, which is the main content shown in the popup.
/// 
/// The popup will close if the user clicks anywhere outside the popup's content.
class PopUp extends StatefulWidget {

  final AnimationController popUpController;

  /// Widgets that will be shown above the blur layer, as part of the pop up.
  final Widget popUpContent;

  const PopUp({
    super.key,

    required this.popUpController,
    required this.popUpContent
  });

  @override
  PopUpState createState() => PopUpState();

}


class PopUpState extends State<PopUp> with TickerProviderStateMixin, OpacityAnimationMixin {

  // Animations. 
    // Blur animations
    late final Animation screenBlurAnimation = Tween<double>(
      begin: 0,
      end: 5
    ).animate(CurvedAnimation(
      parent: widget.popUpController,
      curve: AnimationCurves.blur
    ));

    late final Animation popUpBackgroundBlurAnimation = Tween<double>(
      begin: 0,
      end: 12.5
    ).animate(CurvedAnimation(
      parent: widget.popUpController,
      curve: AnimationCurves.blur
    ));

    // Opacity Animation. We override it so we can set the curve to match the blur animations
    // so they all sync up.
    @override
    Animation<double> get opacityAnimation => Tween<double>(
      begin: 0,
      end: 1
    ).animate(CurvedAnimation(
      parent: widget.popUpController,
      curve: AnimationCurves.popupOpacity
    ));

  
  final GlobalKey _contentKey = GlobalKey();

  double? contentWidth;
  double? contentHeight;


  @override
  void initState() {
    super.initState();

    // Evaluates contentWidth and contentHeight based on the
    // size of popupContent, so the stronger blur can be
    // sized correctly behind the popupContent.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _contentKey.currentContext;
      if(context != null) {
        final size = context.size;
        if(size != null) {
          setState(() {
            contentWidth = size.width;
            contentHeight = size.height;
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        screenBlurAnimation,
        popUpBackgroundBlurAnimation,
        opacityAnimation
      ]),
      builder: (context, child) {

        if (contentWidth == null) SizedBox();

        return IgnorePointer(
          ignoring: widget.popUpController.value == 0,
          child: SizedBox.expand(
            child: Stack(
              children: [
                // Application wide milder blur
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: screenBlurAnimation.value, sigmaY: screenBlurAnimation.value),
                  child: Container(color: PopUpColors.appWideBlur),
                ),
          
                GestureDetector(
                  onTap: () => widget.popUpController.reverse(),
                ),
                
                // Pop up content and stronger blur for the area behind the pop up.
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.5),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pop up background stronger blur.
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: popUpBackgroundBlurAnimation.value, sigmaY: popUpBackgroundBlurAnimation.value),

                          // We have to add another opacity here, or else the popup content,
                          // that is required to size the blur behind it, will always be visible.
                          child: Opacity(
                            opacity: opacityAnimation.value,
                            child: Container(
                              width: contentWidth,
                              height: contentHeight,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                                
                        // Pop Up.
                        Opacity(
                          opacity: opacityAnimation.value,
                          child: Container(
                            key: _contentKey,
                            decoration: BoxDecoration(
                              color: PopUpColors.background,
                              border: Border.all(
                                color: PopUpColors.frame,
                                width: 3
                              ),
                              borderRadius: BorderRadius.circular(25)
                            ),
                            child: widget.popUpContent,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

}