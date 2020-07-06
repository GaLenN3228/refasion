import 'dart:collection';

import 'package:flutter/material.dart';

class ProductProperty {
  final String name;
  final String value;

  ProductProperty({@required this.name, @required this.value});
}

class ProductPropertiesData {
  final List<ProductProperty> _data = [
    ProductProperty(name: "Артикул", value: "11645818"),
    ProductProperty(name: "Размер", value: "44"),
    ProductProperty(name: "Цвет", value: "Синий"),
    ProductProperty(name: "Состав", value: "Вискоза 100%"),
    ProductProperty(name: "Тип рукава", value: "3/4"),
    ProductProperty(name: "Длина", value: "130.5 см"),
    ProductProperty(name: "Покрой", value: "Приталенный"),
  ];

  UnmodifiableListView<ProductProperty> get data => UnmodifiableListView(_data);
}

class ProductProperties extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductPropertiesData attributes = ProductPropertiesData();
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: attributes.data
          .map((attribute) => Row(
                children: <Widget>[
                  Expanded(
                      child: Opacity(
                    opacity: 0.58,
                    child: Container(
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                        alignment: Alignment.lerp(Alignment.bottomCenter, Alignment.center, 0.4),
                        repeat: ImageRepeat.repeatX,
                        image: new AssetImage(
                          'assets/dots.png',
                        ),
                      )),
                      child: Text(
                        attribute.name,
                        style: textTheme.bodyText2.copyWith(backgroundColor: Colors.white,
                            height: 2),
                      ),
                    ),
                  )),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(attribute.value, style: textTheme.bodyText1.copyWith(
                        height: 2)),
                  ))
                ],
              ))
          .toList(),
    );
  }
}
