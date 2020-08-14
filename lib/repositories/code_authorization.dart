import 'package:dio/dio.dart';
import 'package:refashioned_app/models/authorization.dart';

import '../services/api_service.dart';
import 'base.dart';

class CodeAuthorizationRepository extends BaseRepository {
  AuthorizationResponse authorizationResponse;

  final String phone;
  final String hash;
  final String code;

  CodeAuthorizationRepository(this.phone, this.hash, this.code);

  @override
  Future<void> loadData() async {
    try {
      final Response authorizationResponse = await ApiService.codeAuthorization(phone, hash, code);

      this.authorizationResponse = AuthorizationResponse.fromJson(authorizationResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
