import 'package:flutter/material.dart';
import 'package:yourbreak/pages/timer_management_pages/timer_management_landing_page.dart';
import 'package:yourbreak/templates/buttons/square_button.dart';
import 'package:yourbreak/templates/base_visuals.dart';
import 'package:yourbreak/templates/stat_text.dart';
import 'package:yourbreak/constants/font_size_constants.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();

}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {


  late final AnimationController pageAnimationController =
  AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    reverseDuration: const Duration(milliseconds: 500),
  );



  @override
  void initState() {

    super.initState();

    pageAnimationController.reverse();

  }


  @override
  void dispose() {

    pageAnimationController.dispose();

    super.dispose();

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
                    PageHeader(text: "YourBreak", fontSize: FontSizes.appTitleHeader, pageAnimationController: pageAnimationController),
                    SizedBox(
                      height: 183,
                      width: 430,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SquareButton(
                            iconName: 'stopwatch',
                            mainText: 'Run',
                            supportText: 'Timer',
                            pageAnimationController: pageAnimationController,
                            onPressed: () {

                            },
                          ),
                          SquareButton(
                            iconName: 'wrench',
                            mainText: 'Manage',
                            supportText: 'Your Timers',
                            pageAnimationController: pageAnimationController,
                            onPressed: () async {
                              
                              await pageAnimationController.forward();

                              if(!mounted) return;

                              Navigator.push(context, PageRouteBuilder(
                                pageBuilder: (context,animation,secondaryAnimation) => TimerManagementLandingPage(),
                                //transitionsBuilder: (context, animation, secondaryAnimation, child) => ,
                              ));

                              pageAnimationController.reverse();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 132,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StatText(
                                  mainText: "241 Days",
                                  supportText: "Login Streak",
                                  mainTextGradient: const [
                                    Color(0xFF16EFFF),
                                    Color(0xFFB8EFFF),
                                  ],
                                ),
                                StatText(
                                  mainText: "14 Cycles",
                                  supportText: "Most In a Row",
                                  mainTextGradient: const [
                                    Color(0xFFFF820E),
                                    Color(0xFFFFCC00),
                                  ],
                                ),
                                StatText(
                                  mainText: "32.8 Days",
                                  supportText: "Spent Being Productive",
                                  mainTextGradient: const [
                                    Color(0xFFFF579D),
                                    Color(0xFFD64DFF),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}