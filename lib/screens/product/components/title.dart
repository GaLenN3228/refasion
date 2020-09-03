import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  final String name;
  final String brand;

  const ProductTitle({Key key, @required this.name, @required this.brand})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (name == null && brand == null) return SizedBox();

    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle headline2 = textTheme.headline2;
    TextStyle bodyText2 = textTheme.bodyText2;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: headline2,
      ),
      subtitle: Text(brand, style: bodyText2),
    );
  }
}
