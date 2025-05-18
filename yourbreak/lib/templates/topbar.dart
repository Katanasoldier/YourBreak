import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yourbreak/templates/control_button.dart';


class TopBar extends StatelessWidget {

  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: 500.w,
      height: 28,
      child: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              windowManager.startDragging();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 67,
                height: 28,
                child: Stack(
                  children: [
                    Positioned(
                      height: 26,
                      width: 65,
                      left: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start, //Change later
                        children: [
                          Flexible(
                            flex: 1,
                            child: ControlButton(
                              iconName: 'minimize',
                              onPressed: () {
                                windowManager.minimize();
                              },
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: ControlButton(
                              iconName: 'close',
                              onPressed: () {
                                windowManager.close();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    IgnorePointer(
                      child: SvgPicture.asset(
                        'assets/svg/controlbuttonsframe.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }

}