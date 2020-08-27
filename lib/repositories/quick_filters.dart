import 'package:dio/dio.dart';
import 'package:refashioned_app/models/quick_filter.dart';
import '../services/api_service.dart';
import 'base.dart';

class QuickFiltersRepository extends BaseRepository {
  QuickFiltersResponse quickFiltersResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response filtersResponse = await ApiService.getQuickFilters();

      this.quickFiltersResponse =
          QuickFiltersResponse.fromJson(filtersResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }

  update({String urlParams}) {
    if (urlParams != null && urlParams.isNotEmpty)
      quickFiltersResponse.content
          .firstWhere((filterValue) => filterValue.urlParams == urlParams)
          .update();
  }

  String getRequestParameters() =>
      "&" +
      quickFiltersResponse.content
          .where((filter) => filter.selected)
          .map((filter) => filter.urlParams)
          .join('&');
}
