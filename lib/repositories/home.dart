import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/home.dart';

import '../services/api_service.dart';
import 'base.dart';

class HomeRepository extends BaseRepository<HomeContent> {
  Future<void> getHomePage() => apiCall(() async {
        response = BaseResponse.fromJson(
            (await ApiService.getHome()).data, (contentJson) => HomeContent.fromJson(contentJson));
      });
}
