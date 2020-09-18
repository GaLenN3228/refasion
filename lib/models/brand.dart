class Brand {
  final String id;
  final String name;
  final String image;

  bool selected;

  Brand({this.image, this.id, this.name, this.selected = false});

  update() {
    selected = !selected;
  }

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'], name: json['name'], image: json['image'] != null ? json['image'] : null);
  }

  String get getId => id;

  String get getName => name;
}
