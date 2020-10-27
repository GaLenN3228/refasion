import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/seller_reviews/reviews_provider.dart';
import 'package:refashioned_app/models/seller_reviews/seller_review.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/services/api_service.dart';

class AddUserReviewRepository extends BaseRepository<SellerReview> {
  Future<void> update(String json) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.addUserReview(json)).data,
            (contentJson) => SellerReview.fromJson(contentJson),
          );
        },
      );
}

class GetSellerReviewsRepository extends BaseRepository<SellerReviewsProvider> {
  final String id;

  bool fullReload = true;

  GetSellerReviewsRepository(this.id) {
    _update();
  }

  refresh({fullReload: false}) async => await _update(makeFullReload: fullReload);

  Future<void> _update({bool makeFullReload: true}) => apiCall(
        () async {
          fullReload = makeFullReload;

          response = BaseResponse.fromJson(
            (await ApiService.getSellerReviews(id)).data,
            (contentJson) => SellerReviewsProvider.fromJson(contentJson),
          );
        },
      );
}
