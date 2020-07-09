import 'package:flutter/material.dart';
import 'package:refashioned_app/components/button.dart';
import 'package:refashioned_app/utils/colors.dart';

class ProductBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottomOffset = MediaQuery.of(context).padding.top;
    return Container(
      height: 50,
      padding: EdgeInsets.only(top: 7, bottom: 7 + bottomOffset, left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: lightGrayColor, width: 0)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
                height: double.infinity,
                child: Button("Купить сейчас", buttonStyle: ButtonStyle.dark)),
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
    );
  }
}
