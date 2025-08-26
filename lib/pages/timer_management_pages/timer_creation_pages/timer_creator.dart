import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';
import 'package:yourbreak/helper/page_navigation.dart';

import 'package:yourbreak/models/timer_structure.dart';
import 'package:yourbreak/pages/timer_picker.dart';
import 'package:yourbreak/templates/basic_divider.dart';

import 'package:yourbreak/templates/page_components.dart';

import 'package:yourbreak/templates/timer_creator_components/buttons/text_input_button.dart';
import 'package:yourbreak/templates/timer_creator_components/buttons/time_period_button.dart';
import 'package:yourbreak/templates/timer_creator_components/buttons/create_period_button.dart';

import 'package:yourbreak/templates/generic_buttons/return_button.dart';
import 'package:yourbreak/templates/generic_buttons/save_button.dart';

import 'package:yourbreak/templates/pop_up.dart';
import 'package:yourbreak/templates/timer_creator_components/popups/create_period_popup.dart';


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


class TimerCreatorState extends State<TimerCreator> with TickerProviderStateMixin, PopUpControllerMixin {

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

    if(!mounted) return;

    navigateTo(context, TimerPicker(timerButtonOnPressed: (buttonState) {}));

  }

  // Allows to get the timer's name as inserted by the user.
  final GlobalKey<TextInputButtonState> timerNameInputKey = GlobalKey();


  // TimePeriods subsection

    /// Backing ValueNotifier that holds the list of active TimerPeriods.
    /// 
    /// !!! Do not confuse this with currentTimerPeriods, which refers to the
    /// current value exposed inside a ValueListenableBuilder builder callback. !!!
    late final ValueNotifier<List<TimerPeriod>> _currentTimerPeriods =
      ValueNotifier(widget.preexistingTimer?.pattern ?? []);

    /// For the period list.
    final ScrollController scrollController = ScrollController();


  //---------------------------------------------------------------------------------------------------------------------
  // Timer section.

  /// Sizedbox acts as a placeholder.
  Widget popupContent = SizedBox();

  /// Pushes a popup with the newContent as it's content.
  /// Sets the popupContent to 'newContent', then calls
  /// setState() to rebuild the widget with the new content
  /// and finally forwards the popUpController so the popup is visible.
  void pushPopupContent(Widget newContent) {

    popupContent = newContent;

    // When the popUpController forwards,
    // it displays the new content as opposed to the previous.
    setState(() {});

    popUpController.forward();

  }

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
              child: ValueListenableBuilder(
                valueListenable: _currentTimerPeriods,
                builder: (_, currentTimerPeriods, _) => 
                Column( // Main center column
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: PageHeader(
                        fontSize: FontSizes.pageHeader,
                        text: "Create Your Timer",
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
                            placeholderText: "Name Your Timer",
                            preexistingTimer: widget.preexistingTimer,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: BasicDivider(
                            width: 325,
                            height: 3,
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
                                spacing: 10,
                                children: [
                                  // TimePeriodButtons
                                  for (int i = 0; i < currentTimerPeriods.length; i++) 
                                  TimePeriodButton(
                                    periodName: currentTimerPeriods[i].periodType.name.toString(),
                                    periodTime: currentTimerPeriods[i].periodTime.toInt(),
                                    onRemove: () => currentTimerPeriods = List.from(currentTimerPeriods)..removeAt(i)
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 2.5, bottom: 10),
                          child: BasicDivider(
                            width: 230,
                            height: 1.75,
                            colorAlpha: 0.25
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 35,
                          child: CreatePeriodButton(
                            /// Button that shows a pop up where the user can
                            /// configure a new time period.
                            onPressed: () => 
                            pushPopupContent(
                              CreatePeriodPopup(
                                currentTimerPeriodsNotifier: _currentTimerPeriods,
                                popUpController: popUpController,
                              )
                            ),
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
                              onPressed: 
                                currentTimerPeriods.isNotEmpty
                                  ? () => pushPopupContent(discardTimerPopupContent())
                                  : null
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: SaveButton(
                              onPressed: () {
                                
                                /// If the timer doesn't have a name or a period, don't save.
                                if (timerNameInputKey.currentState!.isText == false || currentTimerPeriods.isEmpty) return;
                
                                setState(() {
                                  newTimer = TimerStructure(
                                    name: timerNameInputKey.currentState!.currentText,
                                    complexity: Complexity.simple,
                                    pattern: currentTimerPeriods
                                  );
                                });
                
                                /// If the user already has an existing timer with the same name as the new timer,
                                /// prompt if he wants to overwrite the existing one.
                                if (userBox.containsKey(newTimer.name.toLowerCase())) {
                                  pushPopupContent(existingNamePopupContent());
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
          ),
          PopUp(
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
  // These functions return the predefined popup contents.

  /// Returns an alert popupContent that signals to the player that they are about to
  /// overwrite an existing timer, and if they wish to proceed, they have a single save button.
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
                margin: const EdgeInsets.symmetric(vertical: 10)
              ),
            ),
          ),
          BasicDivider(
            width: 250,
            height: 2.5,
          ),
          Container( // Save button
            width: 140,
            height: 30,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: SaveButton(
              onPressed: () => saveTimer()
            ),
          )
        ],
      ),
    );
  }

  /// An alert popup that shows up when the user tries to exit the TimerCreator.
  /// To prevent any accidental exits and losing progress.
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
                margin: const EdgeInsets.symmetric(vertical: 10)
              ),
            ),
          ),
          BasicDivider(
            width: 250,
            height: 2.5,
          ),
          Container( // Save button
            width: 140,
            height: 30,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ReturnButton(
              onPressed: () {
                popCurrentPage(context);
                popUpController.reverse();
              },
            ),
          )
        ],
      ),
    );
  }

}