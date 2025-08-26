import 'package:flutter/material.dart';

import 'package:yourbreak/helper/page_navigation.dart';

import 'package:yourbreak/templates/page_components.dart';
import 'package:yourbreak/templates/basic_divider.dart';

import 'package:yourbreak/templates/generic_buttons/return_button.dart';

/// An alert popup that shows up when the user tries to exit the TimerCreator.
/// To prevent any accidental exits and losing progress.
/// Takes in a required popUpController : AnimationController
class DiscardTimerPopup extends StatelessWidget {

  final AnimationController popUpController;

  const DiscardTimerPopup({
    super.key,

    required this.popUpController
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