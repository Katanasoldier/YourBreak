import 'package:flutter/material.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';

class PageHeader extends StatefulWidget {

  final String text;
  final double? fontSize;
  final AnimationController pageAnimationController;

  const PageHeader({
    super.key,
    required this.text,
    this.fontSize,
    required this.pageAnimationController
  });

  @override
  State<PageHeader> createState() => PageHeaderState();

}

class PageHeaderState extends State<PageHeader> with SingleTickerProviderStateMixin {

  late Animation<Offset> pageSlideAnimation =
    Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -3)
    ).animate(CurvedAnimation(
      parent: widget.pageAnimationController,
      curve: AnimationCurves.slideInOutPage
    )
  );


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: pageSlideAnimation,
      child: IgnorePointer(
        child: SizedBox(
          height: 102,
          width: 330,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.fontSize ?? 74,
                color: PageHeaderColors.headerText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

}