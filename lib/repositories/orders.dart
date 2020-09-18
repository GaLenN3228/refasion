import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/order/order.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/services/api_service.dart';

class GetOrderRepository extends BaseRepository<Order> {
  Future<void> update(String id) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.getOrder(id)).data,
            (contentJson) => Order.fromJson(contentJson),
          );
        },
      );
}

class UpdateOrderRepository extends BaseRepository {
  Future<void> update(String id, String data) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.updateOrder(id, data)).data,
            null,
          );
        },
      );
}

class CreateOrderRepository extends BaseRepository<Order> {
  Future<void> update(String parameters) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.createOrder(parameters)).data,
            (contentJson) => Order.fromJson(contentJson),
          );
        },
      );
}
