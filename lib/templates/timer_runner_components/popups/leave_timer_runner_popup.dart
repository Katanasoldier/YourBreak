import 'package:flutter/material.dart';
import 'package:yourbreak/helper/page_navigation.dart';
import 'package:yourbreak/templates/basic_divider.dart';
import 'package:yourbreak/templates/generic_buttons/return_button.dart';
import 'package:yourbreak/templates/page_components/page_header.dart';

class LeaveTimerRunnerPopup extends StatelessWidget {

  final AnimationController popUpController;

  const LeaveTimerRunnerPopup({
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
                text: "Are you sure you want to leave?",
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