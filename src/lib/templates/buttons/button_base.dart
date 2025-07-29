import 'package:flutter/material.dart';
import 'package:yourbreak/constants/animation_constants.dart';

/// The base class for all button widgets.
/// 
/// This class is designed to be extended by other button widgets, allowing them to
/// use the same structure and functionality without having to rewrite the same code.
/// 
/// It provides a standardized structure that includes a:
/// - MouseRegion
/// - GestureDetector
/// That are all wrapped in a AnimationBuilder, that rebuilds based on the provided [rebuildListeners].
/// 
/// You can also provide a list of [AnimationController]s that will be forwarded or reversed based on
/// MouseRegion events that are already handled by this widget.
/// 
/// You can also provide a list of [Animation]s whose values will be used to adjust the button's scale in Transform.scale.
/// 
/// It also contains a click function, that on click, locks the hover events for a short time, to prevent
/// rapid clicking of the button. After the short time, the hover events are unlocked again,
/// and the hover and click controllers are reset to their initial state.
class ButtonBase extends StatefulWidget {

  final Widget child;
  final Function? onPressed;

  /// List of [Listenable]s that will trigger a rebuild of the widget when their value changes.
  final Iterable<Listenable> rebuildListeners;

  /// List of [AnimationController]s that will be forwarded or reversed based on
  /// [MouseRegion]'s onEnter and onExit events.
  final List<AnimationController> mouseRegionBasedControllers;

  /// List of [Animation]s which values will be used to adjust the button's scale in Transform.scale.
  final List<Animation> scaleAnimations;

  final AnimationController? hoverController;
  final AnimationController? clickController;
  
  /// Prevents the hoverController and other MouseRegion based controllers from
  /// triggering on MouseRegion events after the button has been clicked.
  bool lockHover = false;

  /// Allows for the disabling of the click function, which when
  /// true, doesn't lock the hover events, doesn't call onPressed
  /// and doesn't reset the hover and click controllers.
  /// 
  /// The button will still try to call onPressed, if provided with it.
  /// This is useful for buttons that don't need the predefined click hehavior.
  bool disableClick = false;


  ButtonBase({
    super.key,

    required this.child,
    required this.onPressed,

    required this.rebuildListeners,
    required this.mouseRegionBasedControllers,

    this.scaleAnimations = const [], // Prevents transform.scale from breaking during runtime, if no list is passed.

    this.hoverController,
    this.clickController,

    this.lockHover = false,
    this.disableClick = false
  });


  @override
  ButtonBaseState createState() => ButtonBaseState();
}


class ButtonBaseState extends State<ButtonBase>{

  /// Provides the default click behavior for all buttons.
  /// 
  /// It cannot be added directly in [GestureDetector]'s onTapUp, because it expects
  /// a synchronous function, and the click behavior is asynchronous.
  /// So to solve the problem, we wrap this function in a synchronous function inside
  /// [GestureDetector]'s onTapUp event.
  void defaultClickBehavior() async {
              
    setState(() {
      widget.lockHover = true;
    });


    if(mounted){
      widget.onPressed?.call();
    }

    // await to prevent rapid button clicking.
    await Future.delayed(AnimationDurations.pageTransition);

    // Unlock the MouseRegion events.
    setState(() {
      widget.lockHover = false;
    });

    // Reset the hover and click controllers to their initial state.

    widget.hoverController?.reverse();


    widget.clickController?.reverse();
        
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(widget.rebuildListeners),
      builder:(context, child) =>
      Transform.scale(
        // Multiplies each scaleAnimations animation's value together to get the final scale.
        scale: widget.scaleAnimations.fold(1.0, (value, animation) => value! * animation.value),
        child: MouseRegion(
        
          onEnter: (_) {
            if (!widget.lockHover) {
              for (final AnimationController controller in widget.mouseRegionBasedControllers) {
                controller.forward();
              }
            }
          },
        
          onExit: (_) {
            if (!widget.lockHover) {
              for (final AnimationController controller in widget.mouseRegionBasedControllers) {
                controller.reverse();
              }
            }
          },
        
          child: GestureDetector(
            
            onTapDown: (_) => widget.clickController?.forward(),
            onTapCancel: () => widget.clickController?.reverse(),
        
            onTapUp: !widget.disableClick
              ? (_) {
                defaultClickBehavior();
              }
              : (_) {
                widget.onPressed?.call();
              },
        
            child: widget.child,
          ),
        ),
      ),
    );
  }
}