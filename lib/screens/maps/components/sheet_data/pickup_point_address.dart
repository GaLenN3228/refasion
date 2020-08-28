import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button.dart';

class PickupPointAddress extends StatelessWidget {
  final Function() onPush;

  const PickupPointAddress({Key key, this.onPush}) : super(key: key);

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
        height: 160,
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
              margin: const EdgeInsets.only(top: 14.0, left: 20),
              child: Text(
                "Откуда забрать вашу вещь?",
                style: textTheme.subtitle1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 10.0, left: 20),
              child: Text(
                "Укажите на карте или введите адрес вручную",
                style: textTheme.caption,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                "ОТНЕСУ СЮДА",
                buttonStyle: ButtonStyle.amber,
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
