import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yourbreak/templates/buttons/control_button.dart';

/// This widget replaces the default windows (in the future also macOS) top bar.
/// Doesn't remove the default top bar, main.dart handles that.


const Color controlButtonFrameColor = Color(0xFF384151);


class TopBar extends StatelessWidget {

  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: 500.w,
      height: 32,
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
              Container(
                width: 76.5,
                height: 31.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                  border: Border(
                    left: BorderSide(
                      color: controlButtonFrameColor,
                      width: 1.5,
                    ),
                    bottom: BorderSide(
                      color: controlButtonFrameColor,
                      width: 1.5,
                    ),
                  )
                ),
                child: Positioned(
                  height: 30,
                  width: 75,
                  left: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ControlButton(
                        iconName: 'minimize',
                        onPressed: () {
                          windowManager.minimize();
                        },
                      ),
                      ControlButton(
                        iconName: 'close',
                        onPressed: () {
                          windowManager.close();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}