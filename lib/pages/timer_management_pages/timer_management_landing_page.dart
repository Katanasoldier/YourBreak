import 'package:flutter/material.dart';
import 'package:yourbreak/helper/page_navigation.dart';
import 'package:yourbreak/pages/timer_management_pages/timer_creation_pages/starting_point.dart';
import 'package:yourbreak/templates/two_choice_redirection_template_page.dart';
import 'package:yourbreak/templates/generic_buttons/square_button.dart';
import 'package:yourbreak/pages/timer_picker.dart';


/// A redirection page that allows the user to manage whether they want to
/// create a new timer or manage their existing ones.
/// If create a new timer, it will push StartingPoint,
/// if manage their existing ones, it will push a TimerPicker with editButtons enabled.
class TimerManagementLandingPage extends StatelessWidget {
  
  const TimerManagementLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TwoChoiceRedirectionTemplatePage(
      headerText: "Management",
      leftButton: SquareButton(
        mainText: "Create",
        supportText: "A Timer",
        iconName: "plus",
        onPressed: () => navigateTo(context, const StartingPoint())
      ),
      rightButton: SquareButton(
        mainText: "Edit",
        supportText: "Your Timers",
        iconName: "squareedit",
        // We leave the timerButtonOnPressed empty because all the logic is contained within the editButtons.
        onPressed: () => navigateTo(context, TimerPicker(timerButtonOnPressed: () {}, editButtons: true))
      )
    );
  }
}