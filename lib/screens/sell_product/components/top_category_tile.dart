import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';

class TopCategoryTile extends StatelessWidget {
  final Function(Category) onPush;
  final Category topCategory;

  const TopCategoryTile({Key key, this.onPush, this.topCategory})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onPush != null) onPush(topCategory);
      },
      child: SizedBox(
        height: 49,
        child: Center(
          child: Text(
            topCategory.name.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
