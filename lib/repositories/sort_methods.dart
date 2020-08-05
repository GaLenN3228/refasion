import 'package:dio/dio.dart';
import 'package:refashioned_app/models/sort.dart';

import '../services/api_service.dart';
import 'base.dart';

class SortMethodsRepository extends BaseRepository {
  SortMethodsResponse response;

  @override
  Future<void> loadData() async {
    try {
      final Response filtersResponse = await ApiService.getSortMethods();

      this.response = SortMethodsResponse.fromJson(filtersResponse.data);

      finishLoading();
    } catch (err) {
      print("SortMethodsRepository error:");
      print(err);
      receivedError();
    }
  }
}
