import 'package:flutter/material.dart';

import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';

import 'package:yourbreak/templates/base_visuals.dart';
import 'package:yourbreak/templates/timer_picker_components/timer_column.dart';

import 'package:yourbreak/templates/buttons/return_button.dart';


class TimerPicker extends StatefulWidget {

  final bool? editButtons;

  const TimerPicker({
    super.key,

    this.editButtons
  });

  @override
  State<TimerPicker> createState() => TimerPickerState();

}

class TimerPickerState extends State<TimerPicker> with SingleTickerProviderStateMixin {
  

  late final AnimationController pageAnimationController = AnimationController(
    vsync: this,
    duration: AnimationDurations.pageTransition,
    reverseDuration: AnimationDurations.pageTransition
  );



  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {

    super.dispose();

    pageAnimationController.dispose();

  }
  


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
                    PageHeader(text: "Pick A Timer", fontSize: FontSizes.pageHeader, pageAnimationController: pageAnimationController),
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
                                      child: TimerColumn(fontSize: columnHeaderFontSize, headerText: "Your", timerType: "user", editButtons: widget.editButtons)
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
                                      child: TimerColumn(fontSize: columnHeaderFontSize, headerText: "Preset", timerType: "preset", editButtons: null) //null or else it doesnt remove the edit buttons (actionButtons)
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
                            pageAnimationController: pageAnimationController,
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