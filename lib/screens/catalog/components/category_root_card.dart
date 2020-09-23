import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';

class CategoryRootCard extends StatelessWidget {
  final Category category;
  final Function() onPush;

  const CategoryRootCard({Key key, this.category, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (category != null) onPush();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
        child: Stack(
          children: [
            Container(
              height: 100,
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 10),
                  child: category != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (category.name ?? "Нет заголовка").toUpperCase(),
                              style: Theme.of(context).textTheme.headline1.copyWith(
                                    color: Color(0xFF222222),
                                  ),
                            ),
                            category.image != null && category.image.isNotEmpty
                                ? Image.network(
                                    category.image,
                                    height: 100,
                                  )
                                : SizedBox(),
                          ],
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
            ),
          ],
        ),
      ),
    );
  }
}
