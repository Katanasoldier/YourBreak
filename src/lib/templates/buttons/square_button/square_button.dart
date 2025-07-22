import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yourbreak/templates/buttons/square_button/headers.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/animation_constants.dart';
//import 'package:auto_size_text/auto_size_text.dart';



class SquareButton extends StatefulWidget {
  
  final String mainText;
  final String? supportText;
  final String? description;

  final double? fontMultiplier;

  final List<Color>? mainTextGradient;

  final bool? invertTextOrder;

  final String? iconName;
  final bool? imageFillScreen;

  final VoidCallback onPressed;

  final double? borderWidthMultiplier;
  final double? borderRadiusMultiplier;

  final double? aspectRatio;

  final double? hoverSize;

  final AnimationController pageAnimationController;

  //final ButtonController controller = ButtonController();

  const SquareButton({

    super.key,

    required this.mainText,
    this.supportText,
    this.description,

    this.fontMultiplier,

    this.mainTextGradient,

    this.invertTextOrder,

    this.iconName,
    this.imageFillScreen,

    required this.onPressed,

    this.borderWidthMultiplier,
    this.borderRadiusMultiplier,

    this.aspectRatio,

    this.hoverSize,

    required this.pageAnimationController
  });

  @override
  SquareButtonState createState() => SquareButtonState();

}

class SquareButtonState extends State<SquareButton> with TickerProviderStateMixin {


  bool lockHover = false;


  late AnimationController _hoverController = AnimationController(
    vsync: this,
    duration: AnimationDurations.hover,
    reverseDuration: AnimationDurations.hover
  );

  late final AnimationController _clickController = AnimationController(
    vsync: this,
    duration: AnimationDurations.click,
    reverseDuration: AnimationDurations.click
  );



  late final Animation<Offset> _mainTextSlideAnimation = 
    Tween<Offset>(
      begin: Offset(0, 0),//0.1),
      end: widget.supportText != null ? (widget.invertTextOrder == true ? Offset(0, 0.323) : Offset(0, -0.323)) : Offset(0,0)//-0.3)
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: AnimationCurves.hover
    )
  );

  late final Animation<Offset> _supportTextSlideAnimation = 
    Tween<Offset>(
      begin: widget.invertTextOrder == true ? Offset(0, -4) : Offset(0, 4),//0.6),
      end: widget.invertTextOrder == true ? Offset(0, -0.77) : Offset(0, 0.77)//0.1)
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: AnimationCurves.hover //Curves.easeOutCubic
    )
  );


  late final Animation<double> _buttonHoverSizeAnimation =
    Tween<double>(
      begin: 1.0,
      end: widget.hoverSize ?? 1.075
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: AnimationCurves.hover
    )
  );

  late final Animation<double> _buttonClickSizeAnimation = 
    Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _clickController,
      curve: AnimationCurves.click,
    )
  );

  late final Animation<double> _pageButtonSizeAnimation =
    Tween<double>(
      begin: 1,
      end: 0.5
    ).animate(CurvedAnimation(
      parent: widget.pageAnimationController,
      curve: AnimationCurves.pageTransition
    )
  );

  late final Animation<double> _pageButtonOpacityAnimation = 
    Tween<double>(
      begin: 1,
      end: 0.0
    ).animate(CurvedAnimation(
      parent: widget.pageAnimationController,
      curve: AnimationCurves.opacity
    )
  );



  @override
  void initState() {

    super.initState();

    _hoverController.reverse();

    _clickController.reverse();

  }

  @override
  void dispose() {

    _hoverController.dispose();

    _clickController.dispose();

    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_buttonHoverSizeAnimation, _buttonClickSizeAnimation, _pageButtonSizeAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: _pageButtonOpacityAnimation.value,
          child: Transform.scale(
            scale: _buttonHoverSizeAnimation.value * _buttonClickSizeAnimation.value * _pageButtonSizeAnimation.value,
            child: AspectRatio(
              aspectRatio: widget.aspectRatio ?? 1.0,
              child: LayoutBuilder(
                builder: (context, constraints) {
              
                  final double maxButtonWidth = constraints.maxWidth;
                  final double maxButtonHeight = constraints.maxHeight;
              
              
                  final double imageSize = (widget.imageFillScreen == true ? maxButtonWidth : maxButtonWidth * 0.85);
              
                  final double mainTextFontSize = maxButtonHeight * 0.22 * (widget.fontMultiplier ?? 1);
                  final double supportTextFontSize = maxButtonHeight * 0.14 * (widget.fontMultiplier ?? 1);
              
              
                  return MouseRegion(
                    onEnter: (_) {
                      if (!lockHover) _hoverController.forward();
                    },
                    onExit: (_) {
                      if (!lockHover) _hoverController.reverse();
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTapDown: (_) => _clickController.forward(),
                          onTapUp: (_) async {

                            setState(() {
                              lockHover = true;
                            });
                            _hoverController.forward();


                            await _clickController.forward();
              
                            if(mounted){
                              widget.onPressed.call();
                            }

                            await Future.delayed(const Duration(milliseconds: 500));

                            setState(() {
                              lockHover = false;
                            });
                            _hoverController.reverse();

                            _clickController.reverse();

                          },
                          onTapCancel: () => _clickController.reverse(),
                          child: OutlinedButton(
                            onPressed: null,
                            clipBehavior: Clip.hardEdge,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(maxButtonHeight * 0.12 * (widget.borderRadiusMultiplier ?? 1)),
                              ),
                              padding: EdgeInsets.all(0),
                              side: BorderSide(
                                color: SquareButtonColors.border,
                                width: (maxButtonWidth * 0.025) * (widget.borderWidthMultiplier ?? 1),
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: Colors.transparent,
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: widget.imageFillScreen == true ? const EdgeInsets.all(0.0) : const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/svg/${widget.iconName}.svg',
                                      width: imageSize,
                                      height: imageSize,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Headers(
                                    mainText: widget.mainText,
                                    supportText: widget.supportText,
                                    
                                    mainTextFontSize: mainTextFontSize,
                                    supportTextFontSize: supportTextFontSize,
                                  
                                    invertTextOrder: widget.invertTextOrder,
                                  
                                    mainTextGradient: widget.mainTextGradient,
                                  
                                    mainTextSlideAnimation: _mainTextSlideAnimation,
                                    supportTextSlideAnimation: _supportTextSlideAnimation,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        if(widget.description!=null)
                        Positioned(
                          bottom: -33,
                          child: Text(
                            widget.description!,
                            style: TextStyle(
                              color: SquareButtonColors.description,
                              fontSize: maxButtonWidth * 0.077,
                              fontWeight: FontWeight.w400,
                              height: 1.07
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}