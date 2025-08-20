import 'package:flutter/material.dart';
import 'package:yourbreak/templates/page_components.dart';
import 'package:yourbreak/templates/generic_buttons/return_button.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';


/// TODO: Rename this more clearly, for example TwoChoiceRedirectionTemplatePage, then remember to update the comments.
/// 
/// A template page, designed to be gather more info from the user on where
/// they want to go. Contains a page header at the top, 2 SquareButtons, each
/// one redirecting to another page.
/// At the top a page header, 2 SquareButtons and a return button below them.
/// Takes in a required:
/// - header : String, the text displayed at the top
/// - buttonLeft : Widget Function(AnimationController)
/// - buttonRight : Widget Function(AnimationController)
class ConfigPage extends StatefulWidget {

  // TODO: rename this to something better, like headerText, then remember to update the comments.
  final String header;
  final Widget Function(AnimationController) buttonLeft;
  final Widget Function(AnimationController) buttonRight;


  const ConfigPage({
    super.key,

    required this.header,

    required this.buttonLeft,
    required this.buttonRight
  });
  

  @override
  State<ConfigPage> createState() => ConfigPageState();

}


class ConfigPageState extends State<ConfigPage> with SingleTickerProviderStateMixin {


  late final AnimationController pageAnimationController = AnimationController(
    vsync: this,
    duration: AnimationDurations.pageTransition
  );


  @override
  void dispose() {
    
    super.dispose();

    pageAnimationController.dispose();

  }


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
                    PageHeader(text: widget.header, fontSize: FontSizes.pageHeader, pageAnimationController: pageAnimationController),
                    SizedBox(
                      height: 183,
                      width: 430,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.buttonLeft(pageAnimationController),
                          widget.buttonRight(pageAnimationController)
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
                              child: SizedBox(
                                width: 165,
                                height: 35,
                                child: ReturnButton(
                                  pageAnimationController: pageAnimationController
                                )
                              ),
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