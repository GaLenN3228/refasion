import 'package:flutter/material.dart';
import 'package:refashioned_app/models/search_result.dart';

class ResultTile extends StatelessWidget {
  final SearchResult searchResult;
  final String query;

  const ResultTile({Key key, this.searchResult, this.query}) : super(key: key);

  List<String> splitResult() {
    if (query.isNotEmpty &&
        searchResult.name.toLowerCase().contains(query.toLowerCase())) {
      final queryStart =
          searchResult.name.toLowerCase().indexOf(query.toLowerCase());
      final queryEnd = queryStart + query.length;

      final prevString = searchResult.name.substring(0, queryStart);
      final queryString = searchResult.name.substring(queryStart, queryEnd);
      final nextString = searchResult.name.substring(queryEnd);

      return [prevString, queryString, nextString];
    } else
      return [searchResult.name];
  }

  @override
  Widget build(BuildContext context) {
    if (searchResult != null) {
      final splitted = splitResult();
      final textTheme = Theme.of(context).textTheme.bodyText1;

      if (splitted.length != 3)
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Text(searchResult.name, style: textTheme),
        );
      else
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: RichText(
            text: TextSpan(
              text: splitted.elementAt(0),
              style: textTheme,
              children: <TextSpan>[
                TextSpan(
                    text: splitted.elementAt(1),
                    style: textTheme.copyWith(fontWeight: FontWeight.w700)),
                TextSpan(text: splitted.elementAt(2)),
              ],
            ),
          ),
        );
    }
    return SizedBox();
  }
}
