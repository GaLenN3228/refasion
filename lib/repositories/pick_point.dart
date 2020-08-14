import 'package:dio/dio.dart';
import 'package:refashioned_app/models/pick_point.dart';

import '../services/api_service.dart';
import 'base.dart';

class PickPointRepository extends BaseRepository {
  PickPointResponse pickPointResponse;

  @override
  Future<void> loadData() async {
    try {
      final Response pickPointResponse = await ApiService.getPickPoints();

      this.pickPointResponse = PickPointResponse.fromJson(pickPointResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
