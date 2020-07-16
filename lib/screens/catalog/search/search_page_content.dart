import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/search/components/result_tile.dart';
import 'package:refashioned_app/screens/catalog/search/components/search_top_panel.dart';

class SearchPageContent extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPageContent> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SearchRepository searchRepository = context.watch<SearchRepository>();
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: SearchTopPanel(
            onUpdate: (query) {
              searchRepository.query = query;
              searchRepository.refreshData();
              searchQuery = query;
            },
          ),
        ),
        if (searchRepository.searchResponse != null && searchRepository.searchResponse.content.results.length > 0)
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: searchRepository.searchResponse.content.results.length,
              itemBuilder: (context, index) => ResultTile(
                query: searchQuery,
                searchResult: searchRepository.searchResponse.content.results.elementAt(index),
              ),
              separatorBuilder: (context, _) => CategoryDivider(),
            ),
          )
      ],
    );
  }
}
