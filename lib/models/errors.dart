class Errors {
  final String messages;

  const Errors({this.messages});

  factory Errors.fromJson(dynamic json) => Errors(messages: json.toString());

  String get getErrors => messages;
}
