import 'package:flutter/material.dart';
import 'package:refashioned_app/models/property.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/product/components/properties.dart';

class ProductDescription extends StatelessWidget {
  final String description;
  final String article;
  final List<Property> properties;

  const ProductDescription(
      {Key key,
      @required this.description,
      @required this.article,
      @required this.properties})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (description == null && article == null && properties == null)
      return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Text(
            description ?? "Описание отсутствует",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        ProductProperties(
          properties: properties,
          article: article,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ItemsDivider(
            padding: 0,
          ),
        ),
      ],
    );
  }
}
