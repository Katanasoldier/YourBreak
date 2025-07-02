import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yourbreak/templates/buttons/square_button/square_button.dart';
import 'package:yourbreak/constants/animation_constants.dart';
import 'package:yourbreak/constants/color_constants.dart';


class Header extends StatelessWidget {

  final double fontSize; 
  final String headerText;
  final Color? color;

  const Header({

    super.key,

    required this.fontSize,

    required this.headerText,

    this.color,

  });

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? PureColors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}



class TimerColumn extends StatefulWidget {

  final double fontSize; 
  final String headerText;
  final bool? hasContent;

  const TimerColumn({

    super.key,

    required this.fontSize,

    required this.headerText,

    this.hasContent

  });

  @override
  TimerColumnState createState() => TimerColumnState();

}


class TimerColumnState extends State<TimerColumn> with TickerProviderStateMixin {


  int? hoveredIndex;



  late final AnimationController pageAnimationController =
  AnimationController(
    vsync: this,
    duration: AnimationDurations.pageTransition,
    reverseDuration: AnimationDurations.pageTransition
  );


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {

    pageAnimationController.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context) {
    return widget.hasContent == false
    ? Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Header(fontSize: widget.fontSize, headerText: widget.headerText)
        ),
        Center( // LATER ADD OPTION TO EITHER CONSTRUCT WHEN CALLING THIS WIDGET TO EITHER PASS IN A (ILL THINK OF THIS) OBJECT NOTATION OR STRUCTURE I HAVE NO CLUE RIGHT NOW SORRY
          child: Header(fontSize: widget.fontSize, headerText: "Empty", color: PureColors.grey.withValues(alpha: 0.2))
        )
      ],
    )
    : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Header(fontSize: widget.fontSize, headerText: widget.headerText),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {

              //final double maxListViewWidth = constraints.maxWidth * 0.95;
              final double maxListViewHeight = constraints.maxHeight;
              
              final int defaultItemCount = 30;

              final double listElementHeight = maxListViewHeight * 0.2;
              const double listElementWidth = 0.9;
          
              const double defaultElementMargin = 2.5; 
              
              final scrollController = ScrollController();

              return Stack(
                alignment: Alignment.center,
                children: [
                  RawScrollbar(
                    thickness: 5,
                    interactive: true,
                    minOverscrollLength: 5,
                    thumbColor: PureColors.white,
                    radius: Radius.circular(4),
                    thumbVisibility: true,
                    controller: scrollController,
                    child: ListView.builder(
                      
                      itemCount: defaultItemCount,
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemBuilder:(context, index) {
                    
                        late final EdgeInsets elementMargin;
                    
                        if(index == 0){
                          elementMargin = EdgeInsets.only(bottom: defaultElementMargin);
                        } else if(index == defaultItemCount - 1) {
                          elementMargin = EdgeInsets.only(top: defaultElementMargin);
                        } else {
                          elementMargin = EdgeInsets.only(top: defaultElementMargin, bottom: defaultElementMargin);
                        }

                        return Padding(
                          padding: elementMargin,
                          child: Transform.scale(
                            scale: 0.9,
                            child: SizedBox(
                              height:listElementHeight,
                              child: SquareButton(
                                mainText: "Pomodoro",
                                mainTextGradient: [
                                  Color(0xFFFF3131),
                                  Color(0xFFFF7441)
                                ],
                                fontMultiplier: 2.1,
                                borderWidthMultiplier: 0.6,
                                borderRadiusMultiplier: 2.5,
                                hoverSize: 1.05,
                                pageAnimationController: pageAnimationController,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: maxListViewHeight * 0.15,
                    //child: ,
                  )
                ],
              );
            }
          )
        )
      ],
    );
  } 
}