import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import 'base.dart';

class PickPointRepository extends BaseRepository<List<PickPoint>> {
  Future<void> getPickPoints() => apiCall(() async {
        var sp = await SharedPreferences.getInstance();
        response = BaseResponse.fromJson(
            (await ApiService.getPickPoints(sp.getString(Prefs.city_id))).data,
            (contentJson) => [for (final pickPoint in contentJson) PickPoint.fromJson(pickPoint)]);
      });
}
