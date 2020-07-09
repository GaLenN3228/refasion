import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/utils/colors.dart';

class CartPromo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top:0),
          color: Color(0xFFF5F5F5),
          height: 35,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 9),
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide(width: 1, color: lightGrayColor),
                        bottom: BorderSide(width: 1, color: lightGrayColor)),
                    color: Colors.white,
                  ),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Промокод',
                          enabledBorder:InputBorder.none,
                          hintStyle: Theme.of(context).textTheme.subtitle2)),
                ),
              ),
              Button(
                "Применить",
                buttonStyle: ButtonStyle.gray,
                toUpperCase: false,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11.0),
          child: Row(
            children: <Widget>[
              Text("Посмотреть мои промокоды", style: Theme.of(context).textTheme.subtitle1),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SvgPicture.asset(
                  'assets/arrow_right.svg',
                  height: 12,
                  color: primaryColor,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
