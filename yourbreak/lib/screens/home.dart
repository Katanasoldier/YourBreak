import 'package:flutter/material.dart';

//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:window_manager/window_manager.dart';
import 'package:yourbreak/templates/square_button.dart';
import 'package:yourbreak/templates/topbar.dart';
import 'package:yourbreak/templates/uni_bg.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          UniBg(),
          TopBar(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.5, vertical: 2),
              child: SizedBox(
                width: 500,
                height: 1080,
                /*constraints: BoxConstraints(
                  maxWidth: 436.55.w,
                ),*/
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IgnorePointer(
                      child: SizedBox(
                        height: 102,
                        width: 330,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'YourBreak',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 74,
                              color: const Color(0xFFEEEEEE),
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ),
                      ),
                    ),
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
                            onPressed: () {
                              // Handle play button press
                            },
                          ),
                          SquareButton(
                            iconName: 'plus',
                            mainText: 'Create',
                            supportText: 'Timer',
                            onPressed: () {
                              // Handle play button press
                            },
                          ),
                          //),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 132,
                      height: 143,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      const Color(0xFF16EFFF),
                                      const Color(0xFFB8EFFF),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      '241 Days',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'Login Streak',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFFEEEEEE),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [
                                            const Color(0xFFFF820E),
                                            const Color(0xFFFFCC00),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            '14 Cycles',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'In a Row',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFFEEEEEE),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [
                                            const Color(0xFFFF579D),
                                            const Color(0xFFD64DFF),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            '32.8 Days',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            'Spent Being Productive',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFFEEEEEE),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
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