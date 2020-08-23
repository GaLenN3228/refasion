import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/quick_filter.dart';

import '../services/api_service.dart';
import 'base.dart';

class QuickFiltersRepository extends BaseRepository<List<QuickFilter>> {
  Future<void> getQuickFilters() => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getQuickFilters()).data,
            (contentJson) => [for (final filter in contentJson) QuickFilter.fromJson(filter)]);
      });

  update({String urlParams}) {
    if (urlParams != null && urlParams.isNotEmpty)
      response.content.firstWhere((filterValue) => filterValue.urlParams == urlParams).update();
  }

  String getRequestParameters() =>
      "&" + response.content.where((filter) => filter.selected).map((filter) => filter.urlParams).join('&');
}
