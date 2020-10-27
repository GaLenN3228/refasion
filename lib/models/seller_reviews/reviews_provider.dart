import 'package:flutter/foundation.dart';
import 'package:refashioned_app/models/seller_reviews/seller_review.dart';

class SellerReviewsProvider {
  final int count;
  final String next;
  final String previous;
  final List<SellerReview> reviews;

  const SellerReviewsProvider._({@required this.reviews, @required this.count, this.next, this.previous});

  factory SellerReviewsProvider.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      print("SellerReviewsProvider.fromJson: no json");
      return null;
    }

    try {
      final int count = json['count'];

      if (count == null) {
        print("SellerReviewsProvider.fromJson: no count");
        return null;
      }

      if (json['results'] == null) {
        print("SellerReviewsProvider.fromJson: no results");
        return null;
      }

      final reviews = [
        for (final result in json['results']) SellerReview.fromJson(result),
      ].where((sellerReview) => sellerReview != null).toList();

      if (reviews.isEmpty) {
        print("SellerReviewsProvider.fromJson: no reviews");
        return null;
      }

      final String next = json['next'];
      final String previous = json['previous'];

      return SellerReviewsProvider._(
        count: count,
        next: next,
        previous: previous,
        reviews: reviews,
      );
    } catch (err) {
      print("SellerReviewsProvider.fromJson error: $err");

      return null;
    }
  }
}
