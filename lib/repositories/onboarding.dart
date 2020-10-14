import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/onbording.dart';
import 'package:refashioned_app/models/size.dart';
import 'package:refashioned_app/services/api_service.dart';
import 'base.dart';

class OnboardingRepository extends BaseRepository<OnboardingModel> {
  Future<void> getOnboardingData() => apiCall(() async {
    response =
        BaseResponse.fromJson((await ApiService.getOnboardingData()).data, (contentJson) {
          return OnboardingModel.fromJson(contentJson);
        });
  });
}
