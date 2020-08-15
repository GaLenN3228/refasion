import 'package:refashioned_app/models/status.dart';

class AuthorizationResponse {
  final Status status;
  final Authorization authorization;

  const AuthorizationResponse({this.status, this.authorization});

  factory AuthorizationResponse.fromJson(Map<String, dynamic> json) {
    return AuthorizationResponse(
        status: Status.fromJson(json['status']),
        authorization: (json['content'] != null) ? Authorization.fromJson(json['content']) : null);
  }
}

class Authorization {
  final String hash;

  const Authorization({this.hash});

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(hash: json['hash']);
  }
}
