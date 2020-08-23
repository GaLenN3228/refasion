import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/search_result.dart';

import '../services/api_service.dart';
import 'base.dart';

class SearchRepository extends BaseRepository {
  Future<void> search(String query) => apiCall(() async {
        response = BaseResponse.fromJson(
            (await ApiService.search(query)).data, (contentJson) => SearchResultContent.fromJson(contentJson));
      });
}
