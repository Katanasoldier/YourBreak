import 'package:flutter/material.dart';
import 'package:yourbreak/templates/config_page.dart';
import 'package:yourbreak/templates/buttons/square_button.dart';
import 'package:yourbreak/pages/timer_picker.dart';

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
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => TimerPicker()
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