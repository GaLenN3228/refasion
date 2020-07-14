import 'package:flutter/material.dart';
import 'package:refashioned_app/models/catalog.dart';

class ResultTile extends StatelessWidget {
  final Catalog catalog;
  final String query;

  const ResultTile({Key key, this.catalog, this.query}) : super(key: key);

  List<String> splitResult() {
    if (query.isNotEmpty) {
      final queryStart =
          catalog.name.toLowerCase().indexOf(query.toLowerCase());
      final queryEnd = queryStart + query.length;

      final prevString = catalog.name.substring(0, queryStart);
      final queryString = catalog.name.substring(queryStart, queryEnd);
      final nextString = catalog.name.substring(queryEnd);

      return [prevString, queryString, nextString];
    } else
      return [catalog.name];
  }

  @override
  Widget build(BuildContext context) {
    final splitted = splitResult();
    final textTheme = Theme.of(context).textTheme.bodyText1;

    if (splitted.length != 3)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Text(catalog.name, style: textTheme),
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
}
