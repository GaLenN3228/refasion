import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cart/cart.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
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

class GetCartItemDeliveryTypesRepository
    extends BaseRepository<List<DeliveryData>> {
  Future<void> update(String itemId) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.getCartItemDeliveryTypes(itemId)).data,
              (contentJson) => [
                    for (final type in contentJson) DeliveryData.fromJson(type)
                  ]);
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

  List<String> selectedIDs;
  List<String> pendingIDs;

  CartRepository() {
    addProduct = AddProductToCartRepository();
    removeItem = RemoveItemFromCartRepository();

    getDeliveryTypes = GetCartItemDeliveryTypesRepository();
    setDeliveryType = SetCartItemDeliveryTypeRepository();

    selectedIDs = [];
    pendingIDs = [];

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

  bool select(String productId) {
    final group = response?.content?.getGroup(productId);
    if (group == null || group.products.isEmpty) return false;

    final cartProduct = group.getProduct(productId);
    final id = cartProduct.product.id;

    if (group.deliveryData == null) {
      if (!pendingIDs.contains(id)) pendingIDs.add(id);
      return false;
    }

    cartProduct.update();

    final selected = cartProduct.selected.value;
    final wasSelected = selectedIDs.contains(id);

    if (selected && !wasSelected)
      selectedIDs.add(id);
    else if (!selected && wasSelected) selectedIDs.remove(id);

    if (cartProduct.selected.value && !selectedIDs.contains(id))
      selectedIDs.add(id);

    return true;
  }

  bool checkPresence(String productId) =>
      response?.content?.checkPresence(productId) ?? false;

  Future<void> addToCart(String productId) async {
    await addProduct.update(productId);
    if (addProduct.response.status.code == 201) await _update();
  }

  Future<void> removeFromCart(String productId) async {
    final productItemId = this.response?.content?.getProductItemId(productId);

    if (productItemId != null) {
      await removeItem.update(productItemId);
      if (removeItem.response.status.code == 204) await _update();
    }
  }

  Future<void> getCartItemDeliveryTypes(String itemId) async {
    await getDeliveryTypes.update(itemId);
  }

  Future<void> _update() => apiCall(
        () async {
          response = BaseResponse.fromJson((await ApiService.getCart()).data,
              (contentJson) => Cart.fromJson(contentJson));

          if (selectedIDs.isNotEmpty)
            selectedIDs.forEach((productId) => select(productId));
        },
      );
}
