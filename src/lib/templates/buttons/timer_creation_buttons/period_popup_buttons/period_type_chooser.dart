import 'package:flutter/material.dart';
import 'package:yourbreak/constants/color_constants.dart';



class TimerTypeChooser extends StatefulWidget {

  const TimerTypeChooser({
    super.key
  });

  @override
  TimerTypeChooserState createState() => TimerTypeChooserState();

}


class TimerTypeChooserState extends State<TimerTypeChooser> with SingleTickerProviderStateMixin {

  final GlobalKey<TypeTextState> selectionBox = GlobalKey<TypeTextState>();

  GlobalKey<TypeTextState>? currentType;

  final GlobalKey<TypeTextState> workKey = GlobalKey<TypeTextState>();
  final GlobalKey<TypeTextState> breakKey = GlobalKey<TypeTextState>();
  final GlobalKey<TypeTextState> restKey = GlobalKey<TypeTextState>();

  void selectType(GlobalKey<TypeTextState> selectedKey) {
    setState(() {
      currentType = selectedKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = currentType?.currentContext;
        if(context != null) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final parentBox = context.findAncestorRenderObjectOfType<RenderBox>();
          if(parentBox != null) {
            final localOffset = box.localToGlobal(Offset.zero, ancestor: parentBox);
            final textWidth = box.size.width;
            final selectionBoxWidth = 50.0;

            final centeredDx = localOffset.dx + (textWidth / 2) - (selectionBoxWidth / 2);

            final previousOffset = selectionBoxOffset;
            final previousColor = selectionBoxColor;

            setState(() {
              selectionBoxOffset = Offset(centeredDx, 0);
              selectionBoxColor = getPeriodColor(selectedKey);
            });

            moveSelectionBoxAnimation = Tween<Offset>(
              begin: previousOffset,
              end: selectionBoxOffset,
            ).animate(CurvedAnimation(
              parent: selectionBoxController,
              curve: Curves.fastOutSlowIn,
            ));

            colorSelectionBoxAnimation = ColorTween(
              begin: previousColor,
              end: selectionBoxColor
            ).animate(CurvedAnimation(
              parent: selectionBoxController,
              curve: Curves.fastOutSlowIn
            ));

            selectionBoxController.forward(from: 0);
          }
        }
      });
    });
  }



  late final AnimationController selectionBoxController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 350)
  );


  Offset selectionBoxOffset = Offset.zero;

  late Animation moveSelectionBoxAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: selectionBoxOffset
  ).animate(CurvedAnimation(
    parent: selectionBoxController,
    curve: Curves.fastEaseInToSlowEaseOut
  ));



  Color getPeriodColor(GlobalKey<TypeTextState> selectedKey) {
    if (selectedKey == workKey) {
      return PureColors.orange;
    } else if (selectedKey == breakKey) {
      return PureColors.green;
    } else if (selectedKey == restKey) {
      return PureColors.blue;
    } else {
      return PureColors.white;
    }
  }

  Color selectionBoxColor = PureColors.white;

  late Animation colorSelectionBoxAnimation = ColorTween(
    begin: PureColors.white,
    end: selectionBoxColor
  ).animate(CurvedAnimation(
    parent: selectionBoxController,
    curve: Curves.fastEaseInToSlowEaseOut
  ));



  @override
  void initState() {
    super.initState();
    
    currentType = workKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectType(workKey);
    });
  }

  @override
  void dispose() {
    selectionBoxController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 37.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: PureColors.white.withValues(alpha: 0.75),
          width: 2
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                moveSelectionBoxAnimation,
                colorSelectionBoxAnimation
              ]),
              builder: (context, child) =>
              Transform.translate(
                key: selectionBox,
                offset: moveSelectionBoxAnimation.value,
                child: Container(
                  width: 50,
                  height: 28.5,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorSelectionBoxAnimation.value,
                      width: 1.75
                    ),
                    borderRadius: BorderRadius.circular(7.5)
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TypeText(key: workKey, text: "Work", onPressed: () => selectType(workKey)),
              TypeText(key: breakKey, text: "Break", onPressed: () => selectType(breakKey)),
              TypeText(key: restKey, text: "Rest", onPressed: () => selectType(restKey))
            ],
          ),
        ],
      ),
    );
  }

}


class TypeText extends StatefulWidget {

  final String text;
  final VoidCallback onPressed;

  const TypeText({
    super.key,

    required this.text,
    required this.onPressed
  });

  @override
  TypeTextState createState() => TypeTextState();

}

class TypeTextState extends State<TypeText> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 16,
          color: PureColors.white.withValues(alpha: 0.8),
          fontWeight: FontWeight.w700
        ),
        textAlign: TextAlign.center
      ),
    );
  }

}