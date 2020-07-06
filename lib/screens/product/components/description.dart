import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/product/components/properties.dart';

class ProductDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Text("Отличное состояние, одевала пару раз, не требует"
              " глажки, что очень удобно в носке, причина продажи "
              "маловато", style: Theme.of(context).textTheme.bodyText1,),
        ),
        ProductProperties()
      ],
    );
  }
}
