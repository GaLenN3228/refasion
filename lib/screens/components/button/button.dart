import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_icon.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';

class ButtonData {
  final ButtonContainerData buttonContainerData;

  final ButtonIconData leftIconData;

  final ButtonIconData rightIconData;

  final ButtonTitleData titleData;

  ButtonData(
      {this.leftIconData,
      this.rightIconData,
      this.titleData,
      this.buttonContainerData})
      : assert(buttonContainerData != null &&
            (titleData != null ||
                leftIconData != null ||
                rightIconData != null));
}

enum ButtonState { enabled, loading, done, error, disabled }

class RefashionedButton extends StatefulWidget {
  final ButtonData data;

  final ValueNotifier<ButtonState> states;
  final Map<ButtonState, ButtonData> statesData;

  final Function() onTap;

  final bool animateContent;

  final double height;

  const RefashionedButton({
    this.states,
    this.data,
    this.statesData,
    this.onTap,
    this.animateContent: true,
    this.height: 45,
  }) : assert(data != null || (statesData != null && states != null));

  @override
  _RefashionedButtonState createState() => _RefashionedButtonState();
}

class _RefashionedButtonState extends State<RefashionedButton>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  Animation<double> animationIn;
  Animation<double> animationOut;

  ButtonData currentData;
  ButtonData nextData;

  @override
  initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationOut = CurvedAnimation(
      parent: animation,
      curve: Interval(0.0, 0.5, curve: Curves.easeIn),
    );
    animationIn = CurvedAnimation(
      parent: animation,
      curve: Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    nextData = currentData = widget.states != null && widget.statesData != null
        ? widget.statesData[widget.states.value]
        : widget.data;

    widget.states?.addListener(buttonStateListener);

    super.initState();
  }

  buttonStateListener() {
    setState(
        () => nextData = widget.statesData[widget.states.value] ?? widget.data);

    animationController
        .forward(from: 0.0)
        .then((_) => setState(() => currentData = nextData));
  }

  @override
  dispose() {
    widget.states?.removeListener(buttonStateListener);

    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap ?? () {},
      child: SizedBox(
        height: widget.height,
        child: ButtonContainer(
          currentData: currentData.buttonContainerData,
          nextData: nextData.buttonContainerData,
          animation: animation,
          child: widget.animateContent
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    FadeTransition(
                      opacity:
                          Tween(begin: 1.0, end: 0.0).animate(animationOut),
                      child: SlideTransition(
                        position: Tween(begin: Offset.zero, end: Offset(-1, 0))
                            .animate(animationOut),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ButtonIcon(
                              currentData: currentData.leftIconData != null
                                  ? ButtonIconData(
                                      icon: currentData.leftIconData.icon,
                                      color: currentData.leftIconData.color,
                                    )
                                  : ButtonIconData(icon: ButtonIconType.none),
                              align: ButtonIconAlign.left,
                            ),
                            ButtonTitle(
                              currentData: ButtonTitleData(
                                text: currentData.titleData.text,
                                color: currentData.titleData.color,
                              ),
                            ),
                            ButtonIcon(
                              currentData: currentData.rightIconData != null
                                  ? ButtonIconData(
                                      icon: currentData.rightIconData.icon,
                                      color: currentData.rightIconData.color,
                                    )
                                  : ButtonIconData(icon: ButtonIconType.none),
                              align: ButtonIconAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: Tween(begin: 0.0, end: 1.0).animate(animationIn),
                      child: SlideTransition(
                        position: Tween(begin: Offset(1, 0), end: Offset.zero)
                            .animate(animationIn),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ButtonIcon(
                              currentData: nextData.leftIconData != null
                                  ? ButtonIconData(
                                      icon: nextData.leftIconData.icon,
                                      color: nextData.leftIconData.color,
                                    )
                                  : ButtonIconData(icon: ButtonIconType.none),
                              align: ButtonIconAlign.left,
                            ),
                            ButtonTitle(
                              currentData: ButtonTitleData(
                                text: nextData.titleData.text,
                                color: nextData.titleData.color,
                              ),
                            ),
                            ButtonIcon(
                              currentData: nextData.rightIconData != null
                                  ? ButtonIconData(
                                      icon: nextData.rightIconData.icon,
                                      color: nextData.rightIconData.color,
                                    )
                                  : ButtonIconData(icon: ButtonIconType.none),
                              align: ButtonIconAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ButtonIcon(
                      currentData: currentData.leftIconData != null
                          ? ButtonIconData(
                              icon: currentData.leftIconData.icon,
                              color: currentData.leftIconData.color,
                            )
                          : ButtonIconData(icon: ButtonIconType.none),
                      align: ButtonIconAlign.left,
                    ),
                    ButtonTitle(
                      currentData: ButtonTitleData(
                        text: currentData.titleData.text,
                        color: currentData.titleData.color,
                      ),
                    ),
                    ButtonIcon(
                      currentData: currentData.rightIconData != null
                          ? ButtonIconData(
                              icon: currentData.rightIconData.icon,
                              color: currentData.rightIconData.color,
                            )
                          : ButtonIconData(icon: ButtonIconType.none),
                      align: ButtonIconAlign.right,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
