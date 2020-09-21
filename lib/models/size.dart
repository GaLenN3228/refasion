class SizesContent {
  final List<Sizes> sizes;

  SizesContent({this.sizes});

  factory SizesContent.fromJson(Map<String, dynamic> json) {
    return SizesContent(sizes: [for (final size in json['sizes']) Sizes.fromJson(size)]);
  }
}

class Sizes {
  final String code;
  final List<Values> values;

  Sizes({this.code, this.values});

  factory Sizes.fromJson(Map<String, dynamic> json) {
    return Sizes(
        code: json['code'], values: [for (final value in json['values']) Values.fromJson(value)]);
  }
}

class Values {
  final String id;
  final String value;

  Values({this.id, this.value});

  factory Values.fromJson(Map<String, dynamic> json) {
    return Values(id: json['id'], value: json['value']);
  }
}
