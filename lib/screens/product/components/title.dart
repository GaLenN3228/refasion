import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle headline2 = textTheme.headline2;
    TextStyle bodyText2 = textTheme.bodyText2;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text("Платье свободного кроя", style: headline2,),
      subtitle: Text("O'STIN", style: bodyText2),
    );
  }
}
