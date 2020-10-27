import 'package:flutter/foundation.dart';

class SellerReview {
  final String sellerId;
  final String customerName;
  final DateTime createdAt;
  final int rating;
  final String text;

  const SellerReview(
      {this.createdAt, this.sellerId, @required this.customerName, @required this.rating, @required this.text});

  factory SellerReview.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      print("SellerReview.fromJson: no json");
      return null;
    }

    try {
      final int rating = json['rating'];

      if (rating == null) {
        print("SellerReview.fromJson: no rating");
        return null;
      }

      final String text = json['text'];

      if (text == null || text.isEmpty) {
        print("SellerReview.fromJson: no text");
        return null;
      }

      final createdAt = DateTime.parse(json['created_at']);

      if (createdAt == null) {
        print("SellerReview.fromJson: no created_at");
        return null;
      }

      final customer = json['customer'];

      if (customer == null) {
        print("SellerReview.fromJson: no customer");
        return null;
      }

      final String customerName = customer['name'];

      if (customerName == null || customerName.isEmpty) {
        print("SellerReview.fromJson: no customer name");

        return null;
      }

      return SellerReview(
        customerName: customerName,
        createdAt: createdAt,
        rating: rating,
        text: text,
      );
    } catch (err) {
      print("SellerReview.fromJson error: $err");

      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        "seller": sellerId,
        "rating": rating,
        "text": text,
      };
}
