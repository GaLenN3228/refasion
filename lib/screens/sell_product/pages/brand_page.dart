import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/sell_product/components/brand_tile.dart';
import 'package:refashioned_app/screens/sell_product/components/header.dart';
import 'package:refashioned_app/screens/sell_product/components/search_panel.dart';
import 'package:refashioned_app/screens/sell_product/components/top_bar.dart';

class BrandPage extends StatelessWidget {
  final Function(Brand) onPush;

  const BrandPage({Key key, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRepository>(
      create: (_) => SearchRepository(),
      child: CupertinoPageScaffold(
        child: Column(
          children: <Widget>[
            SellProductTopBar(),
            Header(
              text: "Выберите бренд",
            ),
            Builder(
              builder: (context) {
                final repository =
                    Provider.of<SearchRepository>(context, listen: false);

                return SearchPanel(
                  onUpdate: (query) => repository
                    ..query = query
                    ..refreshData(),
                );
              },
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final repository = context.watch<SearchRepository>();

                  if (repository.isLoading)
                    return Center(
                      child: Text(
                        "Выполняю поиск",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    );

                  if (repository.loadingFailed ||
                      repository.response.status.code != 200)
                    return Center(
                      child: Text("Ошибка при поиске",
                          style: Theme.of(context).textTheme.bodyText1),
                    );

                  final results = repository.response.content.results
                      .where((result) => result.model == "brand")
                      .map((result) => Brand(
                          id: result.id,
                          name: result.name))
                      .toList();

                  if (results.isEmpty)
                    return Center(
                      child: repository.query.isNotEmpty
                          ? Text("Ничего не найдено",
                              style: Theme.of(context).textTheme.bodyText1)
                          : SizedBox(),
                    );

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: results.length,
                    itemBuilder: (context, index) => BrandTile(
                        brand: results.elementAt(index),
                        onPush: () => onPush(results.elementAt(index))),
                    separatorBuilder: (context, _) => CategoryDivider(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
