import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SellProductTopBar extends StatelessWidget {
  final Function() onClose;
  final bool canPop;

  const SellProductTopBar({Key key, this.onClose, this.canPop: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
        SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: canPop ? Navigator.of(context).pop : () {},
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.only(left: 4),
                  alignment: Alignment.centerLeft,
                  child: canPop
                      ? SvgPicture.asset(
                          "assets/back.svg",
                          color: Color(0xFF222222),
                          width: 44,
                        )
                      : SizedBox(),
                ),
              ),
              Text(
                "Добавить вещь".toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onClose != null ? onClose : () {},
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  child: onClose != null
                      ? Text(
                          "Закрыть",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Color(0xFF959595)),
                        )
                      : SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
