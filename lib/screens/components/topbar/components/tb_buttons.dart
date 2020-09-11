import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';

enum TBButtonsAlign { left, right }

class TBButtons extends StatelessWidget {
  final TBButtonsAlign align;
  final TBButtonData leftButton;
  final TBButtonData rightButton;

  final double buttonsWidth;
  final int maxButtonsCount;

  const TBButtons(
      {Key key,
      this.align,
      this.leftButton,
      this.rightButton,
      this.buttonsWidth,
      this.maxButtonsCount: 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isText = leftButton?.label != null || rightButton?.label != null;
    final isIcon =
        leftButton?.iconType != null || rightButton?.iconType != null;

    if (leftButton == null && rightButton == null)
      return SizedBox(
        width: buttonsWidth,
      );

    EdgeInsets rowPadding = EdgeInsets.zero;
    EdgeInsets buttonPadding = EdgeInsets.zero;
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;

    switch (align) {
      case TBButtonsAlign.left:
        rowPadding = EdgeInsets.only(left: isText ? 20 : isIcon ? 10 : 0);
        buttonPadding = EdgeInsets.only(right: isText ? 10 : isIcon ? 10 : 0);
        break;
      case TBButtonsAlign.right:
        rowPadding = EdgeInsets.only(right: isText ? 20 : isIcon ? 10 : 0);
        buttonPadding = EdgeInsets.only(left: isText ? 10 : isIcon ? 10 : 0);
        mainAxisAlignment = MainAxisAlignment.end;
        break;
    }

    return SizedBox(
      width: buttonsWidth,
      child: Padding(
        padding: rowPadding,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TBButton(
              padding: buttonPadding,
              data: leftButton,
            ),
            TBButton(
              padding: buttonPadding,
              data: rightButton,
            ),
          ],
        ),
      ),
    );
  }
}
