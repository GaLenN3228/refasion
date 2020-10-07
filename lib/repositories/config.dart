import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/config.dart';
import '../services/api_service.dart';
import 'base.dart';

class ConfigRepository extends BaseRepository<Config> {
  Future<void> update() => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.getConfig()).data,
            (contentJson) => Config.fromJson(contentJson),
          );
        },
      );
}
