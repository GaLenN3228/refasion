import 'package:dio/dio.dart';
import 'package:refashioned_app/models/catalog.dart';

import '../services/api_service.dart';
import 'base.dart';

class CatalogRepository extends BaseRepository {
  CatalogResponse catalogResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response catalogResponse = await ApiService.getCatalogCategories();

      this.catalogResponse = CatalogResponse.fromJson(catalogResponse.data);

      finishLoading();
    } catch (_) {
      receivedError();
    }
  }
}
