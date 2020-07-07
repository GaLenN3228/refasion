import 'package:flutter/material.dart';
import '../../../models/category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final bool uppercase;

  const CategoryTile({Key key, this.category, this.uppercase: false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 12),
      child: SizedBox(
        height: 50,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              uppercase ? category.name.toUpperCase() : category.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w500),
            )),
      ),
    );
  }
}
