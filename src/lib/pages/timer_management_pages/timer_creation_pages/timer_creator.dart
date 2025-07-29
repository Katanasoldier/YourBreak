import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';

import 'package:yourbreak/models/timer_structure.dart';

import 'package:yourbreak/templates/base_mixins/page_animation_controller_mixin.dart';

import 'package:yourbreak/templates/base_visuals.dart';

import 'package:yourbreak/templates/buttons/save_button.dart';
import 'package:yourbreak/templates/buttons/timer_creation_buttons/create_period_button.dart';
import 'package:yourbreak/templates/buttons/timer_creation_buttons/text_input_button.dart';
import 'package:yourbreak/templates/buttons/timer_creation_buttons/time_period_button.dart';
import 'package:yourbreak/templates/buttons/return_button.dart';


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


class TimerCreatorState extends State<TimerCreator> with TickerProviderStateMixin, PageAnimationControllerMixin {

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
                  PageHeader(fontSize: FontSizes.pageHeader, text: "Create Your Timer", pageAnimationController: functionalPageAnimationController),
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
                                // TimePeriodButtons go here
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
                        child: CreatePeriodButton(),
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
          TopBar()
        ],
      ),
    );
  }
}