import 'package:dio/dio.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/models/quick_filter.dart';

import '../services/api_service.dart';
import 'base.dart';

class QuickFiltersRepository extends BaseRepository {
  QuickFiltersResponse quickFiltersResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response filtersResponse = await ApiService.getQuickFilters();

      this.quickFiltersResponse = QuickFiltersResponse.fromJson(filtersResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
