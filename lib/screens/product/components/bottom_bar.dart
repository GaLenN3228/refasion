import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/button.dart';

class ProductBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                  height: double.infinity,
                  child: Button(
                    "Спросить",
                    buttonStyle: ButtonStyle.dark,
                    onClick: () {},
                  )),
            ),
            Container(
              width: 5,
            ),
            Expanded(
              child: Container(
                  height: double.infinity,
                  child: Button("В корзину", buttonStyle: ButtonStyle.amber)),
            ),
          ],
        ),
      ),
    );
  }
}
