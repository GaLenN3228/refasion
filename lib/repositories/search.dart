import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/repositories/SearchGeneralRepository.dart';

import '../services/api_service.dart';

class SearchRepository extends SearchGeneralRepository<SearchResultContent> {
  Future<void> search(String query) => callSearchApi(query, () async {
        response = BaseResponse.fromJson(
            (await ApiService.search(query)).data, (contentJson) => SearchResultContent.fromJson(contentJson));
        if (response.content.results.isEmpty) searchStatus = SearchStatus.EMPTY_DATA;
      });
}
