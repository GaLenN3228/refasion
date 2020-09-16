import 'package:flutter/material.dart';
import 'package:refashioned_app/models/property.dart';

class ProductPropertyTile extends StatelessWidget {
  final Property property;

  const ProductPropertyTile({Key key, this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    property.property,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        alignment: Alignment.bottomCenter,
                        repeat: ImageRepeat.repeatX,
                        image: new AssetImage(
                          'assets/images/png/dots.png',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            flex: 1,
            child: Text(
              property.value,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
