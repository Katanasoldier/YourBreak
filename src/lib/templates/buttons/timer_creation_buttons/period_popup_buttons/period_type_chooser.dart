import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';

import 'package:yourbreak/helper/timer_formatters.dart';

import 'package:yourbreak/models/timer_structure.dart';



/// A widget to be used only within the New Period popup.
/// Allows to pick between 3 types of a time Period:
/// - work
/// - shortBreak (break)
/// - longBreak (rest)
/// 
/// Can take in an optional preexistingPeriod, that when passed, the
/// widget will set the currentType to match the preexistingPeriod's.
/// 
/// Contains a selectionBox that animates towards the selected (clicked)
/// type to make it look selected.
/// 
/// Contains a reset() that should be called when refreshing the popup
/// containing this widget.
class TimerTypeChooser extends StatefulWidget {

  final TimerPeriod? preexistingPeriod;

  const TimerTypeChooser({
    super.key,

    this.preexistingPeriod    
  });

  @override
  TimerTypeChooserState createState() => TimerTypeChooserState();

}


class TimerTypeChooserState extends State<TimerTypeChooser> with SingleTickerProviderStateMixin {

  // Keys section.

  final GlobalKey<TypeTextState> selectionBox = GlobalKey<TypeTextState>();


  // currentType can only be one of the below: work, break or restKey.
  // It holds the current selected work type's key.
  late GlobalKey<TypeTextState> currentType;

  // A map of all the type keys.
  final Map<String, GlobalKey<TypeTextState>> keyMap = {
    'work': GlobalKey<TypeTextState>(),
    'shortBreak': GlobalKey<TypeTextState>(),
    'longBreak': GlobalKey<TypeTextState>()
  };


  // ----------------------------------------------------------------------------
  // Functions section.

  /// Sets the passed key as the currentType (key), and animates the
  /// selectionBox to the passed key.
  void selectType(final GlobalKey<TypeTextState> selectedKey) {
    setState(() {

      currentType = selectedKey;

      WidgetsBinding.instance.addPostFrameCallback((_) {

        final BuildContext? context = currentType.currentContext;

        if (context != null) {

          final RenderBox currentTypeBox = context.findRenderObject() as RenderBox;
          final RenderBox? parentBox = context.findAncestorRenderObjectOfType<RenderBox>();

          if (parentBox != null) {

            // Gets the horizontal offset for the selectionBox.
            final centeredDx
            = currentTypeBox.localToGlobal(Offset.zero, ancestor: parentBox).dx 
              + (currentTypeBox.size.width / 2)
              - (selectionBox.currentContext!.size!.width / 2);


            // Prevent the selectionBox from reseting from the very start.

            // Track any changes, for example if once the break type was chosen,
            // and later the rest type, then instead of animating the offset from the
            // top left corner of the parent container and from a white text to blue text,
            // it instead animates from the previously calculated center horizontal offset of
            // the break type, and from break type's color to the rest type's equivalents.
            final previousOffset = selectionBoxOffset;
            final previousColor = selectionBoxColor;


            setState(() {
              selectionBoxOffset = Offset(centeredDx, 0);
              selectionBoxColor = getPeriodColor(selectedKey.currentState!.typeName);
            });


            moveSelectionBoxAnimation = Tween<Offset>(
              begin: previousOffset, // So it doesn't start from the top left corner of the parent container, but the last selected work type.
              end: selectionBoxOffset,
            ).animate(CurvedAnimation(
              parent: selectionBoxController,
              curve: Curves.fastOutSlowIn,
            ));

            colorSelectionBoxAnimation = ColorTween(
              begin: previousColor, // So it tweens from the last type's color, and not from a pure white color.
              end: selectionBoxColor
            ).animate(CurvedAnimation(
              parent: selectionBoxController,
              curve: Curves.fastOutSlowIn
            ));


            selectionBoxController.forward(from: 0);

          }
        }
      });
    });
  }

  
  /// Resets any modified state to the original values.
  /// In this case it sets the currentType back to the workKey (work type),
  /// and runs the selectType() function to animate the selectionBox back to it.
  void reset() {
    if (widget.preexistingPeriod != null) {

      // Find the first key that has the same raw typeName as the preexistingPeriod's type enum converted to a string.
      currentType = keyMap.entries.firstWhere(
        (entry) => 
          entry.key == widget.preexistingPeriod!.periodType.toString()
      ).value;

    } else {
      
      // If there is no preexiting, default to the work key.
      currentType = keyMap['work']!;

    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectType(currentType);
    });
  }


  // ----------------------------------------------------------------------------
  // Selection box section.

  late final AnimationController selectionBoxController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 350)
  );


  Offset selectionBoxOffset = Offset.zero;

  late Animation moveSelectionBoxAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: selectionBoxOffset
  ).animate(CurvedAnimation(
    parent: selectionBoxController,
    curve: Curves.fastEaseInToSlowEaseOut
  ));


  // Color subsection.

  Color selectionBoxColor = PureColors.white;

  late Animation colorSelectionBoxAnimation = ColorTween(
    begin: PureColors.white,
    end: selectionBoxColor
  ).animate(CurvedAnimation(
    parent: selectionBoxController,
    curve: Curves.fastEaseInToSlowEaseOut
  ));


  // ----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    
    // Reduces boilerplate.
    // Meant to find the currentType and animate the selectionBox towards it.
    reset();
  }

  @override
  void dispose() {
    selectionBoxController.dispose();

    super.dispose();
  }

  // ----------------------------------------------------------------------------
  // build.

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 37.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: PureColors.white.withValues(alpha: 0.75),
          width: 2
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align( // Selection Box. Align centerLeft so it starts from x 0 and properly calculates the offset for the periodType keys.
            alignment: Alignment.centerLeft,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                moveSelectionBoxAnimation,
                colorSelectionBoxAnimation
              ]),
              builder: (context, child) =>
              Transform.translate(
                key: selectionBox,
                offset: moveSelectionBoxAnimation.value,
                child: Container(
                  width: 50,
                  height: 28.5,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorSelectionBoxAnimation.value,
                      width: 1.75
                    ),
                    borderRadius: BorderRadius.circular(7.5)
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TypeText(key: keyMap['work']!, text: "work", onSelected: () => selectType(keyMap['work']!)),
              TypeText(key: keyMap['shortBreak']!, text: "shortBreak", onSelected: () => selectType(keyMap['shortBreak']!)),
              TypeText(key: keyMap['longBreak']!, text: "longBreak", onSelected: () => selectType(keyMap['longBreak']!))
            ],
          ),
        ],
      ),
    );
  }

}


/// Widget that is meant to only be used within a PeriodTypeChooser.
/// It features a gestureDetector that calls a required passed onSelected function.
class TypeText extends StatefulWidget {

  /// Text that will be displayed in the center.
  final String text;

  /// Function to be called when clicked on the widget.
  final VoidCallback onSelected;

  const TypeText({
    super.key,

    required this.text,
    required this.onSelected
  });

  @override
  TypeTextState createState() => TypeTextState();

}


class TypeTextState extends State<TypeText> {
  
  // Allows the Period popup access to the raw name of the currentKey,
  // which then it can input into the PeriodType enum to get the enum value,
  // required to make TimerPeriod instance.
  late final String typeName = widget.text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected();
      },
      child: Text(
        formatPeriodName(widget.text),
        style: TextStyle(
          fontSize: 16,
          color: PureColors.white.withValues(alpha: 0.8),
          fontWeight: FontWeight.w700
        ),
        textAlign: TextAlign.center
      ),
    );
  }

}