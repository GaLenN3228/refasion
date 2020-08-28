import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/catalog/search/components/result_tile.dart';
import 'package:refashioned_app/screens/catalog/search/components/search_top_panel.dart';

class SearchPageContent extends StatefulWidget {
  final Function(SearchResult) onClick;

  const SearchPageContent({Key key, this.onClick}) : super(key: key);

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
    return  Column(
        children: [
          SizedBox(
            height: 80,
            child: SearchTopPanel(
              onUpdate: (query) {
                searchRepository.search(searchQuery);
                searchQuery = query;
              },
            ),
          ),
          if (searchRepository.response != null &&
              searchRepository.response.content.results.length > 0)
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: searchRepository.response.content.results.length,
                itemBuilder: (context, index) => ResultTile(
                  query: searchQuery,
                  searchResult: searchRepository.response.content.results
                      .elementAt(index),
                  onClick: widget.onClick,
                ),
                separatorBuilder: (context, _) => ItemsDivider(),
              ),
            )
        ],
    );
  }
}
