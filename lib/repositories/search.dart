import 'package:dio/dio.dart';
import 'package:refashioned_app/models/search_result.dart';

import '../services/api_service.dart';
import 'base.dart';

class SearchRepository extends BaseRepository {
  SearchResultResponse searchResponse;

  String query = "";

  @override
  Future<void> loadData() async {
    try {
      final Response searchResponse = await ApiService.search(query);

      this.searchResponse = SearchResultResponse.fromJson(searchResponse.data);

      finishLoading();
    } catch (err) {
      print("SearchRepository error");
      print(err);
      receivedError();
    }
  }
}
