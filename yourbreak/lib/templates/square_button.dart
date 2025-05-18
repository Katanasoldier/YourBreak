import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:auto_size_text/auto_size_text.dart';

class SquareButton extends StatefulWidget {
  final String mainText;
  final String? supportText;
  final String? iconName;
  final bool? invertTextOrder;
  final VoidCallback onPressed;

  const SquareButton({
    super.key,
    required this.mainText,
    required this.onPressed,
    this.iconName,
    this.supportText,
    this.invertTextOrder,
  });

  @override
  SquareButtonState createState() => SquareButtonState();

}

class SquareButtonState extends State<SquareButton> with TickerProviderStateMixin {

  late AnimationController _slideController;
  late AnimationController _clickController;

  late Animation<Offset> _mainTextSlideAnimation;
  late Animation<Offset> _supportTextSlideAnimation;
  late Animation<double> _buttonHoverSizeAnimation;

  //final GlobalKey mainTextPos = GlobalKey();
  //final GlobalKey supportTextPos = GlobalKey();


  // DEBUG
  /*Future<void> _loop() async {
    while(true){
      final mainText = mainTextPos.currentContext?.findRenderObject() as RenderBox?;
      final supportText = supportTextPos.currentContext?.findRenderObject() as RenderBox?;

      if (mainText != null && supportText != null) {
        final mainPos = mainText.localToGlobal(Offset.zero);
        final supportPos = supportText.localToGlobal(Offset.zero);
        print('Main Text Position: $mainPos');
        print('Support Text Position: $supportPos');
      }
      await Future.delayed(Duration(milliseconds: 1000));
    }
  }*/

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(vsync: this, duration: Duration(milliseconds: 200), reverseDuration: Duration(milliseconds: 200));

    _clickController = AnimationController(vsync: this, duration: Duration(milliseconds: 300), reverseDuration: Duration(milliseconds: 300));

    _mainTextSlideAnimation = 
      Tween<Offset>(
        begin: Offset(0, 0),//0.1),
        end: Offset(0, -0.323)//-0.3)
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutQuad
      )
    );
    
    _supportTextSlideAnimation = 
      Tween<Offset>(
        begin: Offset(0, 4),//0.6),
        end: Offset(0, 0.77)//0.1)
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic
      )
    );

    _buttonHoverSizeAnimation =
      Tween<double>(
        begin: 1.0,
        end: 1.05
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutQuad
      )
    );

    _slideController.reverse();

    _clickController.reverse();

    //_loop();
  }

  @override
  void dispose() {

    _slideController.dispose();
    _clickController.dispose();

    super.dispose();
  }


  void _onEnter(PointerEvent _) {
    _slideController.forward();
  }

  void _onExit(PointerEvent _) {
    _slideController.reverse();
    _clickController.reverse();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _buttonHoverSizeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonHoverSizeAnimation.value,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
          
                final double maxSize = constraints.maxWidth;
          
                return MouseRegion(
                  onEnter: _onEnter,
                  onExit: _onExit,
                  child: OutlinedButton(
                    clipBehavior: Clip.hardEdge,
                    onPressed: () {
                      widget.onPressed.call();
                      _clickController.forward();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(maxSize * 0.12),
                      ),
                      padding: EdgeInsets.all(0),
                      side: BorderSide(
                        color: const Color(0xFFEEEEEE),
                        width: maxSize * 0.025,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: Colors.transparent,
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              'assets/svg/${widget.iconName}.svg',
                              width: maxSize * 0.85,
                              height: maxSize * 0.85,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Stack(
                            //mainAxisSize: MainAxisSize.min,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SlideTransition(
                                      position: _mainTextSlideAnimation,
                                      child: Text(
                                        //key: mainTextPos,
                                        widget.mainText,
                                        style: TextStyle(
                                          fontSize: maxSize * 0.22,
                                          fontWeight: FontWeight.w700,
                                          height: 0.92,
                                          color: const Color(0xFFEEEEEE),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    if(widget.supportText != null)...[
                                      SlideTransition(
                                        position: _supportTextSlideAnimation,
                                        child: Text(
                                          //key: supportTextPos,
                                          widget.supportText!,
                                          style: TextStyle(
                                            fontSize: maxSize * 0.14,
                                            fontWeight: FontWeight.w400,
                                            height: 0.92,
                                            color: const Color(0xFFEEEEEE),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: SizeTransition(
                                  sizeFactor:
                                  Tween<double>(
                                    begin: 0,
                                    end: 1
                                    ).animate(CurvedAnimation(
                                      parent: _clickController,
                                      curve: Curves.easeOutCubic,
                                    )
                                  ),
                                  axis: Axis.vertical,
                                  child: SizedBox(
                                    height: maxSize,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEEEEE)
                                      ),
                                      width: maxSize,
                                      child: SizedBox(
                                        height: maxSize,
                                        //width: maxSize,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.mainText,
                                              style: TextStyle(
                                                fontSize: maxSize * 0.22,
                                                fontWeight: FontWeight.w700,
                                                height: 0.92,
                                                color: const Color(0xFF404040),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                            if(widget.supportText != null)...[
                                              Text(
                                                widget.supportText!,
                                                style: TextStyle(
                                                  fontSize: maxSize * 0.14,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0.92,
                                                  color: const Color(0xFF404040),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              )
                                            ]
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    );
  }
}