import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/sell_product/components/brand_tile.dart';
import 'package:refashioned_app/screens/sell_product/components/search_panel.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class BrandPage extends StatelessWidget {
  final Function(Brand) onPush;
  final Function() onClose;

  const BrandPage({this.onPush, this.onClose});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRepository>(
      create: (_) => SearchRepository(),
      child: CupertinoPageScaffold(
        child: Column(
          children: <Widget>[
            RefashionedTopBar(
              leftButtonType: TBButtonType.icon,
              leftButtonIcon: TBIconType.back,
              leftButtonAction: () => Navigator.of(context).pop(),
              middleType: TBMiddleType.title,
              middleTitleText: "Добавить вещь",
              rightButtonType: TBButtonType.text,
              rightButtonText: "Закрыть",
              rightButtonAction: onClose,
              bottomType: TBBottomType.header,
              bootomHeaderText: "Выберите бренд",
            ),
            Builder(
              builder: (context) {
                final repository =
                    Provider.of<SearchRepository>(context, listen: false);

                return SearchPanel(
                  onUpdate: (query) => repository.search(query),
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
                      .map((result) => Brand(id: result.id, name: result.name))
                      .toList();

                  if (results.isEmpty)
                    return Center(
                      //TODO init local variable `search`
//                      child: repository.query.isNotEmpty
//                          ? Text("Ничего не найдено",
//                              style: Theme.of(context).textTheme.bodyText1)
//                          : SizedBox(),
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
