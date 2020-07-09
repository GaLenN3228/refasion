
class Seller {
  final String id;
  final String name;
  final double rating;
  final int reviewsCounts;
  final String image;

  const Seller({this.id, this.name, this.rating, this.reviewsCounts, this.image});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      name: json['name'],
      rating: json['rating'],
      reviewsCounts: json['reviews_counts'],
      image: json['image'],
    );
  }
}
