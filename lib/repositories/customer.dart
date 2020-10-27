import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/customer.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/services/api_service.dart';

class SetCustomerDataRepository extends BaseRepository<Customer> {
  Future<void> update(String json) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.setCustomerData(json)).data,
            (contentJson) => Customer.fromJson(contentJson),
          );
        },
      );
}

class GetCustomerDataRepository extends BaseRepository<Customer> {
  bool fullReload = true;

  GetCustomerDataRepository() {
    _update();
  }

  refresh({fullReload: false}) async => await _update(makeFullReload: fullReload);

  Future<void> _update({bool makeFullReload: true}) => apiCall(
        () async {
          fullReload = makeFullReload;

          response = BaseResponse.fromJson(
            (await ApiService.getCustomerData()).data,
            (contentJson) => Customer.fromJson(contentJson),
          );
        },
      );
}
