import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/components/button.dart';

class PickupPointAddress extends StatelessWidget {
  final Function() onPush;
  final PickPoint point;

  const PickupPointAddress({Key key, this.onPush, this.point}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 6),
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 13,
              ),
              Container(
                width: 30,
                height: 3,
                decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 10.0, left: 20),
            child: Text(
              "Адрес доставки",
              style: textTheme.headline1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 20.0, left: 20),
            child: Text(
              "г.Москва, ул. Академика Янгеля, д. №1, кор. №1",
              style: textTheme.subtitle1,
            ),
          ),
//          Container(
//              margin: const EdgeInsets.only(top: 6, left: 20, right: 16),
//              child: Row(children: [
//                Container(
//                    child: Text(
//                  "Адрес:",
//                  style: textTheme.bodyText2,
//                  maxLines: 1,
//                )),
//                Expanded(
//                    child: Container(
//                        margin: const EdgeInsets.only(left: 4),
//                        child: Text(
//                          "point.address",
//                          style: textTheme.subtitle1,
//                          overflow: TextOverflow.ellipsis,
//                          maxLines: 1,
//                        ))),
//              ])),
//          Container(
//              margin: const EdgeInsets.only(top: 4, left: 20, right: 16),
//              child: Row(children: [
//                Container(
//                    child: Text(
//                  "Время работы:",
//                  style: textTheme.bodyText2,
//                  maxLines: 1,
//                  overflow: TextOverflow.ellipsis,
//                )),
//                Expanded(
//                  child: Container(
//                      margin: const EdgeInsets.only(left: 4),
//                      child: Text(
//                        "point.workSchedule",
//                        style: textTheme.subtitle1,
//                        maxLines: 1,
//                        overflow: TextOverflow.ellipsis,
//                      )),
//                )
//              ])),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 22, right: 22),
            child: Button(
              "ПРИВЕЗТИ СЮДА",
              buttonStyle: ButtonStyle.dark,
              height: 45,
              width: double.infinity,
              borderRadius: 5,
              onClick: onPush,
            ),
          )
        ],
      ),
    ));
  }
}
