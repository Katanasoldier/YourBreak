import 'package:flutter/material.dart';
import 'package:yourbreak/templates/config_page.dart';
import 'package:yourbreak/templates/buttons/square_button.dart';
import 'package:yourbreak/pages/timer_management_pages/timer_creation_pages/starting_point.dart';

class TimerType extends StatelessWidget {

  const TimerType({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfigPage(
      header: "Timer Type",
      buttonLeft: (pageAnimationController) => SquareButton(
        mainText: "Simple",
        iconName: "cog",
        pageAnimationController: pageAnimationController,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => StartingPoint()
          ));
        },
      ),
      buttonRight: (pageAnimationController) => SquareButton(
        mainText: "Complex",
        iconName: "multipleCogs",
        imageFillScreen: true,
        mainTextGradient: const [
          Color(0xFFE2E6FF),
          Color(0xFFCFE8FF)
        ],
        pageAnimationController: pageAnimationController,
        onPressed: () {
          
        }
      )
    );
  }

}