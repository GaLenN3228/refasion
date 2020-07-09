import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';

class CategoryRootCard extends StatelessWidget {
  final Category category;

  const CategoryRootCard({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      child: Stack(
        children: [
          Container(
            height: 100,
            decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: category != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (category.name ?? "Нет заголовка").toUpperCase(),
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Color(0xFF222222),
                            ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ("Бренды").toUpperCase(),
                          style: Theme.of(context).textTheme.headline1.copyWith(
                                color: Color(0xFF222222),
                              ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              ("От A до Z").toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Color(0xFF959595)),
                            ),
                          ],
                        )
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
