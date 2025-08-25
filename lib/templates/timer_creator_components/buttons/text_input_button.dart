import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/models/timer_structure.dart';

import 'package:yourbreak/templates/mixins/interactive_animations_mixin.dart';
import 'package:yourbreak/templates/mixins/opacity_animation_mixin.dart';

import 'package:yourbreak/templates/generic_buttons/button_base.dart';


/// A button that allows the user to input text.
/// 
/// Has a placeholderText property, that allows to change the hint text
/// displayed when the text field is empty, and a preexistingTimer property,
/// that when passed, will extract the name of the timer and set it as the current value.
/// 
/// Automatically fades in and out based on mouse hover and text input.
/// If there is text in the field, the border will remain opaque and not fade out.
class TextInputButton extends StatefulWidget {

  final String placeholderText;

  final TimerStructure? preexistingTimer;

  const TextInputButton({
    super.key,

    this.placeholderText = "placeholder text",
    this.preexistingTimer
  });

  @override
  TextInputButtonState createState() => TextInputButtonState();

}


class TextInputButtonState extends State<TextInputButton> with TickerProviderStateMixin, InteractiveAnimationsMixin, OpacityAnimationMixin {

  // Enables access to lockHover and disableClick properties.
  final GlobalKey<ButtonBaseState> buttonBaseKey = GlobalKey<ButtonBaseState>();

  //-----------------------------------------------------------
  // Animation section.

  // We override the default opacity animation because it starts from 1,
  // but this requires it to start from 0.5.
  @override
  Animation<double> get opacityAnimation => Tween<double>(
    begin: 0.5,
    end: 1.0
  ).animate(CurvedAnimation(
    parent: opacityController,
    curve: AnimationCurves.opacity
  ));

  //-----------------------------------------------------------
  // Text section.

  late final TextEditingController _textEditingController = TextEditingController()
    ..text = widget.preexistingTimer?.name ?? "";


  late String currentText = widget.preexistingTimer?.name ?? "";

  late bool isText = currentText != "" ? true : false;

  // To track if any text is in the field to keep the border color fully opaque when there is.
  void _textChanged() {
    setState(() {
      isText = _textEditingController.text.trim().isNotEmpty;
      currentText = _textEditingController.text.trim();
    });
  }

  // Node subsection of text section.
  final FocusNode textFocusNode = FocusNode();


  bool isFocused = false;

  void _focusChanged() {
    setState(() {
      isFocused = textFocusNode.hasFocus;
      // If focus is lost, reverse the hoverController to shrink it down.
      // This is because it doesn't reverse on its own.
      if (!isFocused) {

        buttonBaseKey.currentState?.lockHover = false;

        hoverController.reverse();
        if (!isText) opacityController.reverse(); // If there is no text, reverse the opacityController, too.
      } else {
        // To prevent situations where you can click on some spot on the button, where
        // it doesn't register the textfield, so when you click there, it counts as losing focus,
        // and when you click again on the textfield without leaving the button, it doesn't
        // scale up when it has focus.
        buttonBaseKey.currentState?.lockHover = true;
        hoverController.forward();
      }
    });
  }

  //-----------------------------------------------------------
  // States section.

  @override
  void initState() {
    super.initState();

    buttonBaseKey.currentState?.disableClick = true; // To prevent any reversing of the hover controller.

    _textEditingController.addListener(_textChanged);
    textFocusNode.addListener(_focusChanged);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_textChanged);
    _textEditingController.dispose();

    textFocusNode.removeListener(_focusChanged);
    textFocusNode.dispose();

    super.dispose();
  }

  //-----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      key: buttonBaseKey,
      onPressed: null,

      rebuildListeners: [
        hoverController,
        opacityController
      ],

      scaleAnimations: [hoverSizeAnimation],

      mouseRegionBasedControllers: [
        hoverController,
        opacityController
      ],

      child: AnimatedBuilder(
        animation: opacityAnimation,
        builder: (context, child) {
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(
                // Checks if there is text in the field to determine the border color.

                // If there is no text, when the mouse exits the button, the border will be set to the
                // value of opacityAnimation (0.5), else it will remain fully opaque.
                color: isText == true
                  ? PureColors.white
                  : PureColors.white.withValues(alpha: opacityAnimation.value),

                width: 2.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(12.5),
              color: Color(0xFF444444).withValues(alpha: 0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 45,
                child: Center(
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

                      // To track if the text field is focused, so when you select text,
                      // the text field doesn't size down (via hoverSizeAnimation) when you exit the text field.
                      focusNode: textFocusNode,

                      decoration: InputDecoration(
                    
                        // Hint/placeholder text and style.
                        hintText: widget.placeholderText,
                        hintStyle: TextStyle(
                          fontSize: 21,
                          color: PureColors.white.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w700,
                        ),

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
                      style: TextStyle(
                        fontSize: 21,
                        color: PureColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}