import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cart/cart.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/services/api_service.dart';
import 'base.dart';

class AddProductToCartRepository extends BaseRepository {
  String productId;

  Future<void> update(String productId) => apiCall(
        () async {
          this.productId = productId;
          response =
              BaseResponse.fromJson((await ApiService.addProductToCart(productId)).data, null);
        },
      );
}

class RemoveItemFromCartRepository extends BaseRepository {
  Future<void> update(String itemId) => apiCall(
        () async {
          response =
              BaseResponse.fromJson((await ApiService.removeItemFromCart(itemId)).data, null);
        },
      );
}

class GetCartItemDeliveryTypesRepository extends BaseRepository<List<DeliveryType>> {
  Future<void> update(String itemId) => apiCall(
        () async {
          response = BaseResponse.fromJson((await ApiService.getCartItemDeliveryTypes(itemId)).data,
              (contentJson) => [for (final type in contentJson) DeliveryType.fromJson(type)]);
        },
      );
}

class SetCartItemDeliveryTypeRepository extends BaseRepository {
  Future<void> update(String itemId, String deliveryCompanyId, String deliveryObjectId) => apiCall(
        () async {
          response = BaseResponse.fromJson(
              (await ApiService.setCartItemDeliveryType(
                      itemId, deliveryCompanyId, deliveryObjectId))
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

  String selectionActionLabel;
  Function() selectionAction;

  bool canMakeOrder;

  CartRepository() {
    addProduct = AddProductToCartRepository();
    removeItem = RemoveItemFromCartRepository();

    getDeliveryTypes = GetCartItemDeliveryTypesRepository();
    setDeliveryType = SetCartItemDeliveryTypeRepository();

    selectedIDs = [];
    pendingIDs = [];

    selectionActionLabel = "";
    selectionAction = () {};

    canMakeOrder = false;

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

  updateSelectionAction() {
    final itemsWithSelectedDelivery = response?.content?.groups
        ?.where((cartItem) => cartItem.deliveryData != null && cartItem.deliveryOption != null)
        ?.toList();

    if (itemsWithSelectedDelivery != null && itemsWithSelectedDelivery.isNotEmpty) {
      if (selectedIDs.isNotEmpty) {
        selectionActionLabel = "Снять всё";
        selectionAction = () {
          itemsWithSelectedDelivery.forEach((cartItem) => cartItem.cartProducts
              .forEach((cartProduct) => select(cartProduct.product.id, value: false)));
        };
        canMakeOrder = true;
      } else {
        selectionActionLabel = "Выбрать всё";
        selectionAction = () {
          itemsWithSelectedDelivery.forEach((cartItem) => cartItem.cartProducts
              .forEach((cartProduct) => select(cartProduct.product.id, value: true)));
        };
        canMakeOrder = false;
      }
    } else {
      selectionActionLabel = "";
      selectionAction = () {};
      canMakeOrder = false;
    }

    notifyListeners();
  }

  bool select(String productId, {bool value}) {
    final group = response?.content?.findGroupOfProduct(productId);
    if (group == null) {
      return false;
    }

    final cartProduct = group.findProduct(productId);
    final id = cartProduct.product.id;

    if (group.deliveryData == null) {
      if (!pendingIDs.contains(id)) pendingIDs.add(id);

      return false;
    }

    cartProduct.update(value: value);

    final selected = cartProduct.selected.value;
    final wasSelected = selectedIDs.contains(id);

    if (selected && !wasSelected) {
      selectedIDs.add(id);
    } else if (!selected && wasSelected) selectedIDs.remove(id);

    updateSelectionAction();

    return true;
  }

  clearPendingIDs() {
    pendingIDs.clear();
  }

  bool checkPresence(String productId) => response?.content?.checkPresence(productId) ?? false;

  Future<void> addToCart(String productId) async {
    await addProduct.update(productId);
    if (addProduct.response.status.code == 201) await _update();
  }

  Future<void> setDelivery(String itemId, String deliveryCompanyId, String deliveryObjectId) async {
    await setDeliveryType.update(itemId, deliveryCompanyId, deliveryObjectId);
    if (setDeliveryType.response.status.code == 204) {
      if (pendingIDs.isEmpty) {
        final list = response.content
            ?.getGroup(itemId)
            ?.cartProducts
            ?.map((cartProduct) => cartProduct.id)
            ?.toList();

        if (list != null) pendingIDs.addAll(list);
      }
      await _update();
    }
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
          response = BaseResponse.fromJson(
              (await ApiService.getCart()).data, (contentJson) => Cart.fromJson(contentJson));

          [...pendingIDs, ...selectedIDs].forEach((productId) => select(productId, value: true));
          pendingIDs.clear();

          updateSelectionAction();
        },
      );
}
