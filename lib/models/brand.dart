class Brand {
  final String id;
  final String name;
  final String image;

  const Brand(
      {this.image:
          "https://admin.refashioned.ru/media/product_brand/ddbd6c95-1d0d-4979-8534-113be732d0be_afc4698768304e63d7640a82468c69b4.png",
      this.id,
      this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'], name: json['name']);
  }

  String get getId => id;

  String get getName => name;
}
