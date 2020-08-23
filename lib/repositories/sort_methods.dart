import 'package:dio/dio.dart';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/sort.dart';

import '../services/api_service.dart';
import 'base.dart';

class SortMethodsRepository extends BaseRepository<Sort> {
  Future<void> getSortMethods() => apiCall(() async {
        response = BaseResponse.fromJson(
            (await ApiService.getSortMethods()).data, (contentJson) => Sort.fromJson(contentJson));
      });
}
