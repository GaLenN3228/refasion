import 'package:refashioned_app/models/errors.dart';
import 'package:refashioned_app/models/status.dart';

class BaseResponse<T> {
  final Status status;
  final T content;
  final Errors errors;

  const BaseResponse({this.status, this.content, this.errors});

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) contentParser) {
    return BaseResponse(
        status: Status.fromJson(json['status']),
        content: json['content'] != null && contentParser != null ? contentParser(json['content']) : null,
        errors: json['errors'] != null ? Errors.fromJson(json['errors']) : null);
  }

  int get getStatusCode => status.code;
}
