import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/animation_constants.dart';

import 'package:yourbreak/models/timer_structure.dart';
import 'package:yourbreak/templates/basic_divider.dart';

import 'package:yourbreak/templates/mixins/interactive_animations_mixin.dart';

import 'package:yourbreak/helper/timer_formatters.dart';

import 'package:yourbreak/templates/generic_buttons/button_base.dart';
import 'package:yourbreak/templates/timer_picker_components/timer_picker_column_buttons/timer_action_button.dart';
import 'package:yourbreak/templates/generic_buttons/square_button/headers.dart';

import 'package:yourbreak/pages/timer_management_pages/timer_creation_pages/timer_creator.dart';
//import 'package:auto_size_text/auto_size_text.dart';

const double defaultWidgetMargin = 2.5;

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
/// It takes in a required onPressed with a buttonState passed as a parameter. The buttonState is just this button's state.
/// 
/// Optionally it can contain edit buttons, which can be used for specific actions:
/// - Edit: Opens an editing page for the timer
/// - Delete: Deletes the timer
/// 
/// It has a fixed height and width, which are set by the TimerPickerColumn.
class TimerPickerColumnButton extends StatefulWidget {
  

  final TimerStructure timer;

  final List<Color>? mainTextGradient;

  final Function onPressed;
  
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

  // A copy for the state, so when the state is passed in a function, the function can still access the timer.
  late final TimerStructure timer = widget.timer;


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
  // Meant to adjust whether the pattern column should have a padding, because:
  // If there is no scrollbar, the text can take up the whole width of the column.
  // If there is a scrollbar, the text cannot take up the whole width of the column
  // or else it'll flow onto the scrollbar, ending up in a bad look.
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
      // Pass itself (state) as an argument.
      // This allows functions to use each button seperately and implement unique outcomes.
      // For example, it can be used in a function where it is supposed to push a TimerCreator
      // that opens with a preexistingTimer. With this, each button can change the outcome of a button
      // with itself, allowing for example the editing of existing timers.
      onPressed: () => widget.onPressed(this),

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
                                      BasicDivider(
                                        width: originalButtonWidth * 0.75,
                                        height: dividerHeight,
                                        color: PureColors.grey,
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
                                              Expanded( // Pattern column
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
                                              Expanded( // Side info, complexity, totalTime.
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
                                      // Action buttons. (edit, delete)
                                      if(widget.editButtons != null) ...[
                                        BasicDivider(
                                          width: originalButtonWidth * 0.75,
                                          height: dividerHeight,
                                          color: PureColors.grey,
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
                                                      onPressed: () {
                                                        Navigator.push(context, MaterialPageRoute(
                                                          builder: (context) => TimerCreator(preexistingTimer: timer,)
                                                        ));
                                                      },
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
                                                      onPressed: () => timer.delete()
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