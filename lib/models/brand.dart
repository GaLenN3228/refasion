class Brand {
  final String id;
  final String name;

  const Brand({this.id, this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'], name: json['name']);
  }

  String get getId => id;

  String get getName => name;
}
