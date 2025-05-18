import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ControlButton extends StatefulWidget {
  final String? iconName;
  final VoidCallback onPressed;

  const ControlButton({
    required this.iconName,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  _ControlButtonState createState() => _ControlButtonState();
}

/* REMEMBER TO ADD ON CLICK HIGHER OPACITY EFFECT */

class _ControlButtonState extends State<ControlButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late double maxOpacity;

  @override
  void initState() {
    super.initState();
    maxOpacity = widget.iconName == "close" ? 1.0 : 0.37;

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 50), reverseDuration: Duration(milliseconds: 50))
          ..addListener(() {
            setState(() {});
          });
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: maxOpacity).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent _) {
    _controller.forward();
    //print("Mouse entered");
  }

  void _onExit(PointerEvent _) {
    _controller.reverse();
    //print("Mouse exited");
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              borderRadius: widget.iconName == "close"
                  ? BorderRadius.zero
                  : const BorderRadius.only(bottomLeft: Radius.circular(8)),
              onTap: widget.onPressed,
              child: IgnorePointer(
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      decoration: BoxDecoration(
                        color: widget.iconName == "close"
                            ? Color.fromRGBO(180, 19, 62, _opacityAnimation.value)
                            : Color.fromRGBO(130, 130, 130, _opacityAnimation.value),
                        borderRadius: widget.iconName == "close"
                            ? BorderRadius.zero
                            : const BorderRadius.only(bottomLeft: Radius.circular(5.9)),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 10,
                        height: 10,
                        child: SvgPicture.asset(
                          'assets/svg/${widget.iconName}.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}