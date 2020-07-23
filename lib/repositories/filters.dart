import 'package:dio/dio.dart';
import 'package:refashioned_app/models/filter.dart';

import '../services/api_service.dart';
import 'base.dart';

class FiltersRepository extends BaseRepository {
  FiltersResponse filtersResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response filtersResponse = await ApiService.getFilters();

      this.filtersResponse = FiltersResponse.fromJson(filtersResponse.data);

      finishLoading();
    } catch (err) {
      print("FiltersRepository error:");
      print(err);
      receivedError();
    }
  }
}
