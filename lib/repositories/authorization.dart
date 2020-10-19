import 'dart:io';

import 'package:refashioned_app/models/authorization.dart';
import 'package:refashioned_app/models/base.dart';

import '../services/api_service.dart';
import 'base.dart';

class AuthorizationRepository extends BaseRepository<Authorization> {
  String _phone;

  String get getPhone => _phone;

  //TODO combine methods

  Future<void> sendPhoneAndGetCode(String phone) => apiCall(() async {
        _phone = phone;
        response = BaseResponse.fromJson((await ApiService.sendPhone(phone)).data,
            (contentJson) => Authorization.fromJson(contentJson));
      });
}

class CodeAuthorizationRepository extends BaseRepository<Authorization> {
  Future<void> sendCode(String phone, String hash, String code) => apiCall(() async {
        response = BaseResponse.fromJson((await ApiService.sendCode(phone, hash, code)).data,
            (contentJson) => Authorization.fromJson(contentJson));
        if (response.getStatusCode == HttpStatus.ok) {
          await BaseRepository.setAuthorized(true);
          notifyListeners();
        }
      });
}

class LogoutRepository extends BaseRepository {
  Future<void> logout() => apiCall(() async {
    response = BaseResponse.fromJson((await ApiService.logout()).data,
            null);
    if (response.getStatusCode == HttpStatus.ok) {
      await BaseRepository.setAuthorized(false);
      notifyListeners();
    }
  });
}
