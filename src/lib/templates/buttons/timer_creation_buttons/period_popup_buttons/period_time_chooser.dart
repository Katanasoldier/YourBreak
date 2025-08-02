import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/templates/base_mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/base_mixins/opacity_animation_mixin.dart';
import 'package:yourbreak/templates/buttons/button_base.dart';



class TimerTimeChooser extends StatefulWidget {


  const TimerTimeChooser({
    super.key
  });

  @override
  TimerTimeChooserState createState() => TimerTimeChooserState();

}


class TimerTimeChooserState extends State<TimerTimeChooser> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 37.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: PureColors.white.withValues(alpha: 0.75),
          width: 2
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeTextGroup(timeType: "hours"),
                TimeTextGroup(timeType: "minutes"),
                TimeTextGroup(timeType: "seconds")
              ]
            ),
            Container(
              width: 2,
              height: 25,
              color: PureColors.white.withValues(alpha: 0.5),
              margin: EdgeInsets.symmetric(horizontal: 5),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TimeArithmeticButton(operation: "increase"),
                TimeArithmeticButton(operation: "decrease"),
              ],
            )
          ],
        ),
      )
    );
  }
}



class TimeTextGroup extends StatefulWidget {

  final String timeType;

  const TimeTextGroup({
    super.key,
    
    required this.timeType
  });

  @override
  TimeTextGroupState createState() => TimeTextGroupState();

}

class TimeTextGroupState extends State<TimeTextGroup> with SingleTickerProviderStateMixin {

  // Text section.

    final TextEditingController _textEditingController = TextEditingController();

    bool isText = true;

    // To track if any text is in the field to keep the border color fully opaque when there is.
    void _textChanged() {
      setState(() {
        isText = _textEditingController.text.trim().isNotEmpty;
      });
    }

  // Text style subsection

    final TextStyle commonStyle = TextStyle(
      fontSize: 17,
      color: PureColors.white,
      fontWeight: FontWeight.w700,
    );

  //-----------------------------------------------------------
  // States section.

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(_textChanged);
    _textEditingController.text = "00";
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_textChanged);
    _textEditingController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FittedBox(
      //width: 45,
     // height: 37.5,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            child: Theme(
              // Overrides the default TextFormField cursor and selection
              // colors to match the application's theme.
              data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: PureColors.white.withValues(alpha: 0.5),
                  selectionColor: PureColors.blue.withValues(alpha: 0.5)
                ),
              ),
              child: TextFormField(
                controller: _textEditingController,
            
                decoration: InputDecoration(
                  // Removes the underline that appears under the text.
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    )
                  ),
                  // Removes the underline that appears when the text field is focused.
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    )
                  ),
                  // Removes the padding allowing the text to be centered vertically.
                  contentPadding: EdgeInsets.all(0),
                  isCollapsed: true
              
                ),
                // User text style.
                style: commonStyle
              ),
            ),
          ),
          Stack(
            children: [
              Transform.translate(
                offset: Offset(-2, 0),
                child: Text(
                  widget.timeType.characters.first,
                  style: commonStyle,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


class TimeArithmeticButton extends StatefulWidget {

  final String operation;

  const TimeArithmeticButton({
    super.key,

    required this.operation
  });

  @override
  TimeArithmeticButtonState createState() => TimeArithmeticButtonState();
}

class TimeArithmeticButtonState extends State<TimeArithmeticButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, OpacityAnimationMixin {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.5,
      height: 13,
      child: ButtonBase(
        onPressed: () => print("NOT IMPLEMENTED YET! TimeArithmeticButton onPressed"),
      
        rebuildListeners: [hoverSizeAnimation, opacityAnimation],
        mouseRegionBasedControllers: [hoverController, opacityController],
      
        scaleAnimations: [hoverSizeAnimation],
      
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: PureColors.white.withValues(alpha: 0.75),
              width: 1.75
            ),
            borderRadius: BorderRadius.circular(5)
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.25),
            child: SvgPicture.asset(
              'assets/svg/${widget.operation}.svg'
            ),
          )
        ),
      ),
    );
  }
  
}