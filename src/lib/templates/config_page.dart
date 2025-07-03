import 'package:flutter/material.dart';
import 'package:yourbreak/templates/base_visuals.dart';
import 'package:yourbreak/templates/buttons/return_button.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/font_size_constants.dart';


class ConfigPage extends StatefulWidget {

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
    duration: AnimationDurations.pageTransition,
    reverseDuration: AnimationDurations.pageTransition
  );


  
  @override
  void initState() {
    super.initState();
  }


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