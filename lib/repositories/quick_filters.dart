import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/quick_filter.dart';

import '../services/api_service.dart';
import 'base.dart';

class QuickFiltersRepository extends BaseRepository<List<QuickFilter>> {
  Future<void> getQuickFilters() => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getQuickFilters()).data,
            (contentJson) => [for (final filter in contentJson) QuickFilter.fromJson(filter)]);
      });

  update({String id, List<int> price}) {
    if (id != null && id.isNotEmpty)
      response.content.firstWhere((filterValue) => filterValue.values.id == id).update();
    else if (price != null) {
      response.content.firstWhere((filterValue) => filterValue.values.price != null).update();
    }
  }

  String getRequestParameters() {
    String requestParameters = "";
    if (response.content.any((filter) => filter.selected && filter.values.id != null))
      requestParameters = "&p=" +
          response.content
              .where((filter) => filter.selected && filter.values.id != null)
              .map((filter) => filter.values.id)
              .join('&');
    response.content.forEach((filter) {
      if (filter.selected && filter.values.price != null) {
        requestParameters += "&min_price=" + filter.values.price.first.toString();
        requestParameters += "&max_price=" + filter.values.price.last.toString();
      }
    });
    return requestParameters;
  }
}
