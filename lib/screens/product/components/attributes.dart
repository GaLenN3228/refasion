import 'dart:collection';

import 'package:flutter/material.dart';

class ProductAttribute {
  final String name;
  final String value;

  ProductAttribute({@required this.name, @required this.value});
}

class ProductAttributeData {
  final List<ProductAttribute> _data = [
    ProductAttribute(name: "Артикул", value: "11645818"),
    ProductAttribute(name: "Размер", value: "44"),
    ProductAttribute(name: "Цвет", value: "Синий"),
    ProductAttribute(name: "Состав", value: "Вискоза 100%"),
    ProductAttribute(name: "Тип рукава", value: "3/4"),
    ProductAttribute(name: "Длина", value: "130.5 см"),
    ProductAttribute(name: "Покрой", value: "Приталенный"),
  ];

  UnmodifiableListView<ProductAttribute> get data => UnmodifiableListView(_data);
}

class ProductAttributes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductAttributeData attributes = ProductAttributeData();
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
                        style: TextStyle(backgroundColor: Colors.white),
                      ),
                    ),
                  )),
                  Flexible(child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(attribute.value),
                  ))
                ],
              ))
          .toList(),
    );
  }
}
