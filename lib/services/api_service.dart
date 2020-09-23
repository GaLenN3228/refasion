import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:refashioned_app/screens/marketplace/marketplace_navigator.dart';
import 'package:refashioned_app/services/api/dio_client.dart';
import 'package:refashioned_app/utils/url.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ApiService {
  //FIXME set LOG_ENABLE = false in release build
  static const LOG_ENABLE = true;

  //ADDRESSES

  static const LOG_ADDRESSES = true;

  static Future<Response> findAddressesByQuery(String query, {String city}) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ADDRESSES || LOG_ENABLE);
    final queryParameters = {'q': query, 'city': city};
    return dioClient.get(Url.findAddressesByQuery, queryParameters: queryParameters);
  }

  static Future<Response> findAddressByCoordinates(Point coordinates) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ADDRESSES || LOG_ENABLE);
    final queryParameters = {'lat': coordinates.latitude, 'lon': coordinates.longitude};
    return dioClient.get(Url.findAddressByCoordinates, queryParameters: queryParameters);
  }

  //CART

  static const LOG_CART = false;

  static Future<Response> getCart() async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART || LOG_ENABLE);
    return dioClient.get(Url.cart);
  }

  static addProductToCart(String productId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART || LOG_ENABLE);
    final body = {"product": productId};
    return dioClient.post(Url.cart, data: body);
  }

  static removeItemFromCart(String itemId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART || LOG_ENABLE);
    final id = itemId + "/";
    return dioClient.delete(Url.cartItemProduct + id);
  }

  static getCartItemDeliveryTypes(String itemId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART || LOG_ENABLE);
    final path = itemId + "/delivery-types/";
    return dioClient.get(Url.cartItem + path);
  }

  static setCartItemDeliveryType(
      String itemId, String deliveryCompanyId, String deliveryObjectId) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CART || LOG_ENABLE);
    final path = itemId + "/delivery-types/";
    final data = jsonEncode({
      "delivery_company": deliveryCompanyId,
      "delivery_object_id": deliveryObjectId,
    });
    return dioClient.patch(Url.cartItem + path, data: data);
  }

  //CITIES

  static const LOG_CITIES = false;

  static Future<Response> getCities() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_CITIES || LOG_ENABLE);
    return dioClient.get(Url.getCities);
  }

  static Future<Response> getGeolocation() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_CITIES || LOG_ENABLE);
    return dioClient.get(Url.getGeolocation);
  }

  static Future<Response> selectCity(String city) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_CITIES || LOG_ENABLE);
    return dioClient.post(Url.selectCity, data: city);
  }

  //ORDERS

  static const LOG_ORDERS = false;

  static createOrder(String orderParameters) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ORDERS || LOG_ENABLE);
    return dioClient.post(Url.orders, data: orderParameters);
  }

  static getOrder(String id) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ORDERS || LOG_ENABLE);

    final path = id + "/";
    return dioClient.get(Url.orders + path);
  }

  static updateOrder(String id, String orderData) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_ORDERS || LOG_ENABLE);

    final path = id + "/";
    return dioClient.post(Url.orders + path, data: orderData);
  }

  //PRODUCT

  static const LOG_PRODUCT = true;

  static Future<Response> getProduct(String id) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_PRODUCT || LOG_ENABLE);
    return dioClient.get(Url.products + id + "/");
  }

  //USER ADDRESSES

  static const LOG_USER_ADDRESSES = false;

  static getUserAddresses() async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_USER_ADDRESSES || LOG_ENABLE);
    return dioClient.get(Url.userAddresses);
  }

  static getUserAddress(String id) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_USER_ADDRESSES || LOG_ENABLE);
    final path = id + "/";
    return dioClient.get(Url.userAddresses + path);
  }

  static addUserAddress(String json) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_USER_ADDRESSES || LOG_ENABLE);
    return dioClient.post(Url.userAddresses, data: json);
  }

  static removeUserAddress(String id) async {
    Dio dioClient =
        await DioClient().getClient(manageCookies: true, logging: LOG_USER_ADDRESSES || LOG_ENABLE);
    final path = id + "/";
    return dioClient.delete(Url.userAddresses + path);
  }

  //USER PICKPOINTS

  static const LOG_USER_PICKPOINTS = false;

  static getUserPickPoints() async {
    Dio dioClient = await DioClient()
        .getClient(manageCookies: true, logging: LOG_USER_PICKPOINTS || LOG_ENABLE);
    return dioClient.get(Url.userPickPoints);
  }

  static addUserPickPoint(String json) async {
    Dio dioClient = await DioClient()
        .getClient(manageCookies: true, logging: LOG_USER_PICKPOINTS || LOG_ENABLE);
    return dioClient.post(Url.userPickPoints, data: json);
  }

  //

  static Future<Response> getCategories() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.categories);
  }

  static Future<Response> getProducts({String parameters}) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.products + (parameters ?? ''));
  }

  static Future<Response> getSearchResults(String query) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.catalogSearch + query);
  }

  static Future<Response> getContentCatalogMenu() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.catalogMenu);
  }

  static Future<Response> getProductsCount({String parameters}) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.productsCount + (parameters ?? ''));
  }

  static Future<Response> getSellProperties({String category}) async {
    if (category == null) return null;

    return DioClient()
        .getClient(logging: LOG_ENABLE)
        .then((dio) => dio.get(Url.properties, queryParameters: {"category": category}));
  }

  static Future<Response> getFilters(String category) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.filters,
        queryParameters: category != null ? {"category": category} : null);
  }

  static Future<Response> getSortMethods() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.sortMethods);
  }

  static Future<Response> search(String query) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    var queryParameters = {
      'q': query,
    };
    return dioClient.get(Url.search, queryParameters: queryParameters);
  }

  static Future<Response> getQuickFilters() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.quickFilters);
  }

  static Future<Response> getProductRecommended(String id) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.productsRecommended(id));
  }

  static Future<Response> getPickPoints() async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.pickPoints);
  }

  static Future<Response> sendPhone(String phone) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    var body = {"phone": phone};
    return dioClient.post(Url.authorization, data: body);
  }

  static Future<Response> sendCode(String phone, String hash, String code) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"code": code};
    return dioClient.post(Url.codeAuthorization(phone, hash), data: body);
  }

  static Future<Response> getFavourites() async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.get(Url.wished);
  }

  static Future<Response> getFavouritesProducts() async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    return dioClient.get(Url.wishedProducts);
  }

  static Future<Response> addToFavourites(String productId) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"product": productId};
    return dioClient.post(Url.wished, data: body);
  }

  static Future<Response> removeFromFavourites(String productId) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"product": productId};
    return dioClient.delete(Url.wished, data: body);
  }

  static Future<Response> addProducts(ProductData productData) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {
      "name": productData.description,
      "description": productData.description,
      // "property_values": [
      //   "3fa85f64-5717-4562-b3fc-2c963f66afa6"
      // ],
      "brand": productData.brand.id,
      "category": productData.category.id,
      "current_price": productData.price,
      "discount_price": productData.price,
      // "size": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "seller": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "is_published": true
    };
    return dioClient.post(Url.addProduct, data: body);
  }

  static Future<Response> calcProductPrice(int price) async {
    Dio dioClient = await DioClient().getClient(manageCookies: true, logging: LOG_ENABLE);
    var body = {"price": price};
    return dioClient.post(Url.calcProductPrice, data: body);
  }

  static Future<Response> getCategoryBrands(String id) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.categoryBrands(id));
  }

  static Future<Response> getSizesTable(String categoryId) async {
    Dio dioClient = await DioClient().getClient(logging: LOG_ENABLE);
    return dioClient.get(Url.sizes(categoryId));
  }
}
