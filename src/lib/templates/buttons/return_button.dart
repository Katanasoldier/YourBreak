import 'package:flutter/material.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';

class ReturnButton extends StatefulWidget {

  final AnimationController pageAnimationController;


  const ReturnButton({

    super.key,

    required this.pageAnimationController,

  });


  @override
  State<StatefulWidget> createState() => ReturnButtonState();

}

class ReturnButtonState extends State<ReturnButton> with TickerProviderStateMixin {


  bool _exiting = false;
  
  Animation<Offset> get _activeSlideAnimation =>
      _exiting ? _exitSlideAnimation : _enterSlideAnimation;



  late final AnimationController _hoverController = 
  AnimationController(
    vsync: this,
    duration: AnimationDurations.hover,
    reverseDuration: AnimationDurations.hover,
  );

  late final AnimationController _clickController = 
  AnimationController(
    vsync: this,
    duration: AnimationDurations.click,
    reverseDuration: AnimationDurations.click,
  );

  late final AnimationController _enterSlideController = 
  AnimationController(
    vsync: this,
    duration: AnimationDurations.pageTransition,
    reverseDuration: AnimationDurations.pageTransition,
  );



  late final Animation<double> _hoverSizeAnimation = 
  Tween<double>(
    begin: 0.975,
    end: 1.1,
  ).animate(CurvedAnimation(
    parent: _hoverController,
    curve: AnimationCurves.hover,
  ));

  late final Animation<double> _hoverOpacityAnimation = 
  Tween<double>(
    begin: 0.4,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _hoverController,
    curve: AnimationCurves.opacity,
  ));


  late final Animation<Offset> _enterSlideAnimation =
  Tween<Offset>(
    begin: const Offset(0, 4),
    end: const Offset(0, 0),
  ).animate(CurvedAnimation(
    parent: _enterSlideController,
    curve: AnimationCurves.slideInOutPage,
  ));

  late final Animation<Offset> _exitSlideAnimation =
  Tween<Offset>(
    begin: const Offset(0, 0),
    end: const Offset(0, 4),
  ).animate(CurvedAnimation(
    parent: widget.pageAnimationController,
    curve: AnimationCurves.slideInOutPage,
  ));



  @override
  void initState() {

    super.initState();

    _hoverController.reverse();
    _clickController.reverse();
    _enterSlideController.forward();

  }

  @override
  void dispose() {

    _hoverController.dispose();
    _clickController.dispose();
    _enterSlideController.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(

      animation: Listenable.merge([
        _hoverController,
        _clickController,
        _enterSlideController,
        widget.pageAnimationController,
      ]),

      builder: (context, child) {

        return Transform.translate(
          offset: Offset(
            0,
            _activeSlideAnimation.value.dy * MediaQuery.of(context).size.height,
          ),
          child: Transform.scale(
            scale: _hoverSizeAnimation.value,
            child: LayoutBuilder(
              builder: (context, constraints) {

                final double maxSize = constraints.maxWidth;

                return MouseRegion(
                  onEnter: (_) => _hoverController.forward(),
                  onExit: (_) => _hoverController.reverse(),
                  child: Opacity(
                    opacity: _hoverOpacityAnimation.value,
                    child: OutlinedButton(
                      clipBehavior: Clip.hardEdge,
                      onPressed: () => _clickController.forward(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(maxSize * 0.07),
                        ),
                        padding: EdgeInsets.zero,
                        side: BorderSide(
                          color: ReturnButtonColors.border,
                          width: maxSize * 0.015,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: Colors.transparent,
                      ),
                      child: InkWell(
                        onTap: () async {

                          setState(() => _exiting = true);

                          await widget.pageAnimationController.forward();

                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                          
                        },
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: IgnorePointer(
                          child: Center(
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                fontSize: maxSize * 0.125,
                                color: ReturnButtonColors.mainText,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}