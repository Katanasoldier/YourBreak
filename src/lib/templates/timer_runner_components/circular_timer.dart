import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:yourbreak/constants/color_constants.dart';
import 'package:yourbreak/helper/timer_formatters.dart';

import 'package:yourbreak/models/timer_structure.dart';



class CircularTimer extends StatefulWidget {

  final TimerStructure timer;

  final double size;


  const CircularTimer({
    super.key,

    required this.timer,

    required this.size
  });

  @override
  CircularTimerState createState() => CircularTimerState();

}


class CircularTimerState extends State<CircularTimer> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _RingPainter(progress), // Empty progress
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Text(
              "Current Period Time",
              style: TextStyle(
                fontSize: 52.5,
                color: PureColors.white, // Meant to be the period's periodType color
                fontWeight: FontWeight.w700,
                height: 0.92,
              ),
            ),
            Text(
              "Upcoming Period Time",
              style: TextStyle(
                fontSize: 25,
                color: PureColors.white, // Meant to be the upcoming period's periodType color
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


  _RingPainter(this.progress);


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


  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    
    return oldDelegate.progress != progress;

  }
}