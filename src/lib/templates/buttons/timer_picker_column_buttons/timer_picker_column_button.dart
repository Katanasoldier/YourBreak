import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/animation_constants.dart';

import 'package:yourbreak/models/timer_structure.dart';
import 'package:yourbreak/templates/base_mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/buttons/button_base.dart';

import 'package:yourbreak/templates/buttons/timer_picker_column_buttons/action_option_button.dart';
import 'package:yourbreak/templates/buttons/square_button/headers.dart';
//import 'package:auto_size_text/auto_size_text.dart';

const double defaultWidgetMargin = 2.5;


/// Formats the passed period name to a more user-friendly format.
/// For example:
/// - "work" becomes "Work"
/// - "shortBreak" becomes "Break"
/// - "longBreak" becomes "Rest"
String formatPeriodName(String periodName){
  switch(periodName){
    case 'work':
      return 'Work';
    case 'shortBreak':
      return 'Break';
    case 'longBreak':
      return 'Rest';
    default:
      return periodName;
  }
}

/// Capitalizes the first letter of the passed string and returns it.
String capitalize(String string){
  return string[0].toUpperCase() + string.substring(1);
}

/// Returns the color associated with the passed period name.
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

/// Formats time given in seconds into a easy to read format.
/// Takes in an integer representing seconds and returns a string of the format:
/// - "Xm Ys" if the time is more than 60 seconds, where X is the number of minutes and Y is the number of seconds.
/// - "Xs" if the time is less than 60 seconds, where X is the number of seconds.
String formatSeconds(int seconds) {

  if (seconds >= 60) {

    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    return remainingSeconds == 0
      ? '${minutes}m'
      : '${minutes}m ${remainingSeconds}s';
  }

  return '${seconds}s';

}


/// A button widget that is meant to be only used inside a TimerPickerColumn.
/// 
/// It is meant to be used for displaying timers in the form a button inside a TimerPickerColumn.
/// For the animations it will slightly scale up on hover, and grow down revealing info about the timer such as:
/// - Pattern
/// - Complexity
/// - Total Time
/// 
/// The pattern time periods are colored based on their type (work, short break, long break),
/// Renames short break to break, and long break to rest, so that it is more user friendly.
/// 
/// It also has a header with the timer name at the very top, which is visible even without actively hovering over it,
/// and a gradient for the main text.
/// 
/// Optionally it can contain edit buttons, which can be used for specific actions:
/// - Edit: Opens an editing page for the timer
/// - Delete: Deletes the timer
/// 
/// It has a fixed height and width, which are set by the TimerPickerColumn.
class TimerPickerColumnButton extends StatefulWidget {
  

  final TimerStructure timer;

  final List<Color>? mainTextGradient;

  final VoidCallback onPressed;
  
  final double listElementHeight;
  final double listElementWidth;
  
  final bool? editButtons;

  final AnimationController pageAnimationController;


  const TimerPickerColumnButton({

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
  TimerPickerColumnButtonState createState() => TimerPickerColumnButtonState();

}

class TimerPickerColumnButtonState extends State<TimerPickerColumnButton> with TickerProviderStateMixin, InteractiveAnimationsMixin {


  late final double originalButtonWidth = widget.listElementWidth;
  late final double originalButtonHeight = widget.listElementHeight;


  late final Animation<double> hoverGrowAnimation = 
    Tween<double>(
      begin: widget.listElementHeight,
      end: widget.editButtons!=null
        // If edit buttons are enabled, the button will grow down a bit more to fit them in.
        // The formula is:
        // `listElementHeight * 3 + originalButtonHeight * 0.075 + (listElementWidth * 0.025)*3 + originalButtonHeight * 0.8`
        // where:
        // - `listElementHeight * 3` is the height of the button when it is fully expanded (without edit buttons)
        // - `originalButtonHeight * 0.075` is the height of the divider
        // - `(listElementWidth * 0.025)*3` is the width of the bottom border, plus the bottom padding * 2
        // - `originalButtonHeight * 0.8` is the height of the edit buttons
        ?widget.listElementHeight * 3 + originalButtonHeight * 0.075 + widget.listElementWidth * 0.025 * 3 + originalButtonHeight * 0.8
        :widget.listElementHeight * 3
    ).animate(CurvedAnimation(
      parent: hoverController,
      curve: AnimationCurves.hover
    )
  );


  // This bool decides whether to give the pattern data column a right padding,
  // because the scrollbar takes up space, and without the padding it would overlap the content
  bool isPatternOverflowing = false;

  final ScrollController scrollController = ScrollController();

  // Checks if the pattern data column is overflowing, and updates isPatternOverflowing accordingly.
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
  void initState() {

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(_checkPatternOverflow);
      _checkPatternOverflow();
    });

  }

  @override
  void dispose() {

    scrollController.removeListener(_checkPatternOverflow);

    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      onPressed: null,

      rebuildListeners: [
        hoverController,
        clickController,
      ],

      mouseRegionBasedControllers: [
        hoverController,
      ],

      scaleAnimations: [
        hoverSizeAnimation,
        clickSizeAnimation,
      ],

      child: AnimatedBuilder(
        animation: hoverGrowAnimation,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: defaultWidgetMargin * 2, horizontal: defaultWidgetMargin * 5),
            child: SizedBox(
              height: hoverGrowAnimation.value,
              width: widget.listElementWidth,
              child: LayoutBuilder(
                builder: (context, constraints) {
              
                  final double maxButtonWidth = constraints.maxWidth;
                  final double maxButtonHeight = constraints.maxHeight;
                    
                    
                  final double mainTextFontSize = originalButtonWidth * 0.11;
                    
                  final double dataHeaderFontSize = originalButtonWidth * 0.065;
                  final double dataFontSize = originalButtonWidth * 0.09;
                              
                    
                  final double borderWidth = maxButtonWidth * 0.025;
                    
                  final double topPadding = borderWidth;

                  // When edit buttons are enabled, having 2x padding makes them look too small.
                  final double bottomPadding = (widget.editButtons == null) ? borderWidth * 2 : borderWidth;

                  final double sidePadding = borderWidth*2;


                  final double dividerHeight = originalButtonHeight * 0.075;
              
                    
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      OutlinedButton(
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
                                child: SingleChildScrollView( // To prevent overflow when hoverSizeAnimation is active.
                                  child: Column(
                                    children: [
                                      Container(
                                        width: originalButtonWidth * 0.75,
                                        height: dividerHeight,
                                        decoration: BoxDecoration(
                                          color: PureColors.grey,
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                      ),
                                      SizedBox(
                                        height: (originalButtonHeight * 3) - originalButtonHeight - (dividerHeight),
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
                                                          controller: scrollController,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              for(final timerPeriod in widget.timer.pattern)
                                                              Padding(
                                                                padding: !isPatternOverflowing
                                                                  ? EdgeInsets.only(top: 2, right: 6)
                                                                  : EdgeInsets.zero,
                                                                child: Text(
                                                                  // Displays the info in the following format: "Minutesm Secondss: Period Name"
                                                                  '${formatSeconds(timerPeriod.periodTime)}: ${formatPeriodName(timerPeriod.periodType.name.toString())}',
                                                                  style: TextStyle(
                                                                    fontSize: dataHeaderFontSize,
                                                                    fontWeight: FontWeight.w700,
                                                                    height: 0.92,
                                                                    color: getPeriodColor(timerPeriod.periodType.name.toString())
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
                                                              capitalize(widget.timer.complexity.name.toString()),
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
                                                              formatSeconds(widget.timer.totalTime),
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
                                          height: dividerHeight,
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
                                                    child: TimerActionButton(
                                                      text: "Edit",
                                                      color: PureColors.orange,
                                                      fontSize: dataFontSize,
                                                      borderRadius: maxButtonHeight * 0.05,
                                                      borderWidth: borderWidth/2,
                                                      onPressed: null,
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
                                                    child: TimerActionButton(
                                                      text: "Delete",
                                                      color: PureColors.red,
                                                      fontSize: dataFontSize,
                                                      borderRadius: maxButtonHeight * 0.05,
                                                      borderWidth: borderWidth/2,
                                                      onPressed: null,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}