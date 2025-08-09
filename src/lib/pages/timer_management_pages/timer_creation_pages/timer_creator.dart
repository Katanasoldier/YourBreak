import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';

import 'package:yourbreak/models/timer_structure.dart';
import 'package:yourbreak/pages/timer_picker.dart';

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


/// Allows the user to manage the pattern structure of an existing or new timer.
/// 
/// Can be called with a passed TimerStructure, and then will load
/// the creator will all the filled out details from the structure.
class TimerCreator extends StatefulWidget {

  /// For the ability to start from a preset or edit an existing timer.
  final TimerStructure? preexistingTimer;

  const TimerCreator({
    super.key,

    this.preexistingTimer
  });

  @override
  State<TimerCreator> createState() => TimerCreatorState();

}


class TimerCreatorState extends State<TimerCreator> with TickerProviderStateMixin, PopUpControllerMixin, PageAnimationControllerMixin {

  //---------------------------------------------------------------------------------------------------------------------
  // Timer section.

  final Box<TimerStructure> userBox = Hive.box<TimerStructure>('user_timers');

  /// Global, represents the timer being edited or created by the user.
  late TimerStructure newTimer;
  
  /// Saves [newTimer] to [userBox].
  /// Does not check for anything!!!
  /// Should be only called after everything in newTimer has been confirmed.
  void saveTimer() async {

    await userBox.put(newTimer.name.toLowerCase(), newTimer);

    /// Close the creator widget (hide it)
    functionalPageAnimationController.forward();


    if(!mounted) return;


    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (context,animation,secondaryAnimation) => TimerPicker(),
    ));

    /// Reverse back the creator to avoid future issues where if the user pops the later page,
    /// the creator page is unusable because of the widgets having their 'hidden' states active.
    functionalPageAnimationController.reverse();

  }

  // Allows to get the timer's name as inserted by the user.
  final GlobalKey<TextInputButtonState> timerNameInputKey = GlobalKey();


  // TimePeriods subsection

    /// Holds all of the time periods in this timer.
    late List<TimerPeriod> currentTimePeriods = widget.preexistingTimer?.pattern ?? [];

    /// Used to control when the column that holds the currentTimePeriods rebuilds,
    /// to show an accurate version.
    /// On incrementation or change in value it will cause the column to rebuild
    /// according to currentTimePeriods.
    int rebuildPeriodList = 0;

    /// For the period list.
    final ScrollController scrollController = ScrollController();


  //---------------------------------------------------------------------------------------------------------------------
  // Timer section.

  /// Sizedbox acts as a placeholder.
  Widget popupContent = SizedBox();

  /// Used to control when the popup rebuilds, to always show fresh widgets.
  /// On incrementation or change in value it will cause the popup to rebuild.
  int rebuildPopup = 0;

  // Allows to reset the customized state of editable fields inside the TimerPeriod popup.
  final GlobalKey<TimerTypeChooserState> timerTypeChooserKey = GlobalKey();
  final GlobalKey<TimerTimeChooserState> timerTimeChooserKey = GlobalKey();

  //---------------------------------------------------------------------------------------------------------------------

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
                      margin: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20),
                    ),
                  ),
                  Column( // Creator column (Name your timer, Time period in a column, create new time period)
                    children: [
                      SizedBox(
                        width: 300,
                        height: 45,
                        child: TextInputButton(
                          key: timerNameInputKey,
                          placeholderText: "Name Your Timer"
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: _Divider(
                          width: 325,
                          height: 3,
                          opacity: 0.5,
                        ),
                      ),
                      SizedBox( // TimePeriodButtons parent
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
                          radius: const Radius.circular(4),
                          thumbVisibility: true,
                          controller: scrollController,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            controller: scrollController,
                            child: Column(
                              key: ValueKey(rebuildPeriodList),
                              spacing: 10,
                              children: [
                                // TimePeriodButtons
                                for (int i = 0; i < currentTimePeriods.length; i++) 
                                TimePeriodButton(
                                  periodName: currentTimePeriods[i].periodType.name.toString(),
                                  periodTime: currentTimePeriods[i].periodTime.toInt(),
                                  onRemove: () {
                                    setState(() {
                                      currentTimePeriods.removeAt(i);
                                      rebuildPeriodList++;
                                    });
                                  }
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2.5, bottom: 10),
                        child: _Divider(
                          width: 230,
                          height: 1.75,
                          opacity: 0.25,
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        height: 35,
                        child: CreatePeriodButton(
                          /// Button that shows a pop up where the user can
                          /// configure a new time period.
                          onPressed: () {
                            setState(() {
                              popupContent = createPeriodPopupContent();
                              rebuildPopup++;
                            });
                            popUpController.forward();
                          },
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 330,
                    height: 35,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Row( // Return and Save buttons
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 15,
                      children: [
                        SizedBox(
                          width: 150,
                          child: ReturnButton(
                            pageAnimationController: functionalPageAnimationController,
                            onPressed: 
                              currentTimePeriods.isNotEmpty
                                ? () {
                                  setState(() {
                                    popupContent = discardTimerPopupContent();
                                    rebuildPopup++;
                                  });
                                  popUpController.forward();
                                }
                                : null
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: SaveButton(
                            pageAnimationController: functionalPageAnimationController,
                            onPressed: () {
                              
                              /// If the timer doesn't have a name or a period, don't save.
                              if (timerNameInputKey.currentState!.isText == false || currentTimePeriods.isEmpty) return;

                              setState(() {
                                newTimer = TimerStructure(
                                  name: timerNameInputKey.currentState!.currentText,
                                  complexity: Complexity.simple,
                                  pattern: currentTimePeriods
                                );
                              });

                              /// If the user already has an existing timer with the same name as the new timer,
                              /// prompt if he wants to overwrite the existing one.
                              if (userBox.containsKey(newTimer.name.toLowerCase())) {
                                setState(() {
                                  popupContent = existingNamePopupContent();
                                  rebuildPopup++;
                                });
                                popUpController.forward();
                              } else {
                                saveTimer();
                              }

                            }
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          PopUp(
            key: ValueKey(rebuildPopup),
            popUpController: popUpController,
            popUpContent: popupContent
          ),
          /// TopBar is above the popup so the user can still access control buttons whilst in popup.
          TopBar()
        ],
      ),
    );
  }

  //---------------------------------------------------------------------------------------------------------------------
  // Popup content functions section.

  Widget createPeriodPopupContent() {
    return SizedBox(
      width: 350,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageHeader(
            text: "New Time Period",
            fontSize: 28,
            pageAnimationController: functionalPageAnimationController,
            margin: const EdgeInsets.symmetric(vertical: 10)
          ),
          _Divider(
            width: 250,
            height: 2.5,
          ),
          PageHeader(
            text: "Period Type",
            fontSize: 20,
            pageAnimationController: functionalPageAnimationController,
            margin: const EdgeInsets.all(0),
            fontColor: PureColors.white.withValues(alpha: 0.8),
          ),
          Container(
            margin: EdgeInsets.only(top: 2.5,bottom: 7.5),
            child: TimerTypeChooser(key: timerTypeChooserKey)
          ),
          _Divider(
            width: 250,
            height: 1.5,
          ),
          PageHeader(
            text: "Period Time",
            fontSize: 20,
            pageAnimationController: functionalPageAnimationController,
            margin: const EdgeInsets.all(0),
            fontColor: PureColors.white.withValues(alpha: 0.8),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2.5,bottom: 7.5),
            child: TimerTimeChooser(key: timerTimeChooserKey)
          ),
          _Divider(
            width: 250,
            height: 2.5,
          ),
          Container( // Save button
            width: 140,
            height: 30,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: SaveButton(
              pageAnimationController: functionalPageAnimationController,
              onPressed: () async {
                
                final int periodTime = timerTimeChooserKey.currentState?.getTotalTime() as int;
                
                // If the period has no time, don't create one.
                if (periodTime == 0) return;

                currentTimePeriods.add(TimerPeriod(
                  periodType: PeriodType.values.byName(timerTypeChooserKey.currentState!.currentType.currentState!.typeName),
                  periodTime: timerTimeChooserKey.currentState?.getTotalTime() as int
                ));


                setState(() {
                  rebuildPeriodList++;
                  rebuildPopup++;
                });              

                // Wait until the popup has been hidden until adjusting customized fields
                // to prevent visibile changes on the user's eyes.
                await popUpController.reverse();

                // Reset the customized parts of each field so the next time
                // the popup is called, it doesn't show the previous settings.
                timerTypeChooserKey.currentState?.reset();
                timerTimeChooserKey.currentState?.reset();
              }
            ),
          )
        ],
      )
    );
  }

  Widget existingNamePopupContent() {
    return SizedBox(
      width: 370,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: FittedBox(
              child: PageHeader(
                text: "There is already a timer with this name.\n Do you want to overwrite it?",
                fontSize: 28,
                pageAnimationController: functionalPageAnimationController,
                margin: const EdgeInsets.symmetric(vertical: 10)
              ),
            ),
          ),
          _Divider(
            width: 250,
            height: 2.5,
          ),
          Container( // Save button
            width: 140,
            height: 30,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: SaveButton(
              pageAnimationController: functionalPageAnimationController,
              onPressed: () => saveTimer()
            ),
          )
        ],
      ),
    );
  }

  Widget discardTimerPopupContent() {
    return SizedBox(
      width: 370,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: FittedBox(
              child: PageHeader(
                text: "Are you sure you want to go back?\nThis timer will be discarded.",
                fontSize: 28,
                pageAnimationController: functionalPageAnimationController,
                margin: const EdgeInsets.symmetric(vertical: 10)
              ),
            ),
          ),
          _Divider(
            width: 250,
            height: 2.5,
          ),
          Container( // Save button
            width: 140,
            height: 30,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ReturnButton(pageAnimationController: functionalPageAnimationController),
          )
        ],
      ),
    );
  }

}

/// Basic divider for the TimerCreator widget.
/// Takes in a required width, height and optional opacity and color.
class _Divider extends StatelessWidget {

  final double width;
  final double height;

  final double opacity;
  final Color color;

  const _Divider({
    super.key,

    required this.width,
    required this.height,

    this.opacity = 0.5,
    this.color = PureColors.white
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(20)
      )
    );
  }
}