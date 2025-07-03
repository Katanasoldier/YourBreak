import 'package:flutter/material.dart';
import 'package:yourbreak/templates/config_page.dart';
import 'package:yourbreak/templates/buttons/square_button.dart';
import 'package:yourbreak/pages/timer_management_pages/timer_creation_pages/timer_type.dart';


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
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => const TimerType()
          ));
        },
      ),
      buttonRight: (pageAnimationController) => SquareButton(
        mainText: "Edit",
        supportText: "Your Timers",
        iconName: "squareedit",
        pageAnimationController: pageAnimationController,
        onPressed: () {} // Fill in later !!!
      )
    );
  }
}