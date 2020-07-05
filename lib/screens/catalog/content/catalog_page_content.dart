import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/products.dart';
import 'package:refashioned_app/screens/catalog/components/catalog_divider.dart';
import '../../../repositories/catalog.dart';
import '../components/catalog_tile.dart';

class CatalogPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    final catalogs = catalogRepository.catalogResponse.categories;

    if (catalogs.isEmpty)
      return Center(
        child: Text("Нет каталогов"),
      );

    final widgetsList =
        catalogs.map((catalog) => CatalogTile(category: catalog)).toList();

    return ListView.separated(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 44 + 20, bottom: 100),
      itemCount: widgetsList.length,
      itemBuilder: (context, index) {
        return widgetsList.elementAt(index);
      },
      separatorBuilder: (context, index) {
        return CatalogDivider();
      },
    );
  }
}
