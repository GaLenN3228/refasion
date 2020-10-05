import 'package:flutter/material.dart';

class DeliveryObjectDataTile extends StatelessWidget {
  final String name;
  final String value;

  const DeliveryObjectDataTile({Key key, this.name, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: name,
          style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.6),
          children: [
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.6),
            ),
          ],
        ),
      );
}
