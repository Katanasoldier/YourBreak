import 'package:flutter/material.dart';
import 'package:yourbreak/templates/generic_buttons/square_button.dart';
import 'package:yourbreak/templates/page_components.dart';
import 'package:yourbreak/templates/generic_buttons/return_button.dart';
import 'package:yourbreak/constants/size_constants.dart';

/// A template page, designed to be gather more info from the user on where
/// they want to go. Contains a page header at the top, 2 SquareButtons, each
/// one redirecting to another page.
/// At the top a page header, 2 SquareButtons and a return button below them.
/// Takes in a required:
/// - header : String, the text displayed at the top
/// - buttonLeft : Widget Function(AnimationController)
/// - buttonRight : Widget Function(AnimationController)
class TwoChoiceRedirectionTemplatePage extends StatelessWidget {

  final String headerText;
  final SquareButton leftButton;
  final SquareButton rightButton;

  const TwoChoiceRedirectionTemplatePage({
    super.key,

    required this.headerText,
    required this.leftButton,
    required this.rightButton
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          TopBar(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.5, vertical: 2),
              child: SizedBox(
                width: 500,
                height: 1080,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PageHeader(text: headerText, fontSize: FontSizes.pageHeader),
                    SizedBox(
                      height: 183,
                      width: 430,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          leftButton,
                          rightButton
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: const EdgeInsets.only(top: 35),
                              child: ReturnButton(),
                            ),
                          )
                        ],
                      )
                    )
                  ]
                )
              )
            )
          )
        ]
      )
    );
  }
}