import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/pages/category_page.dart';
import '../../../models/category.dart';

class CatalogTile extends StatelessWidget {
  final Category category;

  const CatalogTile({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoryPage(category: category)));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 12),
        child: SizedBox(
          height: 50,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.headline2,
              )),
        ),
      ),
    );
  }
}
