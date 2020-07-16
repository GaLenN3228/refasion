import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/search/search_page_content.dart';

class SearchPage extends StatelessWidget {
  final Function() onPop;
  final String id;

  const SearchPage({Key key, this.onPop, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRepository>(
      create: (_) => SearchRepository(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SearchPageContent()
        ),
      ),
    );
  }
}
