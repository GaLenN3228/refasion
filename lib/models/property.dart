class Property {
  final String id;
  String value;
  final String property;

  Property({this.id, this.value, this.property});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(id: json['id'], value: json['value'], property: json['property']);
  }
}
