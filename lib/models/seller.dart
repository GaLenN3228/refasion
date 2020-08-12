class Seller {
  final String id;
  final String name;
  final double rating;
  final int reviewsCount;
  final String image;

  const Seller(
      {this.id, this.name, this.rating, this.reviewsCount, this.image});

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json['id'],
        name: json['name'],
        rating: json['rating'],
        reviewsCount: json['reviews_count'],
        image: json['image'],
      );

  @override
  String toString() {
    return "Продавец \nid: " +
        id.toString() +
        "\nname: " +
        name.toString() +
        "\nrating: " +
        rating.toString() +
        "\nreviews: " +
        reviewsCount.toString() +
        "\nimage: " +
        image.toString();
  }
}
