import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/catalog/components/category_root_card.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';

class CatalogRootPage extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onPush;
  final Function() onSearch;

  const CatalogRootPage({Key key, this.categories, this.onPush, this.onSearch})
      : super(key: key);

  Widget tabContent(BuildContext context, Category category) {
    if (category.children.isEmpty)
      return Center(
        child: Text(
          "Раздел пока пуст",
          style: Theme.of(context).textTheme.headline1,
        ),
      );

    return ListView(
      padding: const EdgeInsets.only(top: 7.5, bottom: 89 + 7.5),
      key: PageStorageKey<String>(category.name),
      //null element is for the Brands card
      children: [null, ...category.children]
          .map((category) => CategoryRootCard(
                category: category,
                onPush: () => onPush(category),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DefaultTabController(
        length: categories.length,
        initialIndex: max(
            0, categories.indexWhere((element) => element.children.isNotEmpty)),
        child: NestedScrollView(
          controller: ScrollController(),
          headerSliverBuilder:
              (BuildContext context, bool innerViewIsScrolled) {
            return <Widget>[
              SliverAppBar(
                titleSpacing: 0.0,
                title: TopPanel(
                  onSearch: onSearch,
                  includeTopPadding: false,
                ),
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                expandedHeight: 136.0 - MediaQuery.of(context).padding.top,
                pinned: true,
                floating: true,
                elevation: 8.0,
                forceElevated: innerViewIsScrolled,
                bottom: TabBar(
                  tabs: categories
                      .map(
                        (e) => Tab(text: e.name.toUpperCase()),
                      )
                      .toList(),
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w500),
                  unselectedLabelStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w500),
                  labelColor: Colors.black,
                  indicatorColor: Color(0xFFFAD24E),
                  indicatorWeight: 3,
                ),
              )
            ];
          },
          body: TabBarView(
            children: categories
                .map((category) => tabContent(context, category))
                .toList(),
          ),
        ),
      ),
    );
  }
}
