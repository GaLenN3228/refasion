import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';

class CategoryImage extends StatelessWidget {
  final Category category;
  final String count;
  final Function() onProductsClick;

  const CategoryImage({Key key, this.category, this.count, this.onProductsClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onProductsClick(),
        child: Stack(
          children: [
            Container(
                child: category.image != null && category.image.isNotEmpty
                    ? Image.network(
                        category.image,
                        fit: BoxFit.cover,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Image.asset(
                        'assets/images/png/dresses.png',
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )),
            Positioned.fill(
                child: Container(
              color: Colors.black.withOpacity(0.4),
            )),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(category.name.toUpperCase(),
                      style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(count ?? "", style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Смотреть все товары >",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(color: Color(0xFFFAD24E)),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
