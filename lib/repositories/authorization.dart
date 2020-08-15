import 'package:dio/dio.dart';
import 'package:refashioned_app/models/authorization.dart';

import '../services/api_service.dart';
import 'base.dart';

class AuthorizationRepository extends BaseRepository {
  AuthorizationResponse authorizationResponse;

  final String phone;

  AuthorizationRepository(this.phone);

  @override
  Future<void> loadData() async {
    try {
      final Response authorizationResponse = await ApiService.authorization(phone);

      this.authorizationResponse = AuthorizationResponse.fromJson(authorizationResponse.data);

      finishLoading();
    } catch (err) {
      print(err);
      receivedError();
    }
  }
}
