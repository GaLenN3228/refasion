import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class BottomButton extends StatelessWidget {
  final Function() action;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final double height;

  const BottomButton(
      {Key key,
      this.action,
      this.subtitle,
      this.title,
      this.backgroundColor,
      this.titleColor,
      this.subtitleColor,
      this.height: 45.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: action,
        child: Container(
          height: height,
          decoration: ShapeDecoration(
            color: backgroundColor ?? primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: titleColor ?? Colors.white),
              ),
              subtitle != null
                  ? Text(
                      subtitle,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w300,
                          color: subtitleColor ?? Colors.white),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
