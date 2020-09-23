import 'package:dio/dio.dart';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/filter.dart';
import '../services/api_service.dart';
import 'base.dart';

class FiltersRepository extends BaseRepository<List<Filter>> {
  Future<void> getFilters(String category) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getFilters(category)).data,
            (contentJson) => [for (final filter in contentJson) Filter.fromJson(filter)]);
      });
}
