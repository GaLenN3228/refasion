import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/repositories/search_general_repository.dart';
import 'package:refashioned_app/screens/catalog/search/components/result_tile.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/textfield/ref_textfield.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
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
          children: [
            RefashionedTopBar(
              data: TopBarData.simple(
                onBack: Navigator.of(context).pop,
                middleText: "Добавить вещь",
                onClose: widget.onClose,
                bottomText: "Выберите бренд",
              ),
            ),
            Builder(
              builder: (context) {
                final repository = Provider.of<SearchRepository>(context, listen: false);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: RefashionedTextField(
                    height: 35,
                    autofocus: true,
                    hintText: "Введите название бренда",
                    icon: IconAsset.search,
                    onSearchUpdate: (query) => repository.search(query),
                  ),
                );
              },
            ),
            Expanded(
              child: Consumer<SearchRepository>(
                builder: (context, repository, _) {
                  final searchStatus = repository.searchStatus;

                  switch (searchStatus) {
                    case SearchStatus.QUERY:
                      final results = repository.response?.content?.results
                          ?.where((result) => result.model == "brand")
                          ?.toList();

                      final query = repository.query;

                      if (results == null || results.isEmpty)
                        return Container(
                            margin: EdgeInsets.only(bottom: 190),
                            color: Colors.white,
                            child: Center(
                              child: Text("Не найдено, повторите запрос",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ));

                      return ListView.separated(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 20.0,
                        ),
                        itemCount: results.length,
                        itemBuilder: (context, index) => ResultTile(
                          searchResult: results.elementAt(index),
                          query: query,
                          onClick: (searchResult) {
                            widget.onUpdate?.call(
                              repository.query,
                              Brand(id: searchResult.id, name: searchResult.name),
                            );
                            widget.onPush?.call();
                          },
                        ),
                        separatorBuilder: (context, _) => ItemsDivider(),
                      );

                    default:
                      return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
