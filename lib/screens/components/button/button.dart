import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/button/components/content.dart';
import 'package:refashioned_app/screens/components/button/components/decoration.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/button/data/state_data.dart';

class RefashionedButton extends StatefulWidget {
  final RBData data;
  final EdgeInsets padding;

  const RefashionedButton({this.data, this.padding});

  @override
  _RefashionedButtonState createState() => _RefashionedButtonState();
}

class _RefashionedButtonState extends State<RefashionedButton> with TickerProviderStateMixin {
  AnimationController animationPressController;
  Animation<double> animationPress;

  AnimationController animationController;
  Animation<double> animation;
  Animation<double> animationIn;
  Animation<double> animationOut;

  RBStateData currentData;
  RBStateData nextData;

  int stackIndex;

  bool awaiting;

  @override
  initState() {
    if (widget.data.animatePress) {
      animationPressController =
          AnimationController(vsync: this, duration: Duration(milliseconds: (widget.data.duration / 4).round()));
      animationPress = Tween(begin: 1.0, end: 0.99).animate(animationPressController);
    }

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.data.duration));

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    animationOut = CurvedAnimation(
      parent: animation,
      curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
    );
    animationIn = CurvedAnimation(
      parent: animation,
      curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
    );

    stackIndex = 0;

    awaiting = false;

    nextData = currentData = widget.data.stateData;

    widget.data.addListener(dataListener);

    animationOut.addListener(animationOutListener);

    super.initState();
  }

  dataListener() {
    setState(() {
      nextData = widget.data.stateData;

      stackIndex = 0;
    });

    animationController.forward(from: 0.0).then((value) => setState(() => currentData = nextData));
  }

  animationOutListener() {
    if (animationOut.value == 1.0) setState(() => stackIndex = 1);
  }

  @override
  dispose() {
    widget.data.removeListener(dataListener);

    animationOut.removeListener(animationOutListener);

    animationController?.dispose();

    animationPressController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) return SizedBox();

    return ChangeNotifierProvider<RBData>(
      create: (_) => widget.data,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) {
          if (widget.data.animatePress) animationPressController.forward();
        },
        onPanDown: (_) {
          if (widget.data.animatePress) animationPressController.forward();
        },
        onTapUp: (_) {
          if (widget.data.animatePress) animationPressController.reverse();
        },
        onPanEnd: (_) {
          if (widget.data.animatePress) animationPressController.reverse();
        },
        onTap: () async {
          if (widget.data.available.value) currentData.onTap?.call();
        },
        child: ScaleTransition(
          scale: animationPress,
          child: Container(
            height: widget.data.height,
            padding: widget.padding ?? EdgeInsets.zero,
            child: ButtonContainer(
              currentData: currentData.decoration,
              nextData: nextData.decoration,
              animation: animation,
              child: IndexedStack(
                sizing: StackFit.expand,
                index: stackIndex,
                alignment: Alignment.center,
                children: [
                  RBContent(
                    data: currentData,
                    animateTitle: nextData.animateTitleOut,
                    animateCaption: nextData.animateCaptionOut,
                    animateIcon: nextData.animateIconOut,
                    animation: animationOut,
                    direction: RBContentAnimationDirection.animationOut,
                  ),
                  RBContent(
                    data: nextData,
                    animation: animationIn,
                    animateTitle: nextData.animateTitleIn,
                    animateCaption: nextData.animateCaptionIn,
                    animateIcon: nextData.animateIconIn,
                    direction: RBContentAnimationDirection.animationIn,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
