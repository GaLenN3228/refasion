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
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        height: 210,
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
                "Адрес пункта выдачи",
                style: textTheme.headline1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 20.0, left: 20),
              child: Text(
                point.type.toUpperCase(),
                style: textTheme.subtitle1,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 6, left: 20, right: 16),
                child: Row(children: [
                  Container(
                      child: Text(
                    "Адрес:",
                    style: textTheme.bodyText2,
                    maxLines: 1,
                  )),
                  Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: Text(
                        point.address,
                        style: textTheme.subtitle1,
                        maxLines: 1,
                      )),
                ])),
            Container(
                margin: const EdgeInsets.only(top: 4, left: 20, right: 16),
                child: Row(children: [
                  Container(
                      child: Text(
                    "Время работы:",
                    style: textTheme.bodyText2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: Text(
                          point.workSchedule,
                          style: textTheme.subtitle1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                  )
                ])),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 22, right: 22),
              child: Button(
                "ОТНЕСУ СЮДА",
                buttonStyle: ButtonStyle.dark,
                height: 45,
                width: double.infinity,
                borderRadius: 5,
                onClick: onPush,
              ),
            )
          ],
        ),
      ),
    );
  }
}
