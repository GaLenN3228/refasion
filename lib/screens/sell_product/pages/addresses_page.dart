import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/screens/components/button.dart';
import 'package:refashioned_app/screens/sell_product/components/map.dart';

class AddressesPage extends StatelessWidget {
  final Function() onPush;

  const AddressesPage({Key key, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          Row(
            children: [
              SizedBox(
                width: 4,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.of(context).pop,
                child: SvgPicture.asset(
                  "assets/back.svg",
                  color: Color(0xFF222222),
                  width: 44,
                ),
              ),
              Expanded(
                  child: Container(
                      height: 35,
                      child: Center(
                        child: Text(
                          "НОВЫЙ АДРЕС",
                          style: Theme.of(context).textTheme.headline2.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ))),
              Padding(
                padding: const EdgeInsets.only(left: 3, right: 16),
                child: SvgPicture.asset(
                  'assets/filter.svg',
                  color: Colors.black,
                  width: 44,
                  height: 44,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
              child: Stack(children: [
                Expanded(
                  child: Container(
                    child: MapsPage(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: Container(
                      color: Colors.white,
                      height: 160,
                      child: Column(children: [
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
                            "ВВЕСТИ АДРЕС",
                            buttonStyle: ButtonStyle.amber,
                            height: 45,
                            width: double.infinity,
                            borderRadius: 5,
                            onClick: onPush,
                          ),
                        )
                      ]),
                    ),
                  ),
                )
              ]))
        ],
      ),
    );
  }
}
