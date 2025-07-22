import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/animation_constants.dart';

import 'package:yourbreak/models/timer_structure.dart';

import 'package:yourbreak/templates/timer_picker_components/action_option_button.dart';
import 'package:yourbreak/templates/buttons/square_button/headers.dart';
//import 'package:auto_size_text/auto_size_text.dart';

const double defaultWidgetMargin = 2.5;


String replacePeriodName(String periodName){
  switch(periodName){
    case 'work':
      return 'Work';
    case 'shortBreak':
      return 'Break';
    case 'longBreak':
      return 'Rest';
    case 'simple':
      return 'Simple'; 
    case 'complex':
      return 'Complex';
    default:
      return periodName;
  }
}

Color getPeriodColor(String periodName){
  switch(periodName){
    case 'work':
      return PureColors.orange;
    case 'shortBreak':
      return PureColors.green;
    case 'longBreak':
      return PureColors.blue;
    default:
      return PureColors.white;
  }
}



class ColumnButton extends StatefulWidget {
  
  final TimerStructure timer;

  final List<Color>? mainTextGradient;

  final VoidCallback onPressed;
  
  final double listElementHeight;
  final double listElementWidth;
  
  final bool? editButtons;

  final AnimationController pageAnimationController;

  //final ButtonController controller = ButtonController();

  const ColumnButton({

    super.key,

    required this.timer,

    this.mainTextGradient,

    required this.onPressed,

    required this.listElementHeight,
    required this.listElementWidth,

    this.editButtons,

    required this.pageAnimationController
  });

  @override
  ColumnButtonState createState() => ColumnButtonState();

}

class ColumnButtonState extends State<ColumnButton> with TickerProviderStateMixin {


  late final double originalButtonWidth = widget.listElementWidth;
  late final double originalButtonHeight = widget.listElementHeight;

  final ScrollController scrollController = ScrollController();


  bool lockHover = false;

  bool isPatternOverflowing = false; // This bool decides wether to give the pattern data column a right padding, because the scrollbar takes up space, and without the padding it would overlap the content



  late final AnimationController pageAnimationController = AnimationController(
    vsync: this,
    duration: AnimationDurations.pageTransition,
    reverseDuration: AnimationDurations.pageTransition,
  );



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



  late final Animation<double> _buttonHoverSizeAnimation =
    Tween<double>(
      begin: 1.0,
      end: 1.05
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: AnimationCurves.hover
    )
  ); 

  late final Animation<double> _buttonHoverGrowAnimation = 
    Tween<double>(
      begin: widget.listElementHeight,
      end: widget.editButtons!=null
        ?widget.listElementHeight * 3 + originalButtonHeight * 0.075 + (widget.listElementWidth * 0.025)*3 + originalButtonHeight * 0.8
        :widget.listElementHeight * 3
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


    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(_checkPatternOverflow);
      _checkPatternOverflow();
    });

  }

  @override
  void dispose() {

    scrollController.removeListener(_checkPatternOverflow);


    _hoverController.dispose();

    _clickController.dispose();

    super.dispose();

  }


  void _checkPatternOverflow() {
    if (!scrollController.hasClients) return;
    final overflow = scrollController.hasClients && scrollController.position.maxScrollExtent > 0.0;
    if(overflow != isPatternOverflowing) {
      setState(() {
        isPatternOverflowing = overflow;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_buttonHoverSizeAnimation, _buttonClickSizeAnimation, _pageButtonSizeAnimation]),
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: defaultWidgetMargin * 2, horizontal: defaultWidgetMargin * 5),
          child: SizedBox(
            height: _buttonHoverGrowAnimation.value,
            width: widget.listElementWidth,
            child: Opacity(
              opacity: _pageButtonOpacityAnimation.value,
              child: Transform.scale(
                scale: _buttonHoverSizeAnimation.value * _buttonClickSizeAnimation.value * _pageButtonSizeAnimation.value,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                
                    final double maxButtonWidth = constraints.maxWidth;
                    final double maxButtonHeight = constraints.maxHeight;


                    final double mainTextFontSize = originalButtonWidth * 0.11;

                    final double dataHeaderFontSize = originalButtonWidth * 0.065;
                    final double dataFontSize = originalButtonWidth * 0.09;
              

                    final double borderWidth = maxButtonWidth * 0.025;

                    final double topPadding = borderWidth;
                    final double bottomPadding = (widget.editButtons == null) ? borderWidth * 2 : borderWidth; // When edit buttons are enabled, having 2x padding makes it look kind of awkward
                    final double sidePadding = borderWidth*2;
                

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
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)
                                  ),
                                ),
                                side: WidgetStateProperty.all(
                                  BorderSide(
                                    color: SquareButtonColors.border,
                                    width: borderWidth,
                                    strokeAlign: BorderSide.strokeAlignInside,
                                  ),
                                ),
                                animationDuration: Duration.zero,
                                padding: WidgetStateProperty.all(EdgeInsets.zero),
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: WidgetStateProperty.all(Colors.transparent)
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: originalButtonWidth,
                                    height: originalButtonHeight,
                                    child: Headers(
                                      mainText: widget.timer.name,
                                      mainTextFontSize: mainTextFontSize,                
                                      mainTextGradient: widget.mainTextGradient,
                                    ),
                                  ),
                                  Expanded(
                                    child: Transform.translate(
                                      offset: Offset(0, -2),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: originalButtonWidth * 0.75,
                                            height: originalButtonHeight * 0.075,
                                            decoration: BoxDecoration(
                                              color: PureColors.grey,
                                              borderRadius: BorderRadius.circular(20)
                                            ),
                                          ),
                                          SizedBox(
                                            height: (originalButtonHeight * 3) - originalButtonHeight - (originalButtonHeight * 0.075),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: topPadding,
                                                left: sidePadding,
                                                right: sidePadding,
                                                bottom: bottomPadding,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(bottom: 2),
                                                          child: Text(
                                                            'Pattern',
                                                            style: TextStyle(
                                                              fontSize: dataHeaderFontSize,
                                                              fontWeight: FontWeight.w400,
                                                              height: 0.92,
                                                              color: PureColors.grey
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          //width: maxButtonWidth / 2,
                                                          child: RawScrollbar(
                                                            thickness: 3,
                                                            interactive: true,
                                                            minOverscrollLength: 5,
                                                            thumbColor: PureColors.white,
                                                            trackColor: Colors.transparent,
                                                            trackBorderColor: Colors.transparent,
                                                            trackVisibility: false,
                                                            radius: Radius.circular(4),
                                                            thumbVisibility: true,
                                                            controller: scrollController,
                                                            child: SingleChildScrollView(
                                                              physics: BouncingScrollPhysics(),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  for(final timerPeroid in widget.timer.pattern)
                                                                  Padding(
                                                                    padding: !isPatternOverflowing
                                                                      ? EdgeInsets.only(top: 2, right: 6)
                                                                      : EdgeInsets.zero,
                                                                    child: Text(
                                                                      '${(timerPeroid.periodTime / 60).toInt().toString()}min: ${replacePeriodName(timerPeroid.periodType.name.toString())}',
                                                                      style: TextStyle(
                                                                        fontSize: dataHeaderFontSize,
                                                                        fontWeight: FontWeight.w700,
                                                                        height: 0.92,
                                                                        color: getPeriodColor(timerPeroid.periodType.name.toString())
                                                                      ),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(bottom: 2),
                                                                child: Text(
                                                                  'Complexity',
                                                                  style: TextStyle(
                                                                    fontSize: dataHeaderFontSize,
                                                                    fontWeight: FontWeight.w400,
                                                                    height: 0.92,
                                                                    color: PureColors.grey
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  replacePeriodName(widget.timer.complexity.name.toString()),
                                                                  style: TextStyle(
                                                                    fontSize: dataFontSize,
                                                                    fontWeight: FontWeight.w700,
                                                                    height: 0.92,
                                                                    color: PureColors.white
                                                                  ),
                                                                  textAlign: TextAlign.center
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(bottom: 2),
                                                                child: Text(
                                                                  'Total Time',
                                                                  style: TextStyle(
                                                                    fontSize: dataHeaderFontSize,
                                                                    fontWeight: FontWeight.w400,
                                                                    height: 0.92,
                                                                    color: PureColors.grey
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '${(widget.timer.totalTime/60).toInt().toString()}min',
                                                                  style: TextStyle(
                                                                    fontSize: dataFontSize,
                                                                    fontWeight: FontWeight.w700,
                                                                    height: 0.92,
                                                                    color: PureColors.white
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          if(widget.editButtons != null) ...[
                                            Container(
                                              width: originalButtonWidth * 0.75,
                                              height: originalButtonHeight * 0.075,
                                              decoration: BoxDecoration(
                                                color: PureColors.grey,
                                                borderRadius: BorderRadius.circular(20)
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: topPadding,
                                                left: sidePadding,
                                                right: sidePadding,
                                                bottom: bottomPadding,
                                              ),
                                              child: SizedBox(
                                                height: originalButtonHeight * 0.8,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                          top: topPadding/2,
                                                          left: sidePadding,
                                                          right: sidePadding/2,
                                                          bottom: bottomPadding/3
                                                        ),
                                                        child: ButtonActionOption(
                                                          text: "Edit",
                                                          color: PureColors.orange,
                                                          fontSize: dataFontSize,
                                                          borderRadius: maxButtonHeight * 0.05,
                                                          borderWidth: borderWidth/2,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                          top: topPadding/2,
                                                          left: sidePadding/2,
                                                          right: sidePadding,
                                                          bottom: bottomPadding/3
                                                        ),
                                                        child: ButtonActionOption(
                                                          text: "Delete",
                                                          color: PureColors.red,
                                                          fontSize: dataFontSize,
                                                          borderRadius: maxButtonHeight * 0.05,
                                                          borderWidth: borderWidth/2,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ]
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}