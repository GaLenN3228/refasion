import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/search_result.dart';

import '../services/api_service.dart';
import 'base.dart';

class SearchRepository extends BaseRepository {
  String _query;

  String get query => _query;

  Future<void> search(String query) => apiCall(() async {
        _query = query;
        response = BaseResponse.fromJson(
            (await ApiService.search(query)).data, (contentJson) => SearchResultContent.fromJson(contentJson));
      });
}
