import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/property.dart';

class ProductProperties extends StatelessWidget {
  final List<Property> properties;
  final String article;

  const ProductProperties({Key key, @required this.properties, @required this.article})
      : super(key: key);

  Widget _renderPropertyRow(TextTheme textTheme,
          {String name = "Не указан", String value = "Не указан"}) =>
      Row(
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
                StringUtils.capitalize(name),
                style: textTheme.bodyText2.copyWith(backgroundColor: Colors.white, height: 2),
              ),
            ),
          )),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(left: 18),
            child:
                Text(StringUtils.capitalize(value), style: textTheme.bodyText1.copyWith(height: 2)),
          ))
        ],
      );

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Widget> propertiesRows = [_renderPropertyRow(textTheme, name: "Артикул", value: article)];
    propertiesRows.addAll(properties.map((attribute) =>
        _renderPropertyRow(textTheme, name: attribute.property, value: attribute.value)));
    return Column(
      children: propertiesRows.toList(),
    );
  }
}
