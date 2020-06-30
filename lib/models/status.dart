class Status {
  final String code;

  const Status({this.code});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(code: json['code']);
  }

  String get getCode => code;
}
