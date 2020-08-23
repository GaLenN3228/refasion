class Authorization {
  final String hash;

  const Authorization({this.hash});

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(hash: json['hash']);
  }
}
