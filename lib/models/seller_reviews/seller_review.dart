import 'package:flutter/foundation.dart';

class SellerReview {
  final String sellerId;
  final String customerName;
  final DateTime createdAt;
  final int rating;
  final String text;

  const SellerReview(
      {this.createdAt, this.sellerId, @required this.customerName, @required this.rating, @required this.text});

  factory SellerReview.fromJson(Map<String, dynamic> json, {bool log: false}) {
    if (json == null) {
      if (log) print("SellerReview.fromJson: no json");
      return null;
    }

    try {
      final int rating = json['rating'];

      if (rating == null) {
        if (log) print("SellerReview.fromJson: no rating");
        return null;
      }

      final String text = json['text'];

      if (text == null || text.isEmpty) {
        if (log) print("SellerReview.fromJson: no text");
        return null;
      }

      DateTime createdAt;

      if (json['created_at'] == null) {
        if (log) print("SellerReview.fromJson: no created_at");
      } else {
        createdAt = DateTime.parse(json['created_at']);

        if (createdAt == null && log) print("SellerReview.fromJson: no created_at");
      }

      final customer = json['customer'];

      if (customer == null) {
        if (log) print("SellerReview.fromJson: no customer");
        return null;
      }

      final String customerName = customer['name'];

      if (customerName == null || customerName.isEmpty) {
        if (log) print("SellerReview.fromJson: no customer name");

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
