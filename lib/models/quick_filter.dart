class QuickFilter {
  final String name;
  final String urlParams;

  bool selected;

  QuickFilter({this.name, this.urlParams, this.selected: false});

  update() {
    selected = !selected;
  }

  factory QuickFilter.fromJson(Map<String, dynamic> json) {
    return QuickFilter(name: json['name'], urlParams: json['url_params']);
  }
}
