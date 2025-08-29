import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yourbreak/helper/page_navigation.dart';
import 'package:yourbreak/helper/timer_formatters.dart';
import 'package:yourbreak/models/user_stats_structure/user_stats_structure.dart';
import 'package:yourbreak/pages/timer_management_pages/timer_management_landing_page.dart';
import 'package:yourbreak/pages/timer_picker.dart';
import 'package:yourbreak/pages/timer_runner.dart';
import 'package:yourbreak/templates/generic_buttons/square_button.dart';
import 'package:yourbreak/templates/page_components.dart';
import 'package:yourbreak/templates/timer_picker_components/timer_picker_column_buttons/timer_picker_column_button.dart';
import 'package:yourbreak/templates/stat_text.dart';
import 'package:yourbreak/constants/font_size_constants.dart';


/// The default landing page when opening the app.
/// Contains 2 square buttons that allow the user to choose between
/// running a timer or managing timers.
class Home extends StatelessWidget {

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.5, vertical: 2),
              child: SizedBox(
                width: 500,
                height: 1080,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PageHeader(text: "YourBreak", fontSize: FontSizes.appTitleHeader),
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
                            onPressed: () => navigateTo(
                              context, 
                              TimerPicker(
                                timerButtonOnPressed: (TimerPickerColumnButtonState button) => navigateTo(context, TimerRunner(timer: button.timer))
                              )
                            )
                          ),
                          SquareButton(
                            iconName: 'wrench',
                            mainText: 'Manage',
                            supportText: 'Your Timers',
                            onPressed: () => navigateTo(context, TimerManagementLandingPage())
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
                            child: ValueListenableBuilder(
                              valueListenable: Hive.box<UserStatsStructure>("user_stats").listenable(),
                              builder: (_, userStatsBox, _) {

                                late final UserStatsStructure defaultUser = userStatsBox.get("default_user")!;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StatText(
                                      mainText: '${defaultUser.loginStreak} Days',
                                      supportText: "Login Streak",
                                      mainTextGradient: const [
                                        Color(0xFF16EFFF),
                                        Color(0xFFB8EFFF),
                                      ],
                                    ),
                                    StatText(
                                      mainText: "${defaultUser.workPeriodStreak} Cycles",
                                      supportText: "Most In a Row",
                                      mainTextGradient: const [
                                        Color(0xFFFF820E),
                                        Color(0xFFFFCC00),
                                      ],
                                    ),
                                    StatText(
                                      mainText: formatSeconds(defaultUser.totalProductiveTime),
                                      supportText: "Spent Being Productive",
                                      mainTextGradient: const [
                                        Color(0xFFFF579D),
                                        Color(0xFFD64DFF),
                                      ],
                                    ),
                                  ],
                                );

                              }
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