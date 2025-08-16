import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';

import 'package:yourbreak/templates/base_mixins/page_animation_controller_mixin.dart';

import 'package:yourbreak/templates/base_visuals.dart';
import 'package:yourbreak/templates/timer_picker_components/timer_picker_column.dart';

import 'package:yourbreak/templates/buttons/return_button.dart';


/// Displays both types of timers in columns next to eachother.
/// Takes in an optional editButtons, which decides whether to
/// show and allow functioning of the edit buttons (edit, delete)
/// inside each timer button (timer shown in the form of a button)
/// It takes in a equired timerButtonOnPressed, which defines logic
/// for each timer button's onPressed event.
class TimerPicker extends StatefulWidget {

  final Function timerButtonOnPressed;
  final bool? editButtons;

  const TimerPicker({
    super.key,

    required this.timerButtonOnPressed,
    this.editButtons
  });

  @override
  State<TimerPicker> createState() => TimerPickerState();

}

class TimerPickerState extends State<TimerPicker> with SingleTickerProviderStateMixin, PageAnimationControllerMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          TopBar(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.5, vertical: 2),
              child: SizedBox(
                width: 500,
                height: 1080,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PageHeader(text: "Pick A Timer", fontSize: FontSizes.pageHeader, pageAnimationController: functionalPageAnimationController),
                    SizedBox(
                      height: 280,
                      width: 430,
                      child: SizedBox(
                        height: 280,
                        width: 430,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                        
                            final double maxSize = constraints.maxWidth;

                            final double frameBorderWidth = maxSize * 0.0107;
                            final double frameBorderRadius = maxSize * 0.053;

                            final double columnHeaderFontSize = maxSize * 0.0775;

                            return Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: PureColors.white,
                                  width: frameBorderWidth,
                                ),
                                borderRadius: BorderRadius.circular(frameBorderRadius),
                                color: Colors.transparent,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: frameBorderWidth),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      height: 280 - (2*frameBorderWidth),
                                      child: TimerPickerColumn(fontSize: columnHeaderFontSize, headerText: "Your", timerType: "user", timerButtonOnPressed: widget.timerButtonOnPressed, editButtons: widget.editButtons)
                                    ),
                                    Container(
                                      width: 3,
                                      height: 205,
                                      decoration: BoxDecoration(
                                        color: PureColors.grey,
                                        borderRadius: BorderRadius.circular(frameBorderRadius)
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      height: 280 - (2*frameBorderWidth) * 1.5,
                                      child: TimerPickerColumn(fontSize: columnHeaderFontSize, headerText: "Preset", timerType: "preset", timerButtonOnPressed: widget.timerButtonOnPressed, editButtons: null) // Only null removes the edit buttons.
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        ),
                      )
                    ),
                    SizedBox(
                      height: 53,
                      width: 430,
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 165,
                          height: 35,
                          child: ReturnButton(
                            pageAnimationController: functionalPageAnimationController,
                          ),
                        )
                      ),
                    )
                  ]
                )
              )
            )
          )
        ]
      )
    );
  }
}