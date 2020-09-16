import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/screens/catalog/components/category_root_card.dart';
import 'package:refashioned_app/utils/colors.dart';

class CatalogRootPage extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onPush;
  final Function() onFavouritesClick;

  const CatalogRootPage({Key key, this.categories, this.onPush, this.onFavouritesClick})
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
      children: category.children
          .map((category) => CategoryRootCard(
                category: category,
                onPush: () => onPush(category),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                expandedHeight: 50,
                primary: false,
                pinned: true,
                floating: true,
                flexibleSpace: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0xFFE6E6E6), width: 1))),
                ),
                elevation: 8.0,
                forceElevated: innerViewIsScrolled,
                bottom: TabBar(
                  labelPadding: EdgeInsets.zero,
                  tabs: categories
                      .map(
                        (e) => Tab(
                          text: e.name.toUpperCase(),
                        ),
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
                  unselectedLabelColor: darkGrayColor,
                  labelColor: primaryColor,
                  indicatorColor: accentColor,
                  indicatorWeight: 3,
                ),
              ),
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
