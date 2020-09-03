import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/pick_point.dart';

import '../services/api_service.dart';
import 'base.dart';

class PickPointRepository extends BaseRepository<List<PickPoint>> {
  Future<void> getPickPoints() => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.getPickPoints()).data,
            (contentJson) => [for (final pickPoint in contentJson) PickPoint.fromJson(pickPoint)]);
      });
}
