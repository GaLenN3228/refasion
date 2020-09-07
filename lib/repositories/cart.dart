import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cart.dart';
import 'package:refashioned_app/services/api_service.dart';
import 'base.dart';

class AddProductToCartRepository extends BaseRepository {
  Future<void> update(String productId) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.addProductToCart(productId)).data, null);
        },
      );
}

class RemoveItemFromCartRepository extends BaseRepository {
  Future<void> update(String itemId) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.removeItemFromCart(itemId)).data, null);
        },
      );
}

class GetCartItemDeliveryTypesRepository extends BaseRepository {
  Future<void> update(String itemId) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.getCartItemDeliveryTypes(itemId)).data, null);
        },
      );
}

class SetCartItemDeliveryTypeRepository extends BaseRepository {
  Future<void> update(String itemId, String deliveryObjectId) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.setCartItemDeliveryType(
                      itemId, deliveryObjectId))
                  .data,
              null);
        },
      );
}

class CartRepository extends BaseRepository<Cart> {
  AddProductToCartRepository addProduct;
  RemoveItemFromCartRepository removeItem;

  GetCartItemDeliveryTypesRepository getDeliveryTypes;
  SetCartItemDeliveryTypeRepository setDeliveryType;

  CartRepository() {
    addProduct = AddProductToCartRepository();
    removeItem = RemoveItemFromCartRepository();

    getDeliveryTypes = GetCartItemDeliveryTypesRepository();
    setDeliveryType = SetCartItemDeliveryTypeRepository();

    _update();
  }

  @override
  dispose() {
    addProduct.dispose();
    removeItem.dispose();

    getDeliveryTypes.dispose();
    setDeliveryType.dispose();

    super.dispose();
  }

  bool checkPresence(String productId) =>
      response?.content?.checkPresence(productId) ?? false;

  Future<void> addToCart(String productId) async {
    await addProduct.update(productId);
    if (addProduct.response.status.code == 201) await _update();
  }

  Future<void> removeFromCart(String productId) async {
    final productItemId = this.response?.content?.getProductItemId(productId);

    // print("removeFromCart productItemId: " + productItemId.toString());
    if (productItemId != null) {
      await removeItem.update(productItemId);
      if (removeItem.response.status.code == 204) await _update();
    }
  }

  Future<void> getCartItemDeliveryTypes(String itemId) async {
    await getDeliveryTypes.update(itemId);
    // if (addProduct.isLoaded && addProduct.response.status.code == 201)
  }

  Future<void> _update() => apiCall(
        () async {
          response = BaseResponse.fromJson((await ApiService.getCart()).data,
              (contentJson) => Cart.fromJson(contentJson));
        },
      );
}
