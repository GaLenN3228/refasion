import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/onboarding.dart';
import 'package:refashioned_app/services/api_service.dart';
import 'base.dart';

class OnBoardingRepository extends BaseRepository<List<OnBoardingModel>> {
  List<CachedNetworkImageProvider> cachedImages;

  Future<void> getOnBoardingData(BuildContext context) => apiCall(() async {
        response = BaseResponse.fromJson(
            (await ApiService.getOnboardingData()).data,
            (contentJson) =>
                [for (final onBoarding in contentJson) OnBoardingModel.fromJson(onBoarding)]);

        cachedImages = await _loadAllImages(context, response.content.map((e) => e.image).toList());
      });

  Future<List<CachedNetworkImageProvider>> _loadAllImages(BuildContext context, List<String> urls) async {
    List<CachedNetworkImageProvider> cachedImages = [];
    await Future.forEach(urls, (url) async {
      var configuration = createLocalImageConfiguration(context);
      var cachedImageProvider = CachedNetworkImageProvider(url);
      cachedImageProvider.resolve(configuration);
      cachedImages.add(cachedImageProvider);
    });

    return cachedImages;
  }
}
