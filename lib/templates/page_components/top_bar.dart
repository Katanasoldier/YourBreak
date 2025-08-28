import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yourbreak/templates/generic_buttons/control_button.dart';


/// Holds the color of the frame holding the control buttons.
const Color controlButtonFrameColor = Color(0xFF384151);

/// TO BE USED ONLY WITHIN `window_initializer` !!!
/// Replaces the default app topbar with a custom one.
/// Contains 2 control buttons:
/// - minimize
/// - close
/// Also provides the ability to drag the top of the application to drag it around
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
                child: Row( // Buttons
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
            ],
          ),
        ],
      ),
    );
  }
}