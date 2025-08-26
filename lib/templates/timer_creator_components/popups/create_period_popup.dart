import 'package:flutter/material.dart';

import 'package:yourbreak/models/timer_structure.dart';

import 'package:yourbreak/templates/timer_creator_components/buttons/period_popup_buttons/period_time_chooser.dart';
import 'package:yourbreak/templates/timer_creator_components/buttons/period_popup_buttons/period_type_chooser.dart';
import 'package:yourbreak/templates/generic_buttons/save_button.dart';

import 'package:yourbreak/templates/page_components.dart';
import 'package:yourbreak/templates/basic_divider.dart';
import 'package:yourbreak/constants/color_constants.dart';

/// Returns the popupContent with the ability to create new periods.
/// Meant to be only used within TimerCreator
/// Takes in a required:
/// - currentTimePeriods : ValueNotifier<List<TimerPeriod
/// - popUpController : AnimationController
class CreatePeriodPopup extends StatefulWidget {

  final ValueNotifier<List<TimerPeriod>> currentTimerPeriodsNotifier;
  final AnimationController popUpController;

  const CreatePeriodPopup({
    super.key,

    required this.currentTimerPeriodsNotifier,
    required this.popUpController
  });
  
  @override
  CreatePeriodPopupState createState() => CreatePeriodPopupState();

}

class CreatePeriodPopupState extends State<CreatePeriodPopup> {

  // Allows to get their state's methods and reset the
  // customized state of editable fields.
  final GlobalKey<TimerTypeChooserState> timerTypeChooserKey = GlobalKey();
  final GlobalKey<TimerTimeChooserState> timerTimeChooserKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageHeader(
            text: "New Time Period",
            fontSize: 28,
            margin: const EdgeInsets.symmetric(vertical: 10)
          ),
          BasicDivider(
            width: 250,
            height: 2.5,
          ),
          PageHeader(
            text: "Period Type",
            fontSize: 20,
            margin: const EdgeInsets.all(0),
            fontColor: PureColors.white.withValues(alpha: 0.8),
          ),
          Container(
            margin: EdgeInsets.only(top: 2.5,bottom: 7.5),
            child: TimerTypeChooser(key: timerTypeChooserKey)
          ),
          BasicDivider(
            width: 250,
            height: 1.5,
          ),
          PageHeader(
            text: "Period Time",
            fontSize: 20,
            margin: const EdgeInsets.all(0),
            fontColor: PureColors.white.withValues(alpha: 0.8),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2.5,bottom: 7.5),
            child: TimerTimeChooser(key: timerTimeChooserKey)
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
              onPressed: () async {
                
                final int periodTime = timerTimeChooserKey.currentState?.getTotalTime() as int;
                
                // If the period has no time, don't create one.
                if (periodTime == 0) return;

                widget.currentTimerPeriodsNotifier.value = List.from(widget.currentTimerPeriodsNotifier.value)..add(
                  TimerPeriod(
                    periodType: PeriodType.values.byName(timerTypeChooserKey.currentState!.currentType.currentState!.typeName),
                    periodTime: timerTimeChooserKey.currentState?.getTotalTime() as int
                  )
                );           

                // Wait until the popup has been hidden until adjusting customized fields
                // to prevent visibile changes on the user's eyes.
                await widget.popUpController.reverse();

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

}