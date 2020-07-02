import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/catalog/pages/category_page.dart';
import '../../../models/catalog.dart';

class CatalogTile extends StatelessWidget {
  final Catalog catalog;

  const CatalogTile({Key key, this.catalog}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoryPage(catalog: catalog)));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 12),
        child: SizedBox(
          height: 50,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                catalog.name,
                style: Theme.of(context).textTheme.headline2,
              )),
        ),
      ),
    );
  }
}
