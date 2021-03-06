import 'package:flutter/foundation.dart';
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
  final double bottomPadding;
  final bool enabled;

  const BottomButton(
      {Key key,
      this.action,
      this.subtitle,
      this.title,
      this.backgroundColor,
      this.titleColor,
      this.subtitleColor,
      this.height: 45.0,
      this.enabled: true,
      this.bottomPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 0, 20, bottomPadding ?? (defaultTargetPlatform == TargetPlatform.iOS ? MediaQuery.of(context).padding.bottom : 20)),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: enabled ? action : () {},
          child: Opacity(
            opacity: enabled ? 1.0 : 0.25,
            child: Container(
              height: height,
              decoration: ShapeDecoration(
                color: backgroundColor ?? primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  title != null
                      ? Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: titleColor ?? Colors.white),
                        )
                      : SizedBox(),
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
        ),
      ),
    );
  }
}
