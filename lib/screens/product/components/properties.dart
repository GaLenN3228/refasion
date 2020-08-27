import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/property.dart';

class ProductProperties extends StatelessWidget {
  final List<Property> properties;
  final String article;
  final bool hasDots;

  const ProductProperties(
      {Key key,
      @required this.properties,
      @required this.article,
      this.hasDots = true})
      : super(key: key);

  Widget _renderPropertyRow(TextTheme textTheme,
          {String name = "Не указан", String value = "Не указан"}) =>
      Row(
        children: <Widget>[
          Flexible(
              fit: hasDots ? FlexFit.tight : FlexFit.loose,
              child: Opacity(
                opacity: 0.58,
                child: Container(
                  decoration: hasDots
                      ? BoxDecoration(
                          image: new DecorationImage(
                          alignment: Alignment.lerp(
                              Alignment.bottomCenter, Alignment.center, 0.4),
                          repeat: ImageRepeat.repeatX,
                          image: new AssetImage(
                            'assets/images/png/dots.png',
                          ),
                        ))
                      : BoxDecoration(),
                  child: Text(
                    StringUtils.capitalize(name) + (hasDots ? "" : ":"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyText2
                        .copyWith(backgroundColor: Colors.white, height: 1.8),
                  ),
                ),
              )),
          Flexible(
              child: Padding(
            padding: hasDots
                ? const EdgeInsets.only(left: 18)
                : const EdgeInsets.only(left: 2),
            child: Text(StringUtils.capitalize(value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyText1.copyWith(height: 1.8)),
          ))
        ],
      );

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Widget> propertiesRows = [
      _renderPropertyRow(textTheme, name: "Артикул", value: article)
    ];
    propertiesRows.addAll(properties.map((attribute) => _renderPropertyRow(
        textTheme,
        name: attribute.property,
        value: attribute.value)));
    return Column(
      children: propertiesRows.toList(),
    );
  }
}
