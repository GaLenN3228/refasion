import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/search/search_page_content.dart';

class SearchPage extends StatelessWidget {
  final Function() onPop;
  final String id;
  final Function(SearchResult) onClick;

  const SearchPage({Key key, this.onPop, this.id, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRepository>(
      create: (_) => SearchRepository(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: SearchPageContent(onClick: onClick)),
      ),
    );
  }
}
