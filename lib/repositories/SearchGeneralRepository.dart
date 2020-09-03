import 'dart:io';

import 'base.dart';

enum SearchStatus { QUERY, EMPTY_QUERY, EMPTY_DATA }

class SearchGeneralRepository<T> extends BaseRepository<T> {
  String query = "";
  String previousQuery;

  SearchStatus searchStatus = SearchStatus.EMPTY_QUERY;

  Future<void> callSearchApi(String query, Future<void> execute()) async {
    this.query = query;
    if (variousQueries()) {
      if (query == null || query.isEmpty) {
        searchStatus = SearchStatus.EMPTY_QUERY;
        notifyListeners();
        return;
      }

      await apiCall(() async {
        await execute();
      });

      if (getStatusCode == HttpStatus.badRequest)
        searchStatus = SearchStatus.EMPTY_DATA;
      else
        searchStatus = SearchStatus.QUERY;

      notifyListeners();

      previousQuery = query;
    }
  }

  bool variousQueries() => query != previousQuery;
}
