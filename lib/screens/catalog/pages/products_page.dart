import 'package:flutter/material.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';

import '../../../utils/colors.dart';

class ProductsPage extends StatelessWidget {
  final Function(Product) onPush;
  final Function() onPop;

  const ProductsPage({Key key, this.onPush, this.onPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopPanel(
          canPop: true,
          onPop: onPop,
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onPush(null),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Страница каталога",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Нажмите, чтобы открыть\nстраницу товара",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: lightGrayColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
