import 'package:flutter/material.dart';
import 'package:refashioned_app/models/catalog.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/search/components/result_tile.dart';
import 'package:refashioned_app/screens/catalog/search/components/search_top_panel.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Catalog> catalogs;
  String searchQuery;

  @override
  void initState() {
    catalogs = loadCatalogItems();
    searchQuery = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child:  SearchTopPanel(
            onUpdate: (query, results) {
              print(query.toString() +
                  ": " +
                  results.length.toString() +
                  " search results");
              setState(() {
                searchQuery = query;
                catalogs = results;
              });
            },

          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: catalogs.length,
            itemBuilder: (context, index) => ResultTile(
              query: searchQuery,
              catalog: catalogs.elementAt(index),
            ),
            separatorBuilder: (context, _) => CategoryDivider(),
          ),
        )
      ],
    );
  }
}
