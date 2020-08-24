import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/sell_product/components/brand_tile.dart';
import 'package:refashioned_app/screens/sell_product/components/search_panel.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class BrandPage extends StatefulWidget {
  final String initialQuery;
  final Brand initialData;

  final Function() onClose;
  final Function(String, Brand) onUpdate;
  final Function() onPush;

  final FocusNode focusNode;

  const BrandPage(
      {this.onPush,
      this.onClose,
      this.focusNode,
      this.initialData,
      this.onUpdate,
      this.initialQuery});

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRepository>(
      create: (_) => SearchRepository(),
      child: CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: Column(
          children: <Widget>[
            RefashionedTopBar(
              data: TopBarData.sellerPage(
                leftAction: () => Navigator.of(context).pop(),
                titleText: "Добавить вещь",
                rightAction: widget.onClose,
                headerText: "Выберите бренд",
              ),
            ),
            Builder(
              builder: (context) {
                final repository =
                    Provider.of<SearchRepository>(context, listen: false);

                return SearchPanel(
                  initialQuery: widget.initialQuery,
                  focusNode: widget.focusNode,
                  onUpdate: (query) => repository.search(query),
                );
              },
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final repository = context.watch<SearchRepository>();

                  if (widget.initialQuery != null && repository != null) {
                    repository.search(widget.initialQuery);
                  }

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
                      .map((result) => Brand(id: result.id, name: result.name))
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
                        onPush: () {
                          widget.onUpdate(
                              repository.query, results.elementAt(index));
                          widget.onPush();
                        }),
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
