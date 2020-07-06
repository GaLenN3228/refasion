import 'package:flutter/material.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/screens/catalog/components/category_brands.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/components/category_image.dart';
import '../../../models/category.dart';
import '../components/category_tile.dart';
import 'package:provider/provider.dart';

class CategoriesPageContent extends StatelessWidget {
  final Category parentCategory;

  const CategoriesPageContent({Key key, this.parentCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = List<Category>();
    final widgets = List<Widget>();

    if (parentCategory == null) {
      final catalogRepository = context.watch<CatalogRepository>();

      if (catalogRepository.isLoading)
        return Center(
          child: Text("Загрузка"),
        );

      if (catalogRepository.loadingFailed)
        return Center(
          child: Text("Ошибка"),
        );

      if (catalogRepository.catalogResponse.status.code != 200)
        return Center(
          child: Text("Иной статус"),
        );

      categories.addAll(catalogRepository.catalogResponse.categories);

      if (categories.isEmpty)
        return Center(
          child: Text("Нет каталогов"),
        );
    } else {
      categories.addAll(parentCategory.children);

      if (categories.isEmpty)
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Каталог товаров\nиз категории",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              parentCategory.name,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            )
          ],
        );

      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryImage(
            category: parentCategory,
          ),
          CategoryBrands()
        ],
      ));
    }

    widgets.addAll(categories
        .map((catalog) => CategoryTile(
              category: catalog,
              uppercase: parentCategory == null,
            ))
        .toList());

    return ListView.separated(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 44, bottom: 100),
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        return widgets.elementAt(index);
      },
      separatorBuilder: (context, index) {
        return CategoryDivider();
      },
    );
  }
}
