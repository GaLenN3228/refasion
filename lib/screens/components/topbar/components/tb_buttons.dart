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

  const TBButtons({Key key, this.align, this.leftButton, this.rightButton, this.buttonsWidth, this.maxButtonsCount: 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isText = leftButton?.label != null || rightButton?.label != null;
    final isIcon = leftButton?.iconType != null || rightButton?.iconType != null;

    if (leftButton == null && rightButton == null) return SizedBox();

    EdgeInsets leftIconPadding = EdgeInsets.zero;
    EdgeInsets rightIconPadding = EdgeInsets.zero;

    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
    Alignment alignment = Alignment.centerLeft;

    switch (align) {
      case TBButtonsAlign.left:
        leftIconPadding = EdgeInsets.only(
          left: isText ? 20 : isIcon ? 10 : 0,
          right: isText ? 20 : isIcon ? 10 : 0,
        );
        rightIconPadding = EdgeInsets.only(
          left: isText ? 10 : isIcon ? 10 : 0,
          right: isText ? 10 : isIcon ? 10 : 0,
        );

        break;
      case TBButtonsAlign.right:
        leftIconPadding = EdgeInsets.only(
          left: isText ? 10 : isIcon ? 10 : 0,
          right: isText ? 10 : isIcon ? 10 : 0,
        );
        rightIconPadding = EdgeInsets.only(
          left: isText ? 20 : isIcon ? 10 : 0,
          right: isText ? 20 : isIcon ? 10 : 0,
        );

        alignment = Alignment.centerRight;
        mainAxisAlignment = MainAxisAlignment.end;
        break;
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        TBButton(
          padding: leftIconPadding,
          alignment: alignment,
          data: leftButton,
        ),
        TBButton(
          padding: rightIconPadding,
          alignment: alignment,
          data: rightButton,
        ),
      ],
    );
  }
}
