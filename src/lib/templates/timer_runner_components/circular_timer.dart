import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/helper/timer_formatters.dart';

import 'package:yourbreak/models/timer_structure.dart';



/// Inner widget meant to be only used within TimerRunner.
/// Builds a circular countdown timer widget, that has 2 rings.
/// The background ring is static and the foreground ring is white,
/// appears full and shrinks to show the passing of time, and how much
/// left until the timer reaches 0 (end). It shrinks counter clockwise.
/// Takes in a required 'timer' and 'size', with timer being the timer that is
/// supposed to be run (will run all the periods indefinitely) and size designating
/// how big should the widget be.
/// Also takes in a onTimerControllerReady callback, that will be called everytime
/// the timerAnimationController is assigned, and will pass it as an argument.
class CircularTimer extends StatefulWidget {

  final TimerStructure timer;

  final double size;

  final Function(AnimationController) onTimerControllerReady;


  const CircularTimer({
    super.key,

    required this.timer,

    required this.size,

    required this.onTimerControllerReady
  });

  @override
  CircularTimerState createState() => CircularTimerState();

}


class CircularTimerState extends State<CircularTimer> with TickerProviderStateMixin {

  late AnimationController timerAnimationController;
  late Animation<double> timerAnimation;

  int currentPeriodIndex = 0; // Start from the beginning of the timer

  // ------------------------------------------------------------------------------------------

  /// Finds the next period index in the timer's pattern.
  /// This is to avoid boilerplate in the sub text.
  /// If the index matches the index of the last period,
  /// then return 0 to start from the beginning, else
  /// return an incremented index.
  int _getNextPeriodIndex(index) {
    return index + 1 < widget.timer.pattern.length
              ? index + 1
              : 0;
  }

  /// Formats time given in seconds into a colon format.
  /// Takes in an integer representing seconds and returns a string of the format:
  /// x:y:zs where:
  /// x - Hours, y - Minutes, z - Seconds.
  /// Note: If x is 0, it won't show x as 0, but just skip to y and z.
  String _formatTimeWithColon(int totalSeconds) {

    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    String formattedString;

    
    if (hours > 0) {
      formattedString = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else if (minutes > 0) {
      formattedString = '$minutes:${seconds.toString().padLeft(2, '0')}';
    } else {
      formattedString = seconds.toString();
    }

    formattedString += 's';


    return formattedString;
  }

  /// Starts the animation for the period that matches with the passed index.
  /// Recursive, will run forever. At the end of each animation, it will call a new
  /// _startPeriod with the next index.
  void _startPeriod(int index) {

    timerAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.timer.pattern[index].periodTime)
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTimerControllerReady(timerAnimationController);
    });


    timerAnimation = Tween<double>(
      begin: 1,
      end: 0
    ).animate(timerAnimationController)
      ..addListener(() {
        setState(() {
          // Rebuild the widget everytime the value changes.
        });
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {

          currentPeriodIndex = _getNextPeriodIndex(index);
         
          timerAnimationController.dispose();
         
          await Future.delayed(Duration(seconds: 5));

          _startPeriod(currentPeriodIndex);

        }
      });

  }

  // ------------------------------------------------------------------------------------------

  /// Gets the current value of timerAnimation, the animation that shortens the foreground ring of the countdown timer.
  double get progress => timerAnimation.value;

  /// Gets the remainingSeconds left until the countdown timer reaches the end (0), by multiplying
  /// the totalTime of the current period by the timerAnimation's value.
  int get remainingSeconds {
    final int currentPeriodTotalTime = widget.timer.pattern[currentPeriodIndex].periodTime;
    return (currentPeriodTotalTime * timerAnimation.value).ceil();
  }

  // ------------------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _startPeriod(currentPeriodIndex);
  }

  @override
  void dispose() {
    timerAnimationController.dispose();

    super.dispose();
  }

  // ------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _RingPainter(progress),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Text(
              _formatTimeWithColon(remainingSeconds),
              style: TextStyle(
                fontSize: 52.5,
                color: getPeriodColor(widget.timer.pattern[currentPeriodIndex].periodType.name),
                fontWeight: FontWeight.w700,
                height: 0.92,
              ),
            ),
            Text(
              _formatTimeWithColon(widget.timer.pattern[_getNextPeriodIndex(currentPeriodIndex)].periodTime),
              style: TextStyle(
                fontSize: 25,
                color: getPeriodColor(widget.timer.pattern[_getNextPeriodIndex(currentPeriodIndex)].periodType.name),
                fontWeight: FontWeight.w400,
                height: 0.92,
              ),
            )
          ],
        )
      ],
    );
  }

}


class _RingPainter extends CustomPainter {

  final double progress;

  // ---------------------------------

  _RingPainter(this.progress);

  // ---------------------------------

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.progress != progress;


  @override
  void paint(Canvas canvas, Size size) {

    final double strokeWidth = 10;
    final double radius = (size.width - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);


    // Background ring
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth/1.75
      ..color = PureColors.white.withValues(alpha: 0.25);

    canvas.drawCircle(center, radius, backgroundPaint);

    
    // Foreground progress ring
    final sweepAngle = 2 * pi * progress;

    final foregroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * pi,
        colors: List.filled(2, PureColors.white)
      ).createShader(rect);

    
    canvas.drawArc(
      rect,
      -pi / 2,
      sweepAngle,
      false,
      foregroundPaint
    );
  }
}