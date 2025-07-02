import 'package:flutter/material.dart';
import 'package:yourbreak/templates/config_page.dart';
import 'package:yourbreak/templates/buttons/square_button/square_button.dart';
import 'package:yourbreak/templates/timerchoice_components/timerchooser.dart';

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
        description: "You can always edit It to Your needs!",
        invertTextOrder: true,
        pageAnimationController: pageAnimationController,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => TimerChooser()
          ));
        },
      ),
      buttonRight: (pageAnimationController) => SquareButton(
        mainText: "Scratch",
        supportText: "From",
        iconName: "pencil",
        invertTextOrder: true,
        pageAnimationController: pageAnimationController,
        onPressed: () {
          
        }
      )
    );
  }

}