import 'package:flutter/material.dart';
import 'package:refashioned_app/models/brand.dart';

class BrandTile extends StatelessWidget {
  final Brand brand;
  final Function() onPush;

  const BrandTile({Key key, this.brand, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPush,
      child: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 11.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 9),
              child: SizedBox(
                width: 55,
                child: brand.image != null && brand.image.isNotEmpty
                    ? Image.network(
                        brand.image,
                        fit: BoxFit.fitWidth,
                      )
                    : SizedBox(),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(brand.name,
                      style: Theme.of(context).textTheme.subtitle1),
                  Text("Бренд", style: Theme.of(context).textTheme.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
