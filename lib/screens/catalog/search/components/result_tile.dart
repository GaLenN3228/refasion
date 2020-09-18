import 'package:flutter/material.dart';
import 'package:refashioned_app/models/search_result.dart';

class ResultTile extends StatelessWidget {
  final SearchResult searchResult;
  final String query;
  final Function(SearchResult) onClick;

  const ResultTile({Key key, this.searchResult, this.query, this.onClick}) : super(key: key);

  List<String> splitResult() {
    if (query.isNotEmpty && searchResult.name.toLowerCase().contains(query.toLowerCase())) {
      final queryStart = searchResult.name.toLowerCase().indexOf(query.toLowerCase());
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

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => {onClick(searchResult)},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            (splitted.length != 3)
                ? Container(
                    margin: const EdgeInsets.only(top: 14.0, bottom: 14, left: 20),
                    child: Text(searchResult.name, style: textTheme),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 14.0, bottom: 14, left: 20),
                    child: RichText(
                      text: TextSpan(
                        text: splitted.elementAt(0),
                        style: textTheme,
                        children: <TextSpan>[
                          TextSpan(text: splitted.elementAt(1), style: textTheme.copyWith(fontWeight: FontWeight.w700)),
                          TextSpan(text: splitted.elementAt(2)),
                        ],
                      ),
                    ),
                  ),
            searchResult.extraData != null &&
                searchResult.extraData.image != null &&
                searchResult.extraData.image.isNotEmpty ?
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: SizedBox(
                height: 40,
                width: 60,
                child: Image.network(
                  searchResult.extraData.image,
                  fit: BoxFit.contain,
                ),
              ),
            ) : SizedBox(),
          ],
        ),
      );
    }
    return SizedBox();
  }
}
