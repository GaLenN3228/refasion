import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/repositories/search_general_repository.dart';

import '../services/api_service.dart';

class SearchRepository extends SearchGeneralRepository<SearchResultContent> {
  Future<void> search(String query) => callSearchApi(query, () async {
        response = BaseResponse.fromJson(
            (await ApiService.search(query)).data, (contentJson) => SearchResultContent.fromJson(contentJson));
      });
}
