import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/utils/colors.dart';

enum BorderButtonType { newCard, newAddress }

class BorderButton extends StatelessWidget {
  final Function() onTap;
  final BorderButtonType type;

  const BorderButton({Key key, this.onTap, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String text;
    double width;
    double height;

    switch (type) {
      case BorderButtonType.newCard:
        text = "Новая карта";
        width = 145;
        height = 30;
        break;
      case BorderButtonType.newAddress:
        text = "Новый адрес";
        width = 150;
        height = 30;
        break;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: BorderSide(width: 1, color: primaryColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/add_thin.svg",
              width: 12,
              height: 12,
              color: primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 9),
              child: Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
