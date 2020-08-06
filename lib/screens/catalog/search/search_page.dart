import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/search/search_page_content.dart';
import 'package:refashioned_app/screens/components/catalog_navigator.dart';
import 'package:refashioned_app/screens/product/pages/product.dart';
import 'package:refashioned_app/screens/products/pages/products.dart';

class SearchPage extends StatelessWidget {
  final Function(SearchResult) onClick;

  const SearchPage({Key key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRepository>(
        create: (_) => SearchRepository(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SearchPageContent(onClick: (searchResult) {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => ProductsPage(
                  onSearch: () => {SearchPage()},
                  searchResult: searchResult,
                  onPush: (product) => Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => (ProductPage(id: product.id)),
                      settings: RouteSettings(name: CatalogNavigatorRoutes.products))),
                ),
              ));
            }),
          ),
        ));
  }
}
