import 'package:flutter/material.dart';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cart/cart.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/repositories/cart/add_product.dart';
import 'package:refashioned_app/repositories/cart/get_item_delivery_types.dart';
import 'package:refashioned_app/repositories/cart/remove_item.dart';
import 'package:refashioned_app/repositories/cart/set_item_delivery_type.dart';
import 'package:refashioned_app/services/api_service.dart';

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

  // List<int> scheme;
  // GlobalKey<AnimatedListState> rootListKey;

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

    // scheme = [1, 2];
    // rootListKey = GlobalKey<AnimatedListState>();

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

  // updateScheme() {
  //   scheme = response?.content?.groups?.map((cartItem) => cartItem.cartProducts.length)?.toList() ??
  //       [1, 2];

  //   notifyListeners();
  // }

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
        final groupProducts = response.content?.getGroup(itemId)?.cartProducts;

        final list = groupProducts?.fold(List<String>(), (oldList, cartProduct) {
          if (!cartProduct.selected.value) oldList.add(cartProduct.id);
          return oldList;
        });

        if (list != null && list?.length == groupProducts?.length) pendingIDs.addAll(list);
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
          // final seconds = 0;
          // updateScheme();

          // await Future.delayed(Duration(seconds: seconds));

          response = BaseResponse.fromJson(
              (await ApiService.getCart()).data, (contentJson) => Cart.fromJson(contentJson));

          // updateScheme();

          [...pendingIDs, ...selectedIDs].forEach((productId) => select(productId, value: true));
          pendingIDs.clear();

          updateSelectionAction();
        },
      );
}