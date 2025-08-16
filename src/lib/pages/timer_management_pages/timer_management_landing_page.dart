import 'package:flutter/material.dart';
import 'package:yourbreak/helper/page_navigation.dart';
import 'package:yourbreak/pages/timer_management_pages/timer_creation_pages/starting_point.dart';
import 'package:yourbreak/templates/config_page.dart';
import 'package:yourbreak/templates/buttons/square_button.dart';
import 'package:yourbreak/pages/timer_picker.dart';


class TimerManagementLandingPage extends StatelessWidget {
  
  const TimerManagementLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfigPage(
      header: "Management",
      buttonLeft: (pageAnimationController) => SquareButton(
        mainText: "Create",
        supportText: "A Timer",
        iconName: "plus",
        pageAnimationController: pageAnimationController,
        onPressed: () => navigateTo(context, const StartingPoint())
      ),
      buttonRight: (pageAnimationController) => SquareButton(
        mainText: "Edit",
        supportText: "Your Timers",
        iconName: "squareedit",
        pageAnimationController: pageAnimationController,
        // We leave the timerButtonOnPressed empty because all the logic is contained within the editButtons.
        onPressed: () => navigateTo(context, TimerPicker(timerButtonOnPressed: () {}, editButtons: true))
      )
    );
  }
}