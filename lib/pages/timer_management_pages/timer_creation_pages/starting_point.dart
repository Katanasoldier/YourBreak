import 'package:flutter/material.dart';
import 'package:yourbreak/helper/page_navigation.dart';

import 'package:yourbreak/templates/config_page.dart';

import 'package:yourbreak/templates/generic_buttons/square_button.dart';
import 'package:yourbreak/templates/timer_picker_components/timer_picker_column_buttons/timer_picker_column_button.dart';

import 'package:yourbreak/pages/timer_picker.dart';
import 'package:yourbreak/pages/timer_management_pages/timer_creation_pages/timer_creator.dart';



/// This page allows the user to pick between the options of creating a timer:
/// - from presets
/// - from scratch
/// Presets will push a TimerPicker page with each timer button further pushing a TimerCreator,
/// and from scratch will directly push an empty TimerCreator.
class StartingPoint extends StatelessWidget {

  const StartingPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfigPage(
      header: "Starting Point",
      buttonLeft: (pageAnimationController) => SquareButton(
        mainText: "Presets",
        supportText: "From",
        iconName: "folder",
        description: "You can always edit It\nto Your needs!",
        invertTextOrder: true,
        pageAnimationController: pageAnimationController,
        onPressed: () => navigateTo(context, 
          TimerPicker(timerButtonOnPressed: (button) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => TimerCreator(preexistingTimer: (button as TimerPickerColumnButtonState).timer,)
            ));
          })
        )
      ),
      buttonRight: (pageAnimationController) => SquareButton(
        mainText: "Scratch",
        supportText: "From",
        iconName: "pencil",
        invertTextOrder: true,
        pageAnimationController: pageAnimationController,
        onPressed: () => navigateTo(context, TimerCreator())
      )
    );
  }

}