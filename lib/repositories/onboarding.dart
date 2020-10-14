import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/onboarding.dart';
import 'package:refashioned_app/services/api_service.dart';
import 'base.dart';

class OnBoardingRepository extends BaseRepository<List<OnBoardingModel>> {
  Future<void> getOnBoardingData() => apiCall(() async {
        response = BaseResponse.fromJson(
            (await ApiService.getOnboardingData()).data,
            (contentJson) =>
                [for (final onBoarding in contentJson) OnBoardingModel.fromJson(onBoarding)]);
      });
}
