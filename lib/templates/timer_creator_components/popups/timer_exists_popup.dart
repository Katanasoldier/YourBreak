import 'package:flutter/material.dart';

import 'package:yourbreak/templates/generic_buttons/save_button.dart';

import 'package:yourbreak/templates/page_components.dart';
import 'package:yourbreak/templates/basic_divider.dart';

/// Returns an alert popupContent that signals to the player that they are about to
/// overwrite an existing timer, and if they wish to proceed, they have a single save button.
/// Takes in a required onSaveButtonPressed (Function), that will be called once the popup
/// SaveButton's onPressed is called.
class TimerExistsPopup extends StatelessWidget {

  final Function onSaveButtonPressed;

  const TimerExistsPopup({
    super.key,

    required this.onSaveButtonPressed
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => onSaveButtonPressed.call()
            ),
          )
        ],
      ),
    );
  }

}