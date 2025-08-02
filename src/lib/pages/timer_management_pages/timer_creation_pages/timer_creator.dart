import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';

import 'package:yourbreak/models/timer_structure.dart';

import 'package:yourbreak/templates/base_mixins/page_animation_controller_mixin.dart';

import 'package:yourbreak/templates/base_visuals.dart';
import 'package:yourbreak/templates/buttons/timer_creation_buttons/period_popup_buttons/period_time_chooser.dart';
import 'package:yourbreak/templates/buttons/timer_creation_buttons/period_popup_buttons/period_type_chooser.dart';

import 'package:yourbreak/templates/buttons/timer_creation_buttons/text_input_button.dart';
import 'package:yourbreak/templates/buttons/timer_creation_buttons/time_period_button.dart';
import 'package:yourbreak/templates/buttons/timer_creation_buttons/create_period_button.dart';
import 'package:yourbreak/templates/buttons/return_button.dart';
import 'package:yourbreak/templates/buttons/save_button.dart';

import 'package:yourbreak/templates/pop_up.dart';


/// Handles the creation and editing of timers
/// 
/// TBI
/// Can be called with a passed TimerStructure, and then will load
/// the creator will all the filled out details from the structure
class TimerCreator extends StatefulWidget {

  /// For the ability to start from a preset or edit an existing timer.
  final TimerStructure? basedOnExistingTimer;

  const TimerCreator({
    super.key,

    this.basedOnExistingTimer
  });

  @override
  State<TimerCreator> createState() => TimerCreatorState();

}


class TimerCreatorState extends State<TimerCreator> with TickerProviderStateMixin, PopUpControllerMixin, PageAnimationControllerMixin {


  List<TimerPeriod> currentTimePeriods = [TimerPeriod(periodTime: 2000, periodType: PeriodType.work)];


  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.5, vertical: 2),
              child: Column( // Main center column
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: PageHeader(
                      fontSize: FontSizes.pageHeader,
                      text: "Create Your Timer",
                      pageAnimationController: functionalPageAnimationController,
                      // Horizontal are intended to scale down the text.
                      // Vertical are to space it out from the top and divider below it.
                      margin: EdgeInsets.symmetric(vertical: 7.5, horizontal: 20),
                    ),
                  ),
                  Column( // Creator column (Name your timer, Time period in a column, create new time period)
                    children: [
                      SizedBox(
                        width: 300,
                        height: 45,
                        child: TextInputButton(
                          placeholderText: "Name Your Timer"
                        ),
                      ),
                      Container(
                        width: 325,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        margin: EdgeInsets.symmetric(vertical: 20),
                      ),
                      SizedBox(
                        width: 300,
                        height: 175,
                        child: RawScrollbar(
                          thickness: 4,
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
                              spacing: 10,
                              children: [
                                // TimePeriodButtons
                                for (final period in currentTimePeriods) 
                                TimePeriodButton(
                                  periodName: period.periodType.name.toString(),
                                  periodTime: period.periodTime.toInt()
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 230,
                        height: 1.75,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        margin: EdgeInsets.only(top: 2.5, bottom: 10),
                      ),
                      SizedBox(
                        width: 130,
                        height: 35,
                        child: CreatePeriodButton(
                          onPressed: () async => popUpController.forward(),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 330,
                    height: 35,
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Row( // Return and Save buttons
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 15,
                      children: [
                        SizedBox(
                          width: 150,
                          child: ReturnButton(pageAnimationController: functionalPageAnimationController),
                        ),
                        SizedBox(
                          width: 150,
                          child: SaveButton(pageAnimationController: functionalPageAnimationController, onPressed: () {functionalPageAnimationController.forward();}),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          PopUp(
            popUpController: popUpController,
            popUpContent: SizedBox(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PageHeader(
                    text: "New Time Period",
                    fontSize: 28,
                    pageAnimationController: functionalPageAnimationController,
                    margin: EdgeInsets.symmetric(vertical: 10)
                  ),
                  Container(
                    width: 250,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  PageHeader(
                    text: "Period Type",
                    fontSize: 20,
                    pageAnimationController: functionalPageAnimationController,
                    margin: EdgeInsets.all(0),
                    fontColor: PureColors.white.withValues(alpha: 0.8),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2.5,bottom: 7.5),
                    child: TimerTypeChooser()
                  ),
                  Container(
                    width: 250,
                    height: 1.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  PageHeader(
                    text: "Period Time",
                    fontSize: 20,
                    pageAnimationController: functionalPageAnimationController,
                    margin: EdgeInsets.all(0),
                    fontColor: PureColors.white.withValues(alpha: 0.8),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2.5,bottom: 7.5),
                    child: TimerTimeChooser()
                  ),
                  Container(
                    width: 250,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  Container( // Save button
                    width: 140,
                    height: 30,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: SaveButton(pageAnimationController: functionalPageAnimationController, onPressed: null),
                  )
                ],
              ),
            )
          ),
          TopBar()
        ],
      ),
    );
  }
}