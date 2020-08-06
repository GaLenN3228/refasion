import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/search/search_page_content.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchRepository>(
      create: (_) => SearchRepository(),
      child: CupertinoPageScaffold(
        child: SearchPageContent(),
      ),
    );
  }
}
