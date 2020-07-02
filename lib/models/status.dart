class Status {
  final int code;

  const Status({this.code});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(code: json['code']);
  }

  int get getCode => code;
}
